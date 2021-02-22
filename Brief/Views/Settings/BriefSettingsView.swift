//
//  BriefSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/19/21.
//

import SwiftUI

struct BriefSettingsView: View {
    private enum Tabs: Hashable {
        case general, font
    }

    var body: some View {
        TabView {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
            FontSettingsView()
                .tabItem {
                    Label("Font", systemImage: "textformat")
                }
        }
    }
}

struct BriefSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        BriefSettingsView().previewLayout(.fixed(width: 400, height: 100))
    }
}
