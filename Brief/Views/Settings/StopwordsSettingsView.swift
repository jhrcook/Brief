//
//  StopwordsSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/23/21.
//

import os
import SwiftUI

struct StopwordsSettingsView: View {
    let settingsManager: UserDefaultsManager
    let logger: Logger

    @State private var stopwordsText: String = ""

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            Text("Add additional words separated by commas or spaces.")
            Text("These words will be removed from sentences used by the summarization algorithm.").font(.caption)
            TextEditor(text: $stopwordsText)
        }
        .padding()
        .frame(width: 500, height: 200)
        .onChange(of: stopwordsText) { _ in
            DispatchQueue.global(qos: .userInitiated).async {
                let stopwords = parseStopWordsText(stopwordsText)
                settingsManager.write(value: stopwords, for: .stopwords)
            }
        }
        .onAppear {
            var stopwords: [String] = settingsManager.read(key: .stopwords)
            stopwords.sort()
            stopwordsText = stopwords.joined(separator: ", ")
        }
    }

    private func parseStopWordsText(_ text: String) -> [String] {
        logger.info("Parsing stop words text to list.")
        return text
            .lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .map { $0.split(separator: ",") }
            .flatMap { $0 }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}

struct StopwordsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        StopwordsSettingsView(settingsManager: UserDefaultsManager(), logger: Logger.settingsLogger).previewLayout(.fixed(width: 500, height: 500))
    }
}
