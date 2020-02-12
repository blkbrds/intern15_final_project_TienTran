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
}

extension SearchNewsViewModel {

    func getNumberOfListNews() -> Int {
        return searchItems.count
    }

    func getSearchNewsCellViewModel(at indexPath: IndexPath) -> SearchNewsCellViewModel {
        let news = searchItems[indexPath.row]
        return SearchNewsCellViewModel(news: news, indexPath: indexPath)
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
    func searchNews(query: String, compeltion: @escaping Completion) {
        APIManager.News.getEverything(query: query, country: "us") { result in
            switch result {
            case .failure(let error):
                // call back
                compeltion(false, error.localizedDescription)
            case .success(let response):
                self.searchItems = response.articles
                // call back
                compeltion(true, "")
            }
        }
    }

}
