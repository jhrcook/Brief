//
//  Logging.swift
//  Brief
//
//  Created by Joshua on 2/15/21.
//

import Foundation
import os

extension Logger {
    static let subsystem = "com.joshuacook.Brief"
    static let summarizerLogger = Logger(subsystem: subsystem, category: "Summarizer")
    static let settingsLogger = Logger(subsystem: subsystem, category: "Settings")
    static let contentViewLogger = Logger(subsystem: subsystem, category: "ContentView")
    static let commandsLogger = Logger(subsystem: subsystem, category: "BriefCommands")
}
