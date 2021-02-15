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
    static let logger = Logger(subsystem: subsystem, category: "example")
}
