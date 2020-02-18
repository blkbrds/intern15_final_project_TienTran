//
//  SettingSubTabsCellViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/17/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class SettingSubTabsCellViewModel {
    var category: CategoryType
    var isEnable: Bool = true
    var backgroundImageString: String { return isEnable ? "checkmark.circle.fill" : "xmark.circle.fill" }
    var indexPath: IndexPath

    init(category: CategoryType, isEnable: Bool, indexPath: IndexPath) {
        self.isEnable = isEnable
        self.category = category
        self.indexPath = indexPath
    }
}
