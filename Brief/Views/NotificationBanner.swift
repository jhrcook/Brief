//
//  NotificationBanner.swift
//  Brief
//
//  Created by Joshua on 3/15/21.
//

import SwiftUI

struct NotificationBanner: View {
    @Binding var text: String

    @Environment(\.colorScheme) var colorScheme

    var shadowColor: Color {
        colorScheme == .light ? Color.black.opacity(0.5) : Color.white.opacity(0.4)
    }

    var backgroundColor: Color {
        colorScheme == .light ? .lightGray : .darkmodeNotificationGray
    }

    var body: some View {
        Text(text)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .foregroundColor(backgroundColor)
                    .shadow(color: shadowColor, radius: 5, x: -1, y: 2)
            )
    }
}

struct NotificationBanner_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBanner(text: .constant("Notification"))
    }
}
