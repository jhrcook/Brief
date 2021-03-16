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

struct ViewVisibilityModifier: ViewModifier {
    @Binding var visible: Bool
    func body(content: Content) -> some View {
        Group {
            if visible {
                content
            } else {
                EmptyView()
            }
        }
    }
}

extension View {
    func visible(_ visible: Binding<Bool>) -> some View {
        modifier(ViewVisibilityModifier(visible: visible))
    }
}
