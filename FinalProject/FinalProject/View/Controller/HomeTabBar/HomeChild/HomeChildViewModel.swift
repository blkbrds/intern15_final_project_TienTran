//
//  BaseHomeChildViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 1/14/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import UIKit

typealias Completion = (Bool, String) -> Void

final class HomeChildViewModel {
    var category: CategoryType = .us
    var articles: [News] = []
    var isRefreshing = false
    var isLoading = false
    var canLoadMore = true
    private var currentPageParam = 1
    var index: Int = 0

    init() { }

    init(articles: [News], category: CategoryType, isLoading: Bool, index: Int) {
        self.articles = articles
        self.isLoading = isLoading
        self.category = category
        self.index = index
    }
}

// MARK: - config tableview
extension HomeChildViewModel {
    func numberOfListNews() -> Int {
        return articles.count
    }

    func getNewsCellViewModel(at indexPath: IndexPath) -> NewsTableViewCellViewModel {
        let news = articles[indexPath.row]
        let newsCellViewModel = NewsTableViewCellViewModel(
            newsTitle: news.titleNews ?? "",
            nameSource: news.source?.name ?? "",
            publishedAt: news.publishedAt ?? Date.currentDate(),
            urlImage: news.urlImage ?? "",
            urlNews: news.urlNews ?? "",
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

// MARK: - handle api
extension HomeChildViewModel {

    /// dowload image
    func loadImage(indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        let news = articles[indexPath.row]

        if let newsImageData = UserDefaults.standard.data(forKey: news.urlImage ?? "") {
            let newsImage = UIImage(data: newsImageData)
            completion(newsImage)
        } else {
            APIManager.Downloader.downloadImage(urlString: news.urlImage ?? "") { image in
                if let image = image {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
