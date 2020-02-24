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
    var cells: [SubTabsCellViewModel] = []

    var categoriesSelected: [CategoryType] = []
}

extension SettingSubTabsViewModel {

    func getNumberOfRowsInSection() -> Int {
        return categories.count
    }

    func getSettingSubTabsCellViewModel(at indexPath: IndexPath) -> SubTabsCellViewModel {
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
        categoriesSelected = SettingManager.shared().categories

        categories.enumerated().forEach { (index, category) in
            let isEnable = getIsActive(category)
            let cell = SubTabsCellViewModel(category: category, isEnable: isEnable, indexPath: IndexPath(row: index, section: 0))
            cells.append(cell)
        }
    }

    func getIsActive(_ category: CategoryType) -> Bool {
        if category == .us || category == .health {
            return true
        }
        return categoriesSelected.contains(category)
    }

    func saveSettingSubTabs() {
        categoriesSelected.removeAll()
        cells.filter { $0.isEnable }.forEach { categoriesSelected.append($0.category) }
        guard !categoriesSelected.elementsEqual(SettingManager.shared().categories) else { return }
        SettingManager.shared().categories = categoriesSelected
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name.settingCategories, object: nil)

    }
}
