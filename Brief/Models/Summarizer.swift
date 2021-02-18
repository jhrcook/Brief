//
//  Summarizer.swift
//  Brief
//
//  Created by Joshua on 2/16/21.
//

import Combine
import Foundation
import os
import TextRank

class Summarizer: ObservableObject {
    @Published var inputText = ""
    @Published var summaryRatio: Float = 0.20
    @Published var summarizedText = ""
    @Published var textRankConverged: Bool? = nil
    @Published var textRankIterations: Int? = nil

    let textrank = TextRank()

    let logger = Logger.summarizerLogger

    #if DEBUG
        init() {
            inputText = Summarizer.mockInputText()
            summarize()
        }
    #endif

    func summarize() {
        textrank.text = inputText

        if textrank.sentences.count < 4 { return }

        do {
            let pageRankResult = try textrank.runPageRank()
            textRankConverged = pageRankResult.didConverge
            textRankIterations = pageRankResult.iterations
            if pageRankResult.didConverge {
                let filteredSentences = textrank
                    .filterTopSentencesFrom(pageRankResult, top: summaryRatio)
                    .keys
                    .sorted { $0.originalTextIndex < $1.originalTextIndex }
                summarizedText = pageRankeResultToString(sentences: filteredSentences)
            }
        } catch {
            logger.error("PageRank failed: \(error.localizedDescription)")
        }
    }

    private func pageRankeResultToString(sentences: [Sentence]) -> String {
        var results: String = ""

        for (idx, sentence) in sentences.enumerated() {
            results += sentence.text + (idx == sentences.count - 1 ? "" : "\n")
        }

        return results
    }
}

#if DEBUG
    extension Summarizer {
        static func mockInputText() -> String {
            "All swifts eat insects, such as dragonflies, flies, ants, aphids, wasps and bees as well as aerial spiders. Prey is typically caught in flight using the beak. Some species, like the chimney swift, hunt in mixed species flocks with other aerial insectivores such as members of Hirundinidae (swallows). No swift species has become extinct since 1600, but BirdLife International has assessed the Guam swiftlet as endangered and lists the Atiu, dark-rumped, Schouteden's, Seychelles, and Tahiti swiftlets as vulnerable. Twelve other species are near threatened or lack sufficient data for classification."
        }
    }
#endif
