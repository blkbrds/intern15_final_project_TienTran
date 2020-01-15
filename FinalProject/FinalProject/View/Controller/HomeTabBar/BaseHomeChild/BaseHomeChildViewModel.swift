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
    var listNews: [News] = []
}

// MARK: - config tableview
extension BaseHomeChildViewModel {
    func numberOfListNews() -> Int {
        return listNews.count
    }

    func getNewsCellViewModel(indexPath: IndexPath) -> NewsTableViewCellViewModel {
        let news = listNews[indexPath.row]
        let newsCellViewModel = NewsTableViewCellViewModel(newsTitleLabel: news.titleNews, nameSourceLabel: news.sourceName, publishedLabel: news.publishedAt, urlStringImage: news.urlImage)
        #warning("download image")
        if news.newsImage != nil {
            newsCellViewModel.newsImage = news.newsImage
        } else {
            newsCellViewModel.newsImage = #imageLiteral(resourceName: "news-default")

            APIManager.Downloader.downloadImage(urlString: news.urlImage) { image in
                if let image = image {
                    print(image)
                    news.newsImage = image
                    newsCellViewModel.newsImage = image
                } else {
                    newsCellViewModel.newsImage = #imageLiteral(resourceName: "news-default")
                    news.newsImage = #imageLiteral(resourceName: "news-default")
                }
            }
        }

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
            case .success(let listNewsResult):
                self.listNews.append(contentsOf: listNewsResult.listNews)

                //call back
                compeltion(true, "")
            }
        }
    }
}
