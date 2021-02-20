//
//  UserDefaultsManager.swift
//  Brief
//
//  Created by Joshua on 2/20/21.
//

import Foundation

struct UserDefaultsManager {
    enum UserDefaultsKeys: String {
        case defaultSummaryRatio
    }

    init() {
        setDefaultValues()
    }

    func read(key: UserDefaultsKeys) -> Float {
        return UserDefaults.standard.float(forKey: key.rawValue)
    }

    func write<T>(value: T, for key: UserDefaultsKeys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }

    private func setDefaultValues() {
        let defaults: [String: Any] = [
            UserDefaultsKeys.defaultSummaryRatio.rawValue: 0.20,
        ]
        UserDefaults.standard.register(defaults: defaults)
    }
}
