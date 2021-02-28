//
//  Colors.swift
//  Brief
//
//  Created by Joshua on 2/15/21.
//

import SwiftUI

extension Color {
    static let lightGray = Color(red: 230 / 255, green: 230 / 255, blue: 230 / 255)
    static let secondaryLightGray = Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255)
    static let darkmodeSecondary = Color(red: 30 / 255, green: 30 / 255, blue: 30 / 255)
    static let darkmodeDividerGray = Color(red: 60 / 255, green: 56 / 255, blue: 62 / 255)
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
