//
//  ContentView.swift
//  Brief
//
//  Created by Joshua on 1/18/21.
//

import AppKit
import os
import SwiftUI

struct NotificationBanner: View {
    @Binding var text: String

    @Environment(\.colorScheme) var colorScheme

    var shadowColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.4) : Color.black.opacity(0.5)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(systemName: "bell.fill")
                .padding(6)
                .background(
                    Circle()
                        .modifier(BackgroundModifier(shadowColor: shadowColor))
                )
            Text(text)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .modifier(BackgroundModifier(shadowColor: shadowColor))
                )
        }
    }

    struct BackgroundModifier: ViewModifier {
        var shadowColor: Color
        func body(content: Content) -> some View {
            content
                .foregroundColor(.gray)
                .shadow(color: shadowColor, radius: 5, x: -1, y: 2)
        }
    }
}

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
                summarizer.summarize()
            } else {
                logger.error("SummariztionOutputFormat not available: \(summarizationOutputFormat, privacy: .public)")
            }
        }
    }

    private func clearButtonTapped() {
        summarizer.clear(withUndoManager: undoManager, clearOutput: settingsManager.read(key: .clearInputAndOutput))
    }

    private func undoClearButtonTapped() {
        undoManager?.undo()
    }

    private func copyButtonTapped() {
        notificationText = "Copied summary"
        animateNotification()
        let pbManager = PasteboardManager()
        pbManager.copyToClipboard(summarizer.summarizedText)
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
