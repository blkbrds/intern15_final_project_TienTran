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
    private var oldQueryString = ""
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
        return searchItems.count < 1 ? true : false
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
    func searchNews(compeltion: @escaping Completion) {
        queryString = queryString.trimmingCharacters(in: CharacterSet(charactersIn: " "))
        queryString = queryString.replacingOccurrences(of: " ", with: "%20")
        guard queryString != "", queryString != oldQueryString else { return compeltion(false, "") }
        APIManager.News.getEverything(query: queryString, country: "us") { result in
            switch result {
            case .failure(let error):
                // call back
                compeltion(false, error.localizedDescription)
            case .success(let response):
                self.searchItems = response.articles
                self.oldQueryString = self.queryString
                // call back
                compeltion(true, "")
            }
        }
    }
}
