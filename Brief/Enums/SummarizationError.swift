//
//  SummarizationError.swift
//  Brief
//
//  Created by Joshua on 3/15/21.
//

import Foundation

enum SummarizationError: Error {
    case NotEnoughTextToSummarize(n: Int)
    case PageRankDidNotConverge(iterations: Int)
    case UnknownFailure
}

extension SummarizationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .NotEnoughTextToSummarize(n):
            return NSLocalizedString("Not enough sentences (\(n)) to run summarization.", comment: "Cannot Summarize")
        case let .PageRankDidNotConverge(iterations):
            return NSLocalizedString("PageRank did not converge after \(iterations) during summarization.", comment: "Did Not Converge")
        case .UnknownFailure:
            return NSLocalizedString("Unknown failure during summarization.", comment: "Unknown Error")
        }
    }
}
