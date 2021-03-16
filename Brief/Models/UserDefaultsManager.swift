//
//  UserDefaultsManager.swift
//  Brief
//
//  Created by Joshua on 2/20/21.
//

import Foundation

struct UserDefaultsManager {
    enum Key: String {
        case defaultSummaryRatio, clearInputAndOutput, touchbarIsActive
        case summarizationOutputFormat
        case fontName, fontSize, lineSpacing
        case stopwords
    }

    let defaults: [String: Any] = [
        Key.defaultSummaryRatio.rawValue: 0.80,
        Key.clearInputAndOutput.rawValue: true,
        Key.touchbarIsActive.rawValue: true,
        Key.summarizationOutputFormat.rawValue: SummarizationOutputFormat.orginalOrder.rawValue,
        Key.fontName.rawValue: "Helvetica Neue",
        Key.fontSize.rawValue: 12.0,
        Key.lineSpacing.rawValue: 3.0,
        Key.stopwords.rawValue: [String](),
    ]

    init() {
        setDefaultValues()
    }

    func read(key: Key) -> Double {
        return UserDefaults.standard.double(forKey: key.rawValue)
    }

    func read(key: Key) -> Float {
        return UserDefaults.standard.float(forKey: key.rawValue)
    }

    func read(key: Key) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }

    func read(key: Key) -> String {
        UserDefaults.standard.string(forKey: key.rawValue)!
    }

    func read(key: Key) -> [String] {
        UserDefaults.standard.stringArray(forKey: key.rawValue) ?? [String]()
    }

    func readSummarizationOutputFormat() -> SummarizationOutputFormat {
        if let formatString = UserDefaults.standard.string(forKey: Key.summarizationOutputFormat.rawValue) {
            if let format = SummarizationOutputFormat(rawValue: formatString) {
                return format
            }
        }
        return SummarizationOutputFormat.orginalOrder
    }

    func write<T>(value: T, for key: Key) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }

    private func setDefaultValues() {
        UserDefaults.standard.register(defaults: defaults)
    }
}
