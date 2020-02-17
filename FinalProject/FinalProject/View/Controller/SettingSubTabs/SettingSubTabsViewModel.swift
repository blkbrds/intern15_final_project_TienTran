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

    var subTabscells: [CategoryType] = []
}

extension SettingSubTabsViewModel {

    func getNumberOfRowsInSection() -> Int {
        return categories.count
    }

    func getSettingSubTabsCellViewModel(at indexPath: IndexPath) -> SettingSubTabsCellViewModel {
        #warning("Realm -- get item")
        return cells[indexPath.row]
    }

    func getDummyData(at indexPath: IndexPath) -> SettingSubTabsCellViewModel {
        return SettingSubTabsCellViewModel(category: categories[indexPath.row], isEnable: true, indexPath: indexPath)
    }

    func getAllCellViewModel() {
        categories.enumerated().forEach { (index, _) in
            cells.append(getDummyData(at: IndexPath(row: index, section: 0)))
        }
    }

    func changeStatus(with indexPath: IndexPath, completion: Completion) {
        if indexPath.row >= categories.count {
            completion(false, "Over of range")
        } else {
            #warning("config later with reaml")
            let cell = cells[indexPath.row]
            cells[indexPath.row].isEnable = !cells[indexPath.row].isEnable
            updateStatusCell(with: cell) { (done, _) in
                completion(done, "")
            }
        }
    }

    func updateStatusCell(with cell: SettingSubTabsCellViewModel, completion: Completion) {
        /// add + func ->> cl
        completion(true, "")
    }

    func saveSettingSubTabs() {
        subTabscells.removeAll()
        cells.filter { $0.isEnable }.forEach { subTabscells.append($0.category) }
        print(subTabscells)
    }
}
