//
//  View-Extension.swift
//  Brief
//
//  Created by Joshua on 2/23/21.
//

import SwiftUI

extension View {
    func close() {
        NSApplication.shared.keyWindow?.close()
    }
}
