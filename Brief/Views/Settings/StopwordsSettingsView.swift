//
//  StopwordsSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/23/21.
//

import SwiftUI

struct MinusButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(6)
            .background(Circle().foregroundColor(.red))
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

struct StopwordsSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            Text("These words will be removed from sentences used by the summarization algorithm.").font(.caption)
            List {
                ForEach(0 ... 50, id: \.self) { i in
                    HStack {
                        Button(action: {}, label: {
                            Image(systemName: "minus")
                        })
                            .font(.footnote)
                            .buttonStyle(MinusButtonStyle())
                        Text("Text \(i)")
                    }
                    Divider()
                }
            }
            .listStyle(PlainListStyle())
            .padding(5)
            .background(
                Rectangle()
                    .stroke(Color.darkmodeDividerGray, style: StrokeStyle(lineWidth: 1.5))
                    .opacity(colorScheme == .light ? 0.0 : 1.0)
            )

            Button(action: plusButtonTapped) {
                Image(systemName: "plus")
            }
        }
        .padding()
        .frame(width: 500, height: 500)
    }

    func plusButtonTapped() {
        print("plus")
    }
}

struct StopwordsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        StopwordsSettingsView().previewLayout(.fixed(width: 500, height: 500))
    }
}
