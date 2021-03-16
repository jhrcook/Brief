//
//  GeneralSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/22/21.
//

import os
import SwiftUI

struct GeneralSettingsView: View {
    let settingsManager: UserDefaultsManager
    let logger: Logger

    @AppStorage(UserDefaultsManager.Key.defaultSummaryRatio.rawValue) private var defaultSummaryRatio = 0.0
    @AppStorage(UserDefaultsManager.Key.clearInputAndOutput.rawValue) private var clearInputAndOutput: Bool = true
    @AppStorage(UserDefaultsManager.Key.summarizationOutputFormat.rawValue) private var summarizationOutputFormat: SummarizationOutputFormat = .orginalOrder

    @AppStorage(UserDefaultsManager.Key.touchbarIsActive.rawValue) private var touchbarIsActive = true

    var body: some View {
        VStack {
            Form {
                Group {
                    Toggle(isOn: $clearInputAndOutput) {
                        Text("Clear both input and summary text?")
                    }
                    Text("Turn off to only clear the input with the 'Clear' button.").font(.caption2).foregroundColor(.gray)
                }

                Picker("Order of summarized output.", selection: $summarizationOutputFormat) {
                    ForEach(SummarizationOutputFormat.allCases, id: \.self) { outputForm in
                        Text(outputForm.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Slider(value: $defaultSummaryRatio, in: 0.0 ... 1.0) {
                    Text("Default summary ratio ")
                    Text("\(defaultSummaryRatio * 100, specifier: "%.0f")%")
                        .bold()
                        .frame(width: 40)
                }

                Toggle(isOn: $touchbarIsActive) {
                    Text("Add controls to the touchbar.")
                }
            }
            .padding(20)
        }
        .frame(width: 500, height: 200)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView(settingsManager: UserDefaultsManager(), logger: Logger.settingsLogger)
    }
}
