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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            TextInputAndOutputView(input: $summarizer.inputText,
                                   output: summarizer.summarizedText)
                .padding(.horizontal)

            HStack {
                Button(action: summarizer.clear) {
                    Text("Clear")
                }
                .keyboardShortcut("b", modifiers: .command)

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
            summarizer.summaryRatio = UserDefaultsManager().read(key: .defaultSummaryRatio)
        }
    }

    private func copyButtonTapped() {
        let pbManager = PasteboardManager()
        pbManager.copyToClipboard(summarizer.summarizedText)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light Mode")

            ContentView()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark Mode")
        }
    }
}
