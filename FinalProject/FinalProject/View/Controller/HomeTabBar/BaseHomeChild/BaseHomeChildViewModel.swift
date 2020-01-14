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
//
//if news.thumbnailImage != nil {
//    news.thumbnail.image = item.thumbnailImage
//} else {
//    news.thumbnail.image = nil
//
//    //downloader
//    Networking.shared().downloadImage(url: item.urlToImage) { (image) in
//        if let image = image {
//            news.thumbnail.image = image
//            item.thumbnailImage = image
//        } else {
//            news.thumbnail.image = nil
//        }
//    }
//}
// MARK: - config tableview
extension BaseHomeChildViewModel {
    func numberOfListNews() -> Int {
        return listNews.count
    }

    func getNewsCellViewModel(indexPath: IndexPath) -> NewsTableViewCellViewModel {
        let news = listNews[indexPath.row]
        let newsCellViewModel = NewsTableViewCellViewModel(newsTitleLabel: news.titleNews, nameSourceLabel: news.sourceName, publishedLabel: news.publishedAt)
        print("a \(String(describing: news.newsImage))")
        if newsCellViewModel.newsImage != nil {
            newsCellViewModel.newsImage = news.newsImage
        } else {
            newsCellViewModel.newsImage = nil
            Networking.shared().downloadImage(url: news.urlImage) { image in
                if let image = image {
                    news.newsImage = image
                    newsCellViewModel.newsImage = image
                } else {
                    newsCellViewModel.newsImage = nil
                }
            }
        }
        return newsCellViewModel
    }
}

// MARK: - handle api
extension BaseHomeChildViewModel {
    func loadAPI(compeltion: @escaping Completion) {
        print("load api \(screenType.valueCategory)")
        APIManager.News.getTopHeadlines(page: 1, category: screenType.valueCategory, country: "jp") { result in
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
