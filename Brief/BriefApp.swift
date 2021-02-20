//
//  BriefApp.swift
//  Brief
//
//  Created by Joshua on 1/18/21.
//

import SwiftUI

@main
struct BriefApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 400, idealWidth: 800, maxWidth: .infinity, minHeight: 200, idealHeight: 500, maxHeight: .infinity)
        }
        .commands {
            BriefCommands()
        }

        #if os(macOS)
            Settings {
                BriefSettingsView()
                    .frame(width: 400, height: 100, alignment: .center)
            }
        #endif
    }
}
