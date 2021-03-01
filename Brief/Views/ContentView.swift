//
//  ContentView.swift
//  Brief
//
//  Created by Joshua on 1/18/21.
//

import AppKit
import SwiftUI

struct ContentView: View {
    @StateObject var summarizer = Summarizer()
    let settingsManager: UserDefaultsManager
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.undoManager) var undoManager

    var body: some View {
        VStack {
            TextInputAndOutputView(input: $summarizer.inputText,
                                   output: summarizer.summarizedText,
                                   settingsManager: settingsManager)
                .padding(.horizontal)

            HStack {
                Button(action: clearButtonTapped) {
                    Text("Clear")
                }
                .keyboardShortcut("b", modifiers: .command)

                Button(action: undoClearButtonTapped) {
                    Image(systemName: "arrow.uturn.left.circle")
                        .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(undoManager == nil || !(undoManager?.canUndo ?? false))

                Spacer()

                HStack {
                    Text("\(summarizer.summaryRatio * 100, specifier: "%.0f")%")
                        .foregroundColor(.secondary)
                    Slider(value: $summarizer.summaryRatio, in: 0.0 ... 1.0)
                        .frame(minWidth: 30, idealWidth: 100, maxWidth: 100)
                }
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .foregroundColor(colorScheme == .light ? .secondaryLightGray : .clear)
                )

                Button(action: summarizer.summarize) {
                    Text("Summarize")
                }

                Button(action: copyButtonTapped) {
                    Image(systemName: "doc.on.doc")
                }
                .disabled(summarizer.summarizedText.isEmpty)
            }
            .padding()
        }
        .background(colorScheme == .light ? Color.lightGray : Color.black)
        .focusedValue(\.focusedSummarizer, summarizer)
        .onAppear {
            summarizer.summaryRatio = settingsManager.read(key: .defaultSummaryRatio)
        }
    }

    private func clearButtonTapped() {
        summarizer.clear(withUndoManager: undoManager, clearOutput: settingsManager.read(key: .clearInputAndOutput))
    }

    private func undoClearButtonTapped() {
        undoManager?.undo()
    }

    private func copyButtonTapped() {
        let pbManager = PasteboardManager()
        pbManager.copyToClipboard(summarizer.summarizedText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(settingsManager: UserDefaultsManager())
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light Mode")

            ContentView(settingsManager: UserDefaultsManager())
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
