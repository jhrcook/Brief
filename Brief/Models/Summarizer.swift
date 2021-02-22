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
        let x = textrank
            .filterTopSentencesFrom(PRResult, top: percentile)
            .keys
            .sorted { $0.originalTextIndex < $1.originalTextIndex }
        return pageRankResultToString(sentences: x)
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
    func clear(withUndoManager undoManager: UndoManager? = nil) {
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
        pageRankResult = nil
    }
}

#if DEBUG
    extension Summarizer {
        static func mockInputText() -> String {
            "All swifts eat insects, such as dragonflies, flies, ants, aphids, wasps and bees as well as aerial spiders. Prey is typically caught in flight using the beak. Some species, like the chimney swift, hunt in mixed species flocks with other aerial insectivores such as members of Hirundinidae (swallows). No swift species has become extinct since 1600, but BirdLife International has assessed the Guam swiftlet as endangered and lists the Atiu, dark-rumped, Schouteden's, Seychelles, and Tahiti swiftlets as vulnerable. Twelve other species are near threatened or lack sufficient data for classification."
        }
    }
#endif
