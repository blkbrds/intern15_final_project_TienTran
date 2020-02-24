//
//  SearchNewsViewModel.swift
//  FinalProject
//
//  Created by TranVanTien on 2/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import UIKit

final class SearchNewsViewModel {
    var searchItems: [News] = []
    var queryString = ""
    var oldQueryString = ""
    var canLoadMore = true
    var isLoading = false
    var currentPage = 1
}

extension SearchNewsViewModel {

    func getNumberOfListNews() -> Int {
        return searchItems.count
    }

    func getSearchNewsCellViewModel(at indexPath: IndexPath) -> SearchNewsCellViewModel {
        let news = searchItems[indexPath.row]
        return SearchNewsCellViewModel(news: news, indexPath: indexPath)
    }

    func getNewsDetailViewModel(at indexPath: IndexPath) -> NewsDetailViewModel {
        let news = searchItems[indexPath.row]
        let newsDetailViewModel = NewsDetailViewModel(
            news: news,
            indexPath: indexPath,
            isFavorited: RealmManager.shared().isRealmContainsObject(object: news, forPrimaryKey: news.urlNews))
        return newsDetailViewModel
    }

    func isEmmtySearchItems() -> Bool {
        return searchItems.count == 0
    }
}

extension SearchNewsViewModel {

    /// dowload image
    func loadImage(indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        let news = searchItems[indexPath.row]

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

    /// search news
    func searchNews(completion: @escaping Completion) {
        queryString = queryString.trimmingCharacters(in: .whitespacesAndNewlines)

        guard queryString != "",
            let queryStringEndcode = queryString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                completion(false, "")
                return
        }

        isLoading = true
        APIManager.News.getEverything(query: queryStringEndcode, country: "us") { result in
            switch result {
            case .failure(let error):
                // call back
                completion(false, error.localizedDescription)
            case .success(let response):
                let articles = response.articles
                self.searchItems = articles
                self.oldQueryString = self.queryString
                completion(true, "")
            }
            self.isLoading = false
        }
    }

    /// search news
    func loadMoreSearchNews(completion: @escaping Completion) {
        queryString = queryString.trimmingCharacters(in: .whitespacesAndNewlines)

        guard queryString != "",
            let queryStringEndcode = queryString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
                completion(false, "")
                return
        }
        isLoading = true
        currentPage += 1
        APIManager.News.getEverything(page: currentPage, query: queryStringEndcode, country: "us") { result in
            switch result {
            case .failure(let error):
                // call back
                completion(false, error.localizedDescription)
            case .success(let response):
                let articles = response.articles
                if articles.count > 0 {
                    self.searchItems.append(contentsOf: articles)
                    completion(true, "")
                } else {
                    self.canLoadMore = false
                    completion(false, "Can't loadmore!")
                }
                self.oldQueryString = self.queryString
            }
            self.isLoading = false
        }
    }

    func cancelSearchNews() {
        searchItems.removeAll()
        currentPage = 0
        isLoading = false
        canLoadMore = true
    }
}
