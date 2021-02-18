//
//  ContentView.swift
//  Brief
//
//  Created by Joshua on 1/18/21.
//

import AppKit
import SwiftUI

struct TextBackgroundModifier: ViewModifier {
    let colorScheme: ColorScheme

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(colorScheme == .light ? .white : .darkmodeSecondary)
            )
    }
}

struct TextFontModifier: ViewModifier {
    let fontName: String
    let fontSize: CGFloat
    let lineSpace: CGFloat
    let colorScheme: ColorScheme

    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ? .black : .white)
            .font(.custom(fontName, size: fontSize))
            .lineSpacing(lineSpace)
    }
}

extension View {
    func textBackground(colorScheme: ColorScheme) -> some View {
        modifier(TextBackgroundModifier(colorScheme: colorScheme))
    }

    func textFont(fontName: String, fontSize: CGFloat, lineSapce: CGFloat, colorScheme: ColorScheme) -> some View {
        modifier(TextFontModifier(fontName: fontName, fontSize: fontSize, lineSpace: lineSapce, colorScheme: colorScheme))
    }
}

struct TextInputAndOutputView: View {
    @Binding var input: String
    var output: String

    private let fontName = "HelveticaNeue"
    private let fontSize: CGFloat = 14
    private let textLineSpacing: CGFloat = 10

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        TextEditor(text: $input)
            .textFont(fontName: fontName, fontSize: fontSize, lineSapce: textLineSpacing, colorScheme: colorScheme)
            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50)
            .padding(8)
            .textBackground(colorScheme: colorScheme)
            .padding(.top, 8)

        Text(output)
            .textFont(fontName: fontName, fontSize: fontSize, lineSapce: textLineSpacing, colorScheme: colorScheme)
            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50)
            .padding(8)
            .textBackground(colorScheme: colorScheme)
            .padding(.top, 5)
    }
}

struct ContentView: View {
    @ObservedObject var summarizer = Summarizer()

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
