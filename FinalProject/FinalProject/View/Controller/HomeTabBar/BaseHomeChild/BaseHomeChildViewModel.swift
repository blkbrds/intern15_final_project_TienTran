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
    var screenType: CategoryType = .us
    var articles: [News] = []
    var isRefreshing = false
    var isLoading = false
    var canLoadMore = true
    private var currentPageParam = 1
}

// MARK: - config tableview
extension BaseHomeChildViewModel {
    func numberOfListNews() -> Int {
        return articles.count
    }

    func getNewsCellViewModel(at indexPath: IndexPath) -> NewsTableViewCellViewModel {
        let news = articles[indexPath.row]
        let newsCellViewModel = NewsTableViewCellViewModel(
            newsTitle: news.titleNews,
            nameSource: news.source.name,
            publishedAt: news.publishedAt ?? Date.currentDate(),
            urlImage: news.urlImage ?? "",
            urlNews: news.urlNews,
            indexPath: indexPath)
        return newsCellViewModel
    }

    func getNewsDetailViewModel(at indexPath: IndexPath) -> NewsDetailViewModel {
        let news = articles[indexPath.row]
        let newsDetailViewModel = NewsDetailViewModel(
            urlNews: news.urlNews,
            nameSource: news.source.name,
            indexPath: indexPath)
        return newsDetailViewModel
    }
}

// MARK: - handle api
extension BaseHomeChildViewModel {

    // load api
    func loadAPI(compeltion: @escaping Completion) {
        APIManager.News.getTopHeadlines(page: 1, category: screenType.param, country: "us") { result in
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

    // loadmore api
    func loadMoreAPI(compeltion: @escaping Completion) {
        currentPageParam += 1
        APIManager.News.getTopHeadlines(page: currentPageParam, category: screenType.param, country: "us") { result in
            switch result {
            case .failure(let error):
                compeltion(false, error.localizedDescription)
            case .success(let response):
                if response.articles.count > 0 {
                    self.articles.append(contentsOf: response.articles)

                    //call back
                    compeltion(true, "")
                } else {
                    self.canLoadMore = false
                    compeltion(false, "Can't loadmore!")
                }
            }
        }
    }

    // load api
    func refreshData(compeltion: @escaping Completion) {
        APIManager.News.getTopHeadlines(page: 1, category: screenType.param, country: "us") { result in
            switch result {
            case .failure(let error):
                // call back
                compeltion(false, error.localizedDescription)
            case .success(let response):
                self.articles = response.articles

                //call back
                compeltion(true, "")
            }
        }
    }

    // dowload image
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
                    completion(nil) /// tra ve anh default && khi vao lai cell do no se tiep tuc tai lai anh
                }
            }
        }
    }
}
