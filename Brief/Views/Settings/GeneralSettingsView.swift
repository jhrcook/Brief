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

    @State private var defaultSummaryRatio = 0.0
    @State private var clearInputAndOutput: Bool = true
    @State private var summarizationOutputFormat: SummarizationOutputFormat = .orginalOrder

    var body: some View {
        VStack {
            Form {
                Group {
                    Toggle(isOn: $clearInputAndOutput, label: {
                        Text("Clear both input and summary text?")
                    })
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
                    Text("\(defaultSummaryRatio * 100, specifier: "%.0f")%").bold().frame(width: 40)
                }
            }
            .padding(20)
        }
        .frame(width: 500, height: 200)
        .onAppear {
            loadSettings()
        }
        .onChange(of: defaultSummaryRatio) { _ in
            saveDefaultSummaryRatio()
        }
        .onChange(of: clearInputAndOutput) { _ in
            saveClearInputAndOutputOption()
        }
        .onChange(of: summarizationOutputFormat) { _ in
            saveSummarizationOutputFormat()
        }
    }

    private func loadSettings() {
        logger.info("Loading general settings.")
        defaultSummaryRatio = Double(settingsManager.read(key: .defaultSummaryRatio))
        clearInputAndOutput = settingsManager.read(key: .clearInputAndOutput)
        summarizationOutputFormat = settingsManager.readSummarizationOutputFormat()
    }

    private func saveDefaultSummaryRatio() {
        logger.info("Saving default summary ratio: \(defaultSummaryRatio, privacy: .public)")
        settingsManager.write(value: Float(defaultSummaryRatio), for: .defaultSummaryRatio)
    }

    private func saveClearInputAndOutputOption() {
        logger.info("Saving clearing option: \(clearInputAndOutput ? "clear both" : "just input", privacy: .public)")
        settingsManager.write(value: clearInputAndOutput, for: .clearInputAndOutput)
    }

    private func saveSummarizationOutputFormat() {
        logger.info("Saving summarization output format: \(summarizationOutputFormat.rawValue)")
        settingsManager.write(value: summarizationOutputFormat.rawValue, for: .summarizationOutputFormat)
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView(settingsManager: UserDefaultsManager(), logger: Logger.settingsLogger)
    }
}
