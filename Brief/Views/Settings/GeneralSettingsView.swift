//
//  GeneralSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/22/21.
//

import SwiftUI

struct GeneralSettingsView: View {
    let settingsManager: UserDefaultsManager

    @State private var defaultSummaryRatio = 0.0
    @State private var clearInputAndOutput: Bool = true

    var body: some View {
        VStack {
            Form {
                Toggle(isOn: $clearInputAndOutput, label: {
                    Text("Clear both input and summary text?")
                })

                Slider(value: $defaultSummaryRatio, in: 0.0 ... 1.0) {
                    Text("Default summary ratio ")
                    Text("\(defaultSummaryRatio * 100, specifier: "%.0f")%").bold().frame(width: 40)
                }
            }
            .padding(20)
        }
        .frame(width: 500, height: 150)
        .onAppear {
            loadSettings()
        }
        .onDisappear {
            writeSettings()
        }
    }

    private func loadSettings() {
        defaultSummaryRatio = Double(settingsManager.read(key: .defaultSummaryRatio))
        clearInputAndOutput = settingsManager.read(key: .clearInputAndOutput)
    }

    private func writeSettings() {
        settingsManager.write(value: Float(defaultSummaryRatio), for: .defaultSummaryRatio)
        settingsManager.write(value: clearInputAndOutput, for: .clearInputAndOutput)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView(settingsManager: UserDefaultsManager())
    }
}
