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

    var settingSubTabs: [String] = []
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
        settingSubTabs = SettingManager.shared().getSubTabs()

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
        return settingSubTabs.contains(category.param)
    }

    func saveSettingSubTabs(completion: @escaping Completion) {
        settingSubTabs.removeAll()
        cells.filter { $0.isEnable }.forEach { settingSubTabs.append($0.category.param) }
        SettingManager.shared().saveSettingSubTabs(subTabs: settingSubTabs) { (done, error) in
            completion(done, error)
        }
    }
}
