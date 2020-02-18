//
//  SettingManager.swift
//  FinalProject
//
//  Created by PCI0002 on 2/18/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class SettingManager {

    private static var shareSettingManager: SettingManager = {
        let shareSettingManager = SettingManager()
        return shareSettingManager
    }()

    static func shared() -> SettingManager {
        return shareSettingManager
    }

    var categories: [CategoryType] {
        get {
            guard let array = UserDefaults.standard.array(forKey: "Key") as? [Int] else {
                return CategoryType.allCases
            }
            let categories = array.compactMap { CategoryType(rawValue: $0) }
            return categories
        } set {
            let categoriesRaw = newValue.map { $0.rawValue }
            UserDefaults.standard.set(categoriesRaw, forKey: "Key")
        }
    }

    private init() { }
}
