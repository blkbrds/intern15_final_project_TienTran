//
//  NewsDetailViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/5/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class NewsDetailViewModel {

    var news: News?
    var isFavorited: Bool = false
    var indexPath: IndexPath?
    var favoritesImage: String? {
        if isFavorited {
            return "heart.fill"
        } else {
            return "heart"
        }
    }

    init() { }

    init(news: News, indexPath: IndexPath, isFavorited: Bool = false) {
        self.news = news
        self.indexPath = indexPath
        self.isFavorited = isFavorited
    }
}

extension NewsDetailViewModel {

    func addNewsInFavorites(completion: @escaping Completion) {
        guard let news = news else { return }
        RealmManager.shared().addObject(object: news) { (done, error) in
            if done {
                self.isFavorited = true
                completion(done, "")
            } else {
                completion(done, error)
            }
        }
    }

    func removeNewsInFavorites(completion: @escaping Completion) {
        guard let news = news else { return }
        RealmManager.shared().deleteObject(object: news) { (done, error) in
            if done {
                self.isFavorited = false
                completion(done, "")
            } else {
                completion(done, error)
            }
        }
    }

    /// check favorites contains news?
    func isRealmContainsObject() -> Bool {
        guard let news = news else { return false }

        return RealmManager.shared().isRealmContainsObject(object: news, forPrimaryKey: news.urlNews)
    }
}
