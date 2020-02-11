//
//  FavoritesDetailViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/7/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class FavoritesDetailViewModel {

    var categoryType: CategoryType
    var articles: [News] = []

    init(articles: [News] = [], categoryType: CategoryType = .us) {
        self.articles = articles
        self.categoryType = categoryType
    }
}

extension FavoritesDetailViewModel {
    func numberOfListNews() -> Int {
        return articles.count
    }

    func getNewsCellViewModel(at indexPath: IndexPath) -> NewsTableViewCellViewModel {
        let news = articles[indexPath.row]
        let newsCellViewModel = NewsTableViewCellViewModel(
            newsTitle: news.titleNews,
            nameSource: news.nameSource,
            publishedAt: news.publishedAt,
            urlImage: news.urlImage,
            urlNews: news.urlNews,
            indexPath: indexPath)
        return newsCellViewModel
    }

    func getNewsDetailViewModel(at indexPath: IndexPath) -> NewsDetailViewModel {
        let news = articles[indexPath.row]
        let newsDetailViewModel = NewsDetailViewModel(
            news: news,
            indexPath: indexPath,
            isFavorited: RealmManager.shared().isRealmContainsObject(object: news, forPrimaryKey: news.urlNews))
        return newsDetailViewModel
    }
}

extension FavoritesDetailViewModel {

    func fetchData(completion: @escaping Completion) {
        let articles = RealmManager.shared().getNewsForCategoryInRealm(query: categoryType.param)
        self.articles = articles
        completion(true, "")
    }
}
