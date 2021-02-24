//
//  FontSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/22/21.
//

import SwiftUI

struct FontSettingsView: View {
    let settingsManager: UserDefaultsManager
    @State private var fontsizeString: String = "12"
    private var fontsize: CGFloat {
        CGFloat(Float(fontsizeString) ?? 12)
    }

    @State private var linespacingString: String = "3"
    private var linespacing: CGFloat {
        CGFloat(Float(linespacingString) ?? 3)
    }

    @State private var selectedFontIndex: Int = 0
    private let availableFonts = NSFontManager.shared.availableFontFamilies

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack {
            Spacer()

            Form {
                Section {
                    Picker("Font", selection: $selectedFontIndex) {
                        ForEach(availableFonts, id: \.self) { font in
                            Text(font).font(.custom(font, size: fontsize)).frame(height: 50)
                        }
                    }
                    .frame(width: 250)

                    HStack {
                        TextField("", text: $fontsizeString).frame(width: 40)
                        Text("Font size")
                    }

                    HStack {
                        TextField("", text: $linespacingString).frame(width: 40)
                        Text("Line spacing")
                    }
                }
            }

            Divider().padding(5)

            VStack(alignment: .leading) {
                Text("Example text")
                Text("Demonstration of font choices.\nOften there are multiple lines.")
                    .textFont(fontName: availableFonts[selectedFontIndex], fontSize: fontsize, lineSapce: linespacing, colorScheme: colorScheme)
                    .padding()
                    .textBackground(colorScheme: colorScheme)
            }

            Spacer()

            SettingsCancelAndSaveButtons(cancelAction: cancelButtonTapped, saveAction: saveButtonTapped)
                .padding()
        }
    }

    private func cancelButtonTapped() {
        close()
        loadSettings()
    }

    private func saveButtonTapped() {
        saveSettings()
        close()
    }

    private func loadSettings() {
        let fontname: String = settingsManager.read(key: .fontname)
        selectedFontIndex = availableFonts.firstIndex { $0 == fontname } ?? 0

        let savedFontsize: Float = settingsManager.read(key: .fontsize)
        fontsizeString = formatFloat(savedFontsize)

        let savedLinespacing: Float = settingsManager.read(key: .linespacing)
        linespacingString = formatFloat(savedLinespacing)
    }

    private func saveSettings() {
        settingsManager.write(value: availableFonts[selectedFontIndex], for: .fontname)

        if let fs = Float(fontsizeString) {
            settingsManager.write(value: fs, for: .fontsize)
        } else {
            print("Cannot save font size: \(fontsizeString)")
        }

        if let ls = Float(linespacingString) {
            settingsManager.write(value: ls, for: .linespacing)
        } else {
            print("Cannot save line spacing: \(linespacingString)")
        }
    }

    private func formatFloat(_ x: Float) -> String {
        let stringInt = "\(Int(x))"
        if Float(stringInt) == x {
            return stringInt
        } else {
            return String(format: "%.1f", x)
        }
    }
}

struct FontSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FontSettingsView(settingsManager: UserDefaultsManager())
    }
}
