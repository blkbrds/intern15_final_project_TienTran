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
        shareSettingManager.configSettingSubTabsStorage()
        return shareSettingManager
    }()

    static func shared() -> SettingManager {
        return shareSettingManager
    }

    private init() { }

    private func configSettingSubTabsStorage() {
        if (UserDefaults.standard.array(forKey: "settingSubTabs") as? [String]) == nil {
            var subTabs: [String] = []
            CategoryType.allCases.forEach { subTabs.append($0.param) }
            UserDefaults.standard.set(subTabs, forKey: "settingSubTabs")
        }
    }
}

// MARK: - setting subtabs (category)
extension SettingManager {
    func saveSettingSubTabs(subTabs: [String], complete: Completion) {
        UserDefaults.standard.set(subTabs, forKey: "settingSubTabs")
    }

    func getSubTabs() -> [String] {
        guard let settingSubTabs = UserDefaults.standard.array(forKey: "settingSubTabs") as? [String] else { return [] }
        return settingSubTabs
    }

    func getTabCategories() -> [CategoryType] {
        var categorites: [CategoryType] = []
        let subTabs: [String] = getSubTabs()
        CategoryType.allCases.forEach { category in
            if subTabs.contains(category.param) {
                categorites.append(category)
            }
        }
        return categorites
    }
}
