//
//  Colors.swift
//  Brief
//
//  Created by Joshua on 2/15/21.
//

import SwiftUI

extension Color {
    init(red: Int, green: Int, blue: Int) {
        self.init(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0)
    }

    init(gray: Int) {
        self.init(red: gray, green: gray, blue: gray)
    }

    static let lightGray = Color(red: 230, green: 230, blue: 230)
    static let secondaryLightGray = Color(red: 245, green: 245, blue: 245)
    static let darkmodeSecondary = Color(red: 30, green: 30, blue: 30)
    static let darkmodeDividerGray = Color(red: 60, green: 56, blue: 62)
    static let darkmodeNotificationGray = Color(red: 71, green: 71, blue: 71)
}

struct Colors_Previews: PreviewProvider {
    static let customColors: [Color] = [.lightGray, .secondaryLightGray, .darkmodeSecondary]
    static let colorNames: [String] = ["lightGray", "secondaryLightGray", "darkmodeSecondary"]

    static var previews: some View {
        Group {
            ForEach(0 ..< customColors.count, id: \.self) { i in
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundColor(customColors[i])
                    .padding()
                    .previewLayout(.fixed(width: 200, height: 100))
                    .previewDisplayName(colorNames[i])
            }
        }
    }
}
