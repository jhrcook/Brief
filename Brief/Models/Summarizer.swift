//
//  Summarizer.swift
//  Brief
//
//  Created by Joshua on 2/16/21.
//

import AppKit
import os
import SwiftUI
import TextRank

class Summarizer: ObservableObject {
    @Published var inputText = ""
    @Published var summaryRatio: Float = 0.20
    var summarizedText: String {
        guard let pr = pageRankResult else { return "" }
        return summarizePageRankResult(pr, reduceTo: summaryRatio)
    }

    @Published var textRankConverged: Bool?
    @Published var textRankIterations: Int?

    let textrank = TextRank()

    var pageRankResult: TextGraph.PageRankResult? {
        didSet {
            if pageRankResult == nil { return }
            summaryRatio += 0.001
        }
    }

    let logger = Logger.summarizerLogger

    var summarizationOutputFormat: SummarizationOutputFormat = .orginalOrder {
        didSet {
            summarize()
        }
    }

    #if DEBUG
        init() {
            inputText = Summarizer.mockInputText()
            summarize()
        }
    #endif

    func summarize() {
        logger.info("Running PageRank summarization.")
        textrank.text = inputText

        if textrank.sentences.count < 4 { return }

        do {
            let pageRankResult = try textrank.runPageRank()
            textRankConverged = pageRankResult.didConverge
            textRankIterations = pageRankResult.iterations
            if pageRankResult.didConverge {
                self.pageRankResult = pageRankResult
            }
        } catch {
            logger.error("PageRank failed: \(error.localizedDescription)")
        }
    }

    private func summarizePageRankResult(_ PRResult: TextGraph.PageRankResult, reduceTo percentile: Float) -> String {
        let filteredNodelist = textrank.filterTopSentencesFrom(PRResult, top: percentile)

        var sortedSentences = [Sentence]()
        switch summarizationOutputFormat {
        case .byImportance:
            sortedSentences = Array(filteredNodelist.keys)
                .sorted { filteredNodelist[$0]! > filteredNodelist[$1]! }

        case .orginalOrder:
            sortedSentences = filteredNodelist
                .keys
                .sorted { $0.originalTextIndex < $1.originalTextIndex }
        }

        return pageRankResultToString(sentences: sortedSentences)
    }

    private func pageRankResultToString(sentences: [Sentence]) -> String {
        var results: String = ""

        for (idx, sentence) in sentences.enumerated() {
            results += sentence.text + (idx == sentences.count - 1 ? "" : "\n\n")
        }

        return results
    }
}

extension Summarizer {
    func clear(withUndoManager undoManager: UndoManager? = nil, clearOutput: Bool = true) {
        let copyOfInputText = inputText
        if let undoManager = undoManager {
            logger.info("Registering undo action for clear.")
            undoManager.registerUndo(withTarget: self) { _ in
                self.inputText = copyOfInputText
                self.summarize()
            }
            undoManager.setActionName("Clear")
        }
        logger.info("Clearing text.")
        inputText = ""
        if clearOutput {
            pageRankResult = nil
        }
    }
}

#if DEBUG
    extension Summarizer {
        static func mockInputText() -> String {
            """
            Swifts are among the fastest of birds, and larger species like the white-throated needletail have been reported travelling at up to 169 km/h (105 mph) in level flight. Even the common swift can cruise at a maximum speed of 31 metres per second (112 km/h; 70 mph). In a single year the common swift can cover at least 200,000 km and in a lifetime, about two million kilometers; enough to fly to the Moon five times over.
            The wingtip bones of swiftlets are of proportionately greater length than those of most other birds. Changing the angle between the bones of the wingtips and forelimbs allows swifts to alter the shape and area of their wings to increase their efficiency and maneuverability at various speeds. They share with their relatives the hummingbirds a unique ability to rotate their wings from the base, allowing the wing to remain rigid and fully extended and derive power on both the upstroke and downstroke. The downstroke produces both lift and thrust, while the upstroke produces a negative thrust (drag) that is 60% of the thrust generated during the downstrokes, but simultaneously it contributes lift that is also 60% of what is produced during the downstroke. This flight arrangement might benefit the bird's control and maneuverability in the air.
            The swiftlets or cave swiftlets have developed a form of echolocation for navigating through dark cave systems where they roost. One species, the Three-toed swiftlet, has recently been found to use this navigation at night outside its cave roost too.
            """
        }
    }
#endif
