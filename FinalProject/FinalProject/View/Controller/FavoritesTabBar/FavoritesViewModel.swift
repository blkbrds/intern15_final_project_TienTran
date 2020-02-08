//
//  FavoritesViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/6/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class FavoritesViewModel {
    var categories: [CategoryType] = CategoryType.allCases
}

extension FavoritesViewModel {

    func numberOfCategories() -> Int {
        categories.count
    }

    func getFavoritesCellViewModel(at indexPath: IndexPath) -> FavoritesCellViewModel {
        return FavoritesCellViewModel(imageName: categories[indexPath.row].imageName, numberFavorites: getNumberArticlesForCategory(at: indexPath))
    }
    
    func getNumberArticlesForCategory(at indexPath: IndexPath) -> Int {
        return RealmManager.shared().getCountOfObjects()
    }
}
