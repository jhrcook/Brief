//
//  BriefCommands.swift
//  Brief
//
//  Created by Joshua on 2/19/21.
//

import SwiftUI

struct BriefCommands: Commands {
    private struct MenuContent: View {
        @FocusedValue(\.focusedSummarizer) var summarizer
        @Environment(\.undoManager) var undoManager

        var body: some View {
            Button("Summarize Text") {
                summarizer?.summarize()
            }
            .keyboardShortcut("r", modifiers: .command)
            .disabled(summarizer?.inputText.isEmpty ?? true || summarizer == nil)

            Button("Copy Summary") {
                guard let s = summarizer else { return }
                PasteboardManager().copyToClipboard(s.summarizedText)
            }
            .keyboardShortcut("c", modifiers: [.command, .option])
            .disabled(summarizer == nil || summarizer?.summarizedText.isEmpty ?? true)

            Divider()

            Button("Reduce ratio") {
                if let s = summarizer {
                    s.summaryRatio = max(0.0, s.summaryRatio - 0.1)
                }
            }
            .keyboardShortcut(KeyEquivalent("-"), modifiers: [.command, .shift])
            .disabled(summarizer == nil)

            Button("Increase ratio") {
                if let s = summarizer {
                    s.summaryRatio = min(1.0, s.summaryRatio + 0.1)
                }
            }
            .keyboardShortcut(KeyEquivalent("+"), modifiers: [.command, .shift])
            .disabled(summarizer == nil)

            Button("Clear") {
                summarizer?.clear(withUndoManager: undoManager)
            }
            .keyboardShortcut("b", modifiers: .command)
            .disabled(summarizer == nil)
        }
    }

    var body: some Commands {
        CommandMenu("Summarization") {
            MenuContent()
        }
    }
}

private struct SummarizerKey: FocusedValueKey {
    typealias Value = Summarizer
}

extension FocusedValues {
    var focusedSummarizer: Summarizer? {
        get { self[SummarizerKey].self }
        set { self[SummarizerKey].self = newValue }
    }
}
