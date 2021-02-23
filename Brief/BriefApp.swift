//
//  BriefApp.swift
//  Brief
//
//  Created by Joshua on 1/18/21.
//

import SwiftUI

@main
struct BriefApp: App {
    let settingsManager = UserDefaultsManager()

    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView(settingsManager: settingsManager)
                .frame(minWidth: 400, idealWidth: 800, maxWidth: .infinity, minHeight: 200, idealHeight: 500, maxHeight: .infinity)
        }
        .commands {
            BriefCommands(settingsManager: settingsManager)
        }

        #if os(macOS)
            Settings {
                BriefSettingsView(settingsManager: settingsManager)
            }
        #endif
    }
}
