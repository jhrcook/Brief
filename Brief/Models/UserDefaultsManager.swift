//
//  UserDefaultsManager.swift
//  Brief
//
//  Created by Joshua on 2/20/21.
//

import Foundation

struct UserDefaultsManager {
    enum UserDefaultsKeys: String {
        case defaultSummaryRatio, clearInputAndOutput
        case fontname, fontsize, linespacing
    }

    let defaults: [String: Any] = [
        UserDefaultsKeys.defaultSummaryRatio.rawValue: 0.20,
        UserDefaultsKeys.clearInputAndOutput.rawValue: true,
        UserDefaultsKeys.fontname.rawValue: "Helvetica",
        UserDefaultsKeys.fontsize.rawValue: 12.0,
        UserDefaultsKeys.linespacing.rawValue: 3.0,
    ]

    init() {
        setDefaultValues()
    }

    func read(key: UserDefaultsKeys) -> Float {
        return UserDefaults.standard.float(forKey: key.rawValue)
    }

    func read(key: UserDefaultsKeys) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }

    func read(key: UserDefaultsKeys) -> String {
        UserDefaults.standard.string(forKey: key.rawValue)!
    }

    func write<T>(value: T, for key: UserDefaultsKeys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }

    private func setDefaultValues() {
        UserDefaults.standard.register(defaults: defaults)
    }
}
