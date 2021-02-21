//
//  PasteboardManager.swift
//  Brief
//
//  Created by Joshua on 2/21/21.
//

import AppKit
import Foundation

struct PasteboardManager {
    let pasteboard = NSPasteboard.general

    /// Copy some text to pasteboard.
    /// - Parameter text: Text to copy.
    func copyToClipboard(_ text: String?) {
        guard let text = text else { return }
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(text, forType: .string)
    }

    /// Get the current text in the pasteboard.
    /// - Returns: Text in the pasteboard.
    func getCurrentlyCopiedText() -> String? {
        pasteboard.string(forType: .string)
    }
}
