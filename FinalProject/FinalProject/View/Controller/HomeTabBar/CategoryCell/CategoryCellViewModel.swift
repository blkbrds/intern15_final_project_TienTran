//
//  CategoryCellViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class CategoryCellViewModel {
    var textCategoryLabel: String
    var isEnable: Bool

    init(textCategoryLabel: String, isEnable: Bool) {
        self.isEnable = isEnable
        self.textCategoryLabel = textCategoryLabel
    }

    func configData(isEnable: Bool) {
        self.isEnable = isEnable
    }
}
