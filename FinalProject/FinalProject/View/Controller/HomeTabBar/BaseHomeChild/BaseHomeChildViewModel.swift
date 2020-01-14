//
//  BaseHomeChildViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 1/14/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

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
        return NewsTableViewCellViewModel(newsTitleLabel: news.titleNews, nameSourceLabel: news.sourceName, publishedLabel: news.publishedAt)
    }
}

// MARK: - handle api
extension BaseHomeChildViewModel {
    func loadAPI(compeltion: @escaping Completion) {
        print("load api \(screenType.valueCategory)")
        APIManager.News.getTopHeadlines(category: screenType.valueCategory, country: "jp") { result in
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


//APIManager.News.getTopHeadlines(category: screenType.valueCategory, country: "us") { result in
//    switch result {
//    case .failure(let error):
//        // call back
//        compeltion(false, error.localizedDescription)
//    case .success(let listNewsResult):
//        self.listNews.append(contentsOf: listNewsResult.listNews)
//
//        //call back
//        compeltion(true, "")
//    }
//}
