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

    func getNumberOfCategories() -> Int {
        categories.count
    }

    func getFavoritesCellViewModel(at indexPath: IndexPath) -> FavoritesCellViewModel {
        return FavoritesCellViewModel(imageName: categories[indexPath.row].imageName, numberFavorites: getNumberArticlesForCategory(at: indexPath), favoritesType: categories[indexPath.row])
    }

    func getNumberArticlesForCategory(at indexPath: IndexPath) -> Int {
        let categoryType = categories[indexPath.row]
        return RealmManager.shared().getNewsForCategoryInRealm(query: categoryType.param).count
    }
}
