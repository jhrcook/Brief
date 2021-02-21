//
//  PasteboardManager.swift
//  Brief
//
//  Created by Joshua on 2/21/21.
//

import AppKit
import Foundation

struct PasteboardManager {
    let pasteboard: NSPasteboard

    init() {
        pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
    }

    func copyToClipboard(_ text: String?) {
        guard let text = text else { return }
        pasteboard.setString(text, forType: .string)
    }

    func getCurrentlyCopiedText() -> String? {
        pasteboard.string(forType: .string)
    }
}
