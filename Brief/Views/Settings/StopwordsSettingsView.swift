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
    @AppStorage(UserDefaultsManager.Key.stopwords.rawValue) private var stopwords = [String]()
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
            stopwords = parseStopWordsText(stopwordsText)
        }
        .onAppear {
            stopwordsText = stopwords.sorted().joined(separator: ", ")
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
            .sorted()
    }
}

struct StopwordsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        StopwordsSettingsView(settingsManager: UserDefaultsManager(), logger: Logger.settingsLogger).previewLayout(.fixed(width: 500, height: 500))
    }
}
