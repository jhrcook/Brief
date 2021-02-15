//
//  ContentView.swift
//  Brief
//
//  Created by Joshua on 1/18/21.
//

import AppKit
import SwiftUI

struct ContentView: View {
    @State var inputText: String = "Here is some text."
    @State var summarizedText: String = "This is the summary."
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
            TextEditor(text: $summarizedText)
                .font(.custom(fontName, size: fontSize))
                .padding(.horizontal)

            HStack {
                Button(action: {}) {
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

                Button(action: {}) {
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
