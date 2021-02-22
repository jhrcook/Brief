//
//  FontSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/22/21.
//

import SwiftUI

struct FontSettingsView: View {
    var body: some View {
        Form {
            Toggle(isOn: .constant(true), label: {
                Text("A toggle that does nothing.")
            })
        }
        .frame(width: 200, height: 100)
    }
}

struct FontSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FontSettingsView()
    }
}
