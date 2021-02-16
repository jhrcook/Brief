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
    @Published var summarizedText = ""
    @Published var textRankConverged: Bool? = nil
    @Published var textRankIterations: Int? = nil

    let textrank = TextRank()

    let logger = Logger.summarizerLogger

    func summarize() {
        textrank.text = inputText
        do {
            let pageRankResult = try textrank.runPageRank()
            textRankConverged = pageRankResult.didConverge
            textRankIterations = pageRankResult.iterations
            if pageRankResult.didConverge {
                summarizedText = pageRankeResultToString(nodes: pageRankResult.results)
            }
        } catch {
            logger.error("PageRank failed: \(error.localizedDescription)")
        }
    }

    private func pageRankeResultToString(nodes: TextGraph.NodeList) -> String {
        var results: String = ""

        for sentence in nodes.keys {
            results += sentence.text + "\n"
        }

        return results
    }
}
