//
//  FavoritesDetailViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/7/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class FavoritesDetailViewModel {
    var categoryType: CategoryType = .us
    var articles: [News] = []
}

extension FavoritesDetailViewModel {
    func numberOfListNews() -> Int {
        return articles.count
    }

    func getNewsCellViewModel(at indexPath: IndexPath) -> NewsTableViewCellViewModel {
        let news = articles[indexPath.row]
        let newsCellViewModel = NewsTableViewCellViewModel(
            newsTitle: news.titleNews,
            nameSource: news.source?.name ?? "",
            publishedAt: news.publishedAt,
            urlImage: news.urlImage,
            urlNews: news.urlNews,
            indexPath: indexPath)
        return newsCellViewModel
    }
}

extension FavoritesDetailViewModel {
    
    func fetchData(completion: @escaping Completion) {
        let articles = RealmManager.shared().gets(News.self)
        self.articles = articles
        completion(true, "")
    }
}
