//
//  TextInputAndOutputView.swift
//  Brief
//
//  Created by Joshua on 2/19/21.
//

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
    let lineSpacing: CGFloat
    let colorScheme: ColorScheme

    func body(content: Content) -> some View {
        content
            .foregroundColor(colorScheme == .light ? .black : .white)
            .font(.custom(fontName, size: fontSize))
            .multilineTextAlignment(.leading)
            .lineSpacing(lineSpacing)
    }
}

extension View {
    func textBackground(colorScheme: ColorScheme) -> some View {
        modifier(TextBackgroundModifier(colorScheme: colorScheme))
    }

    func textFont(fontName: String, fontSize: CGFloat, lineSapcing: CGFloat, colorScheme: ColorScheme) -> some View {
        modifier(TextFontModifier(fontName: fontName, fontSize: fontSize, lineSpacing: lineSapcing, colorScheme: colorScheme))
    }
}

struct TextInputAndOutputView: View {
    @Binding var input: String
    var output: String
    let settingsManager: UserDefaultsManager

    @AppStorage(UserDefaultsManager.Key.fontName.rawValue) private var fontName: String = ""
    @AppStorage(UserDefaultsManager.Key.fontSize.rawValue) private var fontSize: Double = 13
    @AppStorage(UserDefaultsManager.Key.lineSpacing.rawValue) private var lineSpacing: Double = 4

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack {
            TextEditor(text: $input)
                .textFont(fontName: fontName, fontSize: CGFloat(fontSize), lineSapcing: CGFloat(lineSpacing), colorScheme: colorScheme)
                .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50)
                .padding(8)
                .textBackground(colorScheme: colorScheme)
                .padding(.top, 8)

            ScrollView {
                Text(output)
                    .textFont(fontName: fontName, fontSize: CGFloat(fontSize), lineSapcing: CGFloat(lineSpacing), colorScheme: colorScheme)
                    .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50)
                    .padding(8)
                    .textBackground(colorScheme: colorScheme)
                    .padding(.top, 5)
            }
        }
    }
}

struct TextInputAndOutputView_Previews: PreviewProvider {
    static var previews: some View {
        TextInputAndOutputView(input: .constant("Some input text."), output: "Some output text.", settingsManager: UserDefaultsManager())
    }
}
