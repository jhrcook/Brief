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
            FontSettingsView(settingsManager: settingsManager)
                .tabItem {
                    Label("Font", systemImage: "textformat")
                }
            StopwordsSettingsView()
                .tabItem {
                    Label("Stopwords", systemImage: "strikethrough")
                }
        }
        .frame(width: 500, height: 150)
        .tabViewStyle(DefaultTabViewStyle())
    }
}

struct SettingsCancelAndSaveButtons: View {
    let cancelAction: () -> Void
    let saveAction: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            Spacer()

            Button("Cancel", action: cancelAction)
                .keyboardShortcut(.cancelAction)
                .padding(.horizontal)

            Button("Save", action: saveAction)
                .keyboardShortcut(.return)
                .padding(.horizontal)

            Spacer()
        }
    }
}

struct BriefSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        BriefSettingsView(settingsManager: UserDefaultsManager()).previewLayout(.fixed(width: 400, height: 100))
    }
}
