//
//  FavoritesViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/6/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import RealmSwift

final class FavoritesViewModel {
    var categories: [CategoryType] = CategoryType.allCases

    var notificationToken: NotificationToken?
}

extension FavoritesViewModel {

    func numberOfCategories() -> Int {
        categories.count
    }

    func getFavoritesCellViewModel(at indexPath: IndexPath) -> FavoritesCellViewModel {
        return FavoritesCellViewModel(imageName: categories[indexPath.row].imageName, numberFavorites: getNumberArticlesForCategory(at: indexPath), favoritesType: categories[indexPath.row])
    }

    func getNumberArticlesForCategory(at indexPath: IndexPath) -> Int {
        let categoryType = categories[indexPath.row]
        return RealmManager.shared().getNewsForCategoryInRealm(query: categoryType.param).count
    }

    func getFavoritesDetailViewModel(at indexPath: IndexPath) -> FavoritesDetailViewModel {
        let categoryType = categories[indexPath.row]
        return FavoritesDetailViewModel(categoryType: categoryType)
    }

    func setupObserve2(completion: @escaping Completion) {
        notificationToken = RealmManager.shared().setupObserve2(News.self) { (done, error) in
            if done {
                completion(done, "")
            } else {
                completion(done, error)
            }
        }
    }

    func invalidateNotificationToken2() {
        RealmManager.shared().invalidateNotificationToken2(token: notificationToken)
    }
}
