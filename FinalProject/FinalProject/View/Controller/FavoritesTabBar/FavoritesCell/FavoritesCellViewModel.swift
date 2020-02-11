//
//  FavoritesCellViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/6/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class FavoritesCellViewModel {
    var imageName: String
    var numberFavorites: Int
    var favoritesType: CategoryType

    init(imageName: String, numberFavorites: Int = 0, favoritesType: CategoryType) {
        self.imageName = imageName
        self.numberFavorites = numberFavorites
        self.favoritesType = favoritesType
    }
}
