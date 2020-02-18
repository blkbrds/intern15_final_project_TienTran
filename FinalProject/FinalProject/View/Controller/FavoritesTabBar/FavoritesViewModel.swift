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

    func setupObserve(completion: @escaping Completion) {
        notificationToken = RealmManager.shared().setupObserve(News.self) { (done, error) in
            if done {
                completion(done, "")
                print(RealmManager.shared().getObjects(News.self).count)
            } else {
                completion(done, error)
            }
        }

    }

    func invalidateNotificationToken() {
        RealmManager.shared().invalidateNotificationToken(token: notificationToken)
    }

    func isEmtyBookmarks() -> Bool {
        return RealmManager.shared().getObjects(News.self).count == 0 ? true : false
    }
}
