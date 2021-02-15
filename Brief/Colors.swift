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
}

struct Colors_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.lightGray)
                .padding()
                .previewLayout(.fixed(width: 200, height: 100))
                .previewDisplayName("lightGray")
        }
    }
}
