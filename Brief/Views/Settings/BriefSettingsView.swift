//
//  BriefSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/19/21.
//

import SwiftUI

struct BriefSettingsView: View {
    let settingsManager: UserDefaultsManager

    private enum Tabs: Hashable {
        case general, font, stopwords
    }

    var body: some View {
        TabView {
            GeneralSettingsView(settingsManager: settingsManager)
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            FontSettingsView()
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
