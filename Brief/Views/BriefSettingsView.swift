//
//  BriefSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/19/21.
//

import SwiftUI

struct BriefSettingsView: View {
    @State private var defaultSummaryRatio = 0.0

    var body: some View {
        VStack {
            HStack {
                Text("Default summary ratio:")
                Spacer()
                Text("\(defaultSummaryRatio * 100, specifier: "%.0f")%")
                    .foregroundColor(.secondary)
                Slider(value: $defaultSummaryRatio, in: 0.0 ... 1.0)
                    .frame(width: 100)
            }
            .padding()
            HStack {
                Button("Cancel") {
                    close()
                    defaultSummaryRatio = Double(UserDefaultsManager().read(key: .defaultSummaryRatio))
                }
                .keyboardShortcut(.cancelAction)

                Button("Save") {
                    UserDefaultsManager().write(value: Float(defaultSummaryRatio), for: .defaultSummaryRatio)
                    close()
                }
            }
        }
        .onAppear {
            defaultSummaryRatio = Double(UserDefaultsManager().read(key: .defaultSummaryRatio))
        }
    }

    private func close() {
        NSApplication.shared.keyWindow?.close()
    }
}

struct BriefSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        BriefSettingsView()
    }
}
