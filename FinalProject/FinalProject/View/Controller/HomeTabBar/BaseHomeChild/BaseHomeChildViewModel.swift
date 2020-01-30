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

final class BaseHomeChildViewModel {
    var screenType: HomeScreenType = .us
    var articles: [News] = []
}

// MARK: - config tableview
extension BaseHomeChildViewModel {
    func numberOfListNews() -> Int {
        return articles.count
    }

    func getNewsCellViewModel(indexPath: IndexPath) -> NewsTableViewCellViewModel {
        let news = articles[indexPath.row]
        let newsCellViewModel = NewsTableViewCellViewModel(
            newsTitleLabel: news.titleNews,
            nameSourceLabel: news.source.name,
            publishedLabel: news.publishedAt,
            urlStringImage: news.urlImageNews,
            indexPath: indexPath)
        return newsCellViewModel
    }
}

// MARK: - handle api
extension BaseHomeChildViewModel {

    // load api
    func loadAPI(compeltion: @escaping Completion) {

        APIManager.News.getTopHeadlines(page: 1, category: screenType.valueCategory, country: "us") { result in
            switch result {
            case .failure(let error):
                // call back
                compeltion(false, error.localizedDescription)
            case .success(let response):
                self.articles.append(contentsOf: response.articles)

                //call back
                compeltion(true, "")
            }
        }
    }

    // dowload image
    func loadImage(indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        let news = articles[indexPath.row]

        if let newsImageData = UserDefaults.standard.data(forKey: news.urlImageNews) {
            let newsImage = UIImage(data: newsImageData)
            completion(newsImage)
        } else {
            APIManager.Downloader.downloadImage(urlString: news.urlImageNews) { image in
                if let image = image {
                    completion(image)
                } else {
                    completion(nil) /// tra ve anh default && khi vao lai cell do no se tiep tuc tai lai anh
                }
            }
        }
    }
}
