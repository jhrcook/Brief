//
//  GeneralSettingsView.swift
//  Brief
//
//  Created by Joshua on 2/22/21.
//

import SwiftUI

struct GeneralSettingsView: View {
    @State private var defaultSummaryRatio = 0.0

    @State private var clearInputAndOutput: Bool = true

    var body: some View {
        VStack {
            Form {
                Toggle(isOn: $clearInputAndOutput, label: {
                    Text("Clear both input and summary text?")
                })

                Slider(value: $defaultSummaryRatio, in: 0.0 ... 1.0) {
                    Text("Default summary ratio ")
                    Text("\(defaultSummaryRatio * 100, specifier: "%.0f")%").bold().frame(width: 40)
                }
            }
            .padding(20)

            Spacer()

            HStack(alignment: .center) {
                Spacer()

                Button("Cancel") {
                    close()
                    defaultSummaryRatio = Double(UserDefaultsManager().read(key: .defaultSummaryRatio))
                }
                .keyboardShortcut(.cancelAction)
                .padding(.horizontal)

                Button("Save") {
                    UserDefaultsManager().write(value: Float(defaultSummaryRatio), for: .defaultSummaryRatio)
                    close()
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .onAppear {
            defaultSummaryRatio = Double(UserDefaultsManager().read(key: .defaultSummaryRatio))
        }
        .frame(width: 500, height: 150)
    }

    private func close() {
        NSApplication.shared.keyWindow?.close()
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView()
    }
}
