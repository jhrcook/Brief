//
//  ContentView.swift
//  Brief
//
//  Created by Joshua on 1/18/21.
//

import AppKit
import os
import SwiftUI
import TextRank

struct ContentView: View {
    // MARK: Persistent objects.

    @StateObject var summarizer = Summarizer()
    let logger = Logger.contentViewLogger
    let settingsManager: UserDefaultsManager

    // MARK: App storage (user settings) variables.

    @AppStorage(UserDefaultsManager.Key.summarizationOutputFormat.rawValue) private var summarizationOutputFormat: String = ""
    @AppStorage(UserDefaultsManager.Key.stopwords.rawValue) private var stopwords = [String]()

    // MARK: State objects.

    @State private var showNotification: Bool = false
    @State private var notificationText: String = ""

    // MARK: Environment objects.

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.undoManager) var undoManager

    var body: some View {
        ZStack {
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
                    .disabled(summarizer.inputText.isEmpty && summarizer.summarizedText.isEmpty)

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

                    Button(action: summarizerButtonTapped) {
                        Text("Summarize")
                    }

                    Button(action: copyButtonTapped) {
                        Image(systemName: "doc.on.doc")
                    }
                    .disabled(summarizer.summarizedText.isEmpty)
                }
                .padding()
            }

            VStack {
                HStack {
                    Spacer()
                    NotificationBanner(text: $notificationText)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 10)
                        .offset(x: 0, y: showNotification ? 0 : -50)
                        .opacity(showNotification ? 1.0 : 0)
                }
                Spacer()
            }
        }
        .background(colorScheme == .light ? Color.lightGray : Color.black)
        .focusedValue(\.focusedSummarizer, summarizer)
        .onAppear {
            summarizer.summaryRatio = settingsManager.read(key: .defaultSummaryRatio)
            summarizer.summarizationOutputFormat = settingsManager.readSummarizationOutputFormat()
        }
        .onChange(of: stopwords) { _ in
            summarizer.setStopwords(stopwords)
        }
        .onChange(of: summarizationOutputFormat) { _ in
            if let outputFormat = SummarizationOutputFormat(rawValue: summarizationOutputFormat) {
                logger.info("Changing summarization output format to '\(outputFormat.rawValue, privacy: .public)'")
                summarizer.summarizationOutputFormat = outputFormat
                summarizerButtonTapped()
            } else {
                logger.error("SummariztionOutputFormat not available: \(summarizationOutputFormat, privacy: .public)")
            }
        }
        .touchBar {
            Button(action: clearButtonTapped) {
                Text("Clear")
            }
            .disabled(summarizer.inputText.isEmpty && summarizer.summarizedText.isEmpty)

            Button(action: undoClearButtonTapped) {
                Text("Undo")
            }
            .disabled(undoManager == nil || !(undoManager?.canUndo ?? false))

            HStack {
                Text("\(summarizer.summaryRatio * 100, specifier: "%.0f")%")
                    .multilineTextAlignment(.trailing)
                    .frame(width: 45)
                Slider(value: $summarizer.summaryRatio, in: 0.0 ... 1.0)
                    .frame(width: 170)
            }

            Button(action: summarizerButtonTapped) {
                Text("Summarize")
            }

            Button(action: copyButtonTapped) {
                Image(systemName: "doc.on.doc")
            }
            .disabled(summarizer.summarizedText.isEmpty)
        }
    }
}

// MARK: - Button handlers

extension ContentView {
    private func clearButtonTapped() {
        summarizer.clear(withUndoManager: undoManager, clearOutput: settingsManager.read(key: .clearInputAndOutput))
    }

    private func undoClearButtonTapped() {
        undoManager?.undo()
    }

    private func summarizerButtonTapped() {
        do {
            try summarizer.summarize()
        } catch let SummarizationError.NotEnoughTextToSummarize(n) {
            logger.info("Summarization attempted with too few sentences (\(n, privacy: .public)).")
            notification("Not enough to summarize")
        } catch TextGraph.PageRankError.EmptyEdgeList, TextGraph.PageRankError.EmptyNodeList {
            logger.info("Summarization attempted with too few sentences.")
            notification("Not enough to summarize")
        } catch let SummarizationError.PageRankDidNotConverge(iterations) {
            logger.error("PageRank did not converge after \(iterations, privacy: .public) iterations.")
            notification("Algorithm did not converge")
        } catch {
            logger.error("Unknown error during summarization: \(error.localizedDescription, privacy: .public)")
            notification("Unknown error")
        }
    }

    private func copyButtonTapped() {
        notification("Copied summary")
        let pbManager = PasteboardManager()
        pbManager.copyToClipboard(summarizer.summarizedText)
    }
}

// MARK: - Notification system

extension ContentView {
    private func notification(_ text: String) {
        notificationText = text
        if showNotification {
            showNotification = false
        }
        animateNotification()
    }

    private func animateNotification(delay: Double = 4.0) {
        withAnimation {
            showNotification = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation {
                showNotification = false
            }
        }
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
