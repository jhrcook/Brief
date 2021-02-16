//
//  ContentView.swift
//  Brief
//
//  Created by Joshua on 1/18/21.
//

import AppKit
import SwiftUI

struct ContentView: View {
    @ObservedObject var summarizer = Summarizer()

    @State var inputText: String = ""
    @State var summaryRatio: Double = 0.25

    private let fontName = "HelveticaNeue"
    private let fontSize: CGFloat = 14

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            TextEditor(text: $inputText)
                .font(.custom(fontName, size: fontSize))
                .padding(.horizontal)
                .padding(.top)

            Text(summarizer.summarizedText)
                .font(.custom(fontName, size: fontSize))
                .frame(minHeight: 20)
                .padding(5)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(colorScheme == .light ? .white : .darkmodeSecondary)
                )
                .padding(.horizontal)
                .padding(.top, 5)

            HStack {
                Button(action: {
                    self.inputText = ""
                }) {
                    Text("Clear")
                }

                Spacer()

                HStack {
                    Slider(value: $summaryRatio, in: 0.0 ... 1.0)
                        .frame(minWidth: 30, idealWidth: 100, maxWidth: 100)
                    Text("\(summaryRatio, specifier: "%.2f")")
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .foregroundColor(colorScheme == .light ? .secondaryLightGray : .clear)
                )

                Button(action: {
                    summarizer.inputText = inputText
                    summarizer.summarize()
                }) {
                    Text("Summarize")
                }

                Button(action: {}) {
                    Image(systemName: "doc.on.doc")
                }
            }
            .padding()
        }
        .background(colorScheme == .light ? Color.lightGray : Color.black)
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
