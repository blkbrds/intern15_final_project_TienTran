//
//  SettingSubTabsViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/17/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class SettingSubTabsViewModel {

    var categories: [CategoryType] = CategoryType.allCases
    var cells: [SettingSubTabsCellViewModel] = []

    var settingCategories: [CategoryType] = []
}

extension SettingSubTabsViewModel {

    func getNumberOfRowsInSection() -> Int {
        return categories.count
    }

    func getSettingSubTabsCellViewModel(at indexPath: IndexPath) -> SettingSubTabsCellViewModel {
        return cells[indexPath.row]
    }

    func changeStatus(with indexPath: IndexPath, completion: Completion) {
        if indexPath.row >= categories.count {
            completion(false, "Over of range")
        } else {
            cells[indexPath.row].isEnable = !cells[indexPath.row].isEnable
            completion(true, "")
        }
    }

    func getAllCellViewModel() {
        settingCategories = SettingManager.shared().categories

        categories.enumerated().forEach { (index, category) in
            let isEnable = getIsActive(category)
            let cell = SettingSubTabsCellViewModel(category: category, isEnable: isEnable, indexPath: IndexPath(row: index, section: 0))
            cells.append(cell)
        }
    }

    func getIsActive(_ category: CategoryType) -> Bool {
        if category == .us || category == .health {
            return true
        }
        return settingCategories.contains(category)
    }

    func saveSettingSubTabs(completion: @escaping Completion) {
        settingCategories.removeAll()
        cells.filter { $0.isEnable }.forEach { settingCategories.append($0.category) }
        SettingManager.shared().categories = settingCategories
        completion(true, "")
    }
}
