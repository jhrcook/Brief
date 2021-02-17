//
//  ContentView.swift
//  Brief
//
//  Created by Joshua on 1/18/21.
//

import AppKit
import SwiftUI

struct TextBackground: ViewModifier {
    let colorScheme: ColorScheme

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(colorScheme == .light ? .white : .darkmodeSecondary)
            )
    }
}

extension View {
    func textBackground(colorScheme: ColorScheme) -> some View {
        modifier(TextBackground(colorScheme: colorScheme))
    }
}

struct ContentView: View {
    @ObservedObject var summarizer = Summarizer()

    private let fontName = "HelveticaNeue"
    private let fontSize: CGFloat = 14

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            TextEditor(text: $summarizer.inputText)
                .font(.custom(fontName, size: fontSize))
                .padding(5)
                .textBackground(colorScheme: colorScheme)
                .padding(.horizontal)
                .padding(.top)

            Text(summarizer.summarizedText)
                .font(.custom(fontName, size: fontSize))
                .frame(minHeight: 20)
                .padding(5)
                .textBackground(colorScheme: colorScheme)
                .padding(.horizontal)
                .padding(.top, 5)

            HStack {
                Button(action: clearButtonTapped) {
                    Text("Clear")
                }

                Spacer()

                HStack {
                    Slider(value: $summarizer.summaryRatio, in: 0.0 ... 1.0)
                        .frame(minWidth: 30, idealWidth: 100, maxWidth: 100)
                    Text("\(summarizer.summaryRatio, specifier: "%.2f")")
                        .foregroundColor(.secondary)
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
