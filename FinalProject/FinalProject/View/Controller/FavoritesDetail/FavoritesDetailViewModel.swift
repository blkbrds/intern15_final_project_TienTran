//
//  FavoritesDetailViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/7/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class FavoritesDetailViewModel {

    var categoryType: CategoryType
    var articles: [News] = []
    var notificationToken: NotificationToken?

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
            newsTitle: news.titleNews ?? "",
            nameSource: news.source?.name ?? "",
            publishedAt: news.publishedAt ?? Date.currentDate(),
            urlImage: news.urlImage ?? "",
            urlNews: news.urlNews ?? "",
            indexPath: indexPath)
        return newsCellViewModel
    }

    func getFavoritesDetailCellViewModel(at indexPath: IndexPath) -> FavoritesDetailCellViewModel {
        let news = articles[indexPath.row]
        let favoritesDetailCellViewModel = FavoritesDetailCellViewModel(news: news, indexPath: indexPath)
        return favoritesDetailCellViewModel
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
        if articles.isEmpty {
            completion(false, "No articles!")
        } else {
            self.articles = articles
            completion(true, "")
        }
    }

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

extension FavoritesDetailViewModel {

    func setupObserve(completion: @escaping Completion) {
        notificationToken = RealmManager.shared().setupObserve(News.self) { (done, error) in
            if done {
                completion(done, "")
            } else {
                completion(done, error)
            }
        }
    }

    func invalidateNotificationToken() {
        RealmManager.shared().invalidateNotificationToken(token: notificationToken)
    }

    func removeNewsInFavorites(indexPath: IndexPath, completion: @escaping Completion) {
        let news = articles[indexPath.row]
        RealmManager.shared().deleteObject(object: news, forPrimaryKey: news.urlNews) { (done, error) in
            if done {
                self.articles.remove(at: indexPath.row)
                completion(done, "")
            } else {
                completion(done, error)
            }
        }
    }

    func removeArticlesInFavorites(articles: [News], completion: @escaping Completion) {
        let keys: [String] = articles.map { $0.urlNews ?? "No url" }
        let obj = articles[0]
        RealmManager.shared().deleteObjects(object: obj, forPrimaryKey: keys) { (done, error) in
            if done {
                articles.forEach { news in
                    if let index = self.articles.firstIndex(of: news) {
                        self.articles.remove(at: index)
                    }
                }
                completion(done, "")
            } else {
                completion(done, error)
            }
        }
    }
}
