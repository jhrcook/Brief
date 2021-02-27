//
//  BriefSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/19/21.
//

import os
import SwiftUI

struct BriefSettingsView: View {
    let settingsManager: UserDefaultsManager
    let logger = Logger.settingsLogger

    private enum Tabs: Hashable {
        case general, font, stopwords
    }

    var body: some View {
        TabView {
            GeneralSettingsView(settingsManager: settingsManager, logger: logger)
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            FontSettingsView(settingsManager: settingsManager, logger: logger)
                .tabItem {
                    Label("Font", systemImage: "textformat")
                }
            StopwordsSettingsView()
                .tabItem {
                    Label("Stopwords", systemImage: "strikethrough")
                }
        }
        .tabViewStyle(DefaultTabViewStyle())
    }
}

struct BriefSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        BriefSettingsView(settingsManager: UserDefaultsManager()).previewLayout(.fixed(width: 400, height: 100))
    }
}
