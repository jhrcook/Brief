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
                Button(action: clearButtonTapped) {
                    Text("Clear")
                }

                Spacer()

                HStack {
                    Text("\(summarizer.summaryRatio, specifier: "%.2f")")
                        .foregroundColor(.secondary)
                    Slider(value: $summarizer.summaryRatio, in: 0.0 ... 1.0)
                        .frame(minWidth: 30, idealWidth: 100, maxWidth: 100)
                }
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .foregroundColor(colorScheme == .light ? .secondaryLightGray : .clear)
                )

                Button(action: summarizeButtonTapped) {
                    Text("Summarize")
                }

                Button(action: copyButtonTapped) {
                    Image(systemName: "doc.on.doc")
                }
            }
            .padding()
        }
        .background(colorScheme == .light ? Color.lightGray : Color.black)
    }
}

extension ContentView {
    func clearButtonTapped() {
        summarizer.inputText = ""
    }

    func summarizeButtonTapped() {
        summarizer.summarize()
    }

    func copyButtonTapped() {}
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
