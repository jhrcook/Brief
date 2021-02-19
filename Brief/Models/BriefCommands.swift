//
//  BriefCommands.swift
//  Brief
//
//  Created by Joshua on 2/19/21.
//

import SwiftUI

struct BriefCommands: Commands {
    var body: some Commands {
        CommandMenu("Summary") {
            Section {
                Button("Summarize Text") {
                    print("Summarizing!!!")
                }
            }
        }
    }
}
