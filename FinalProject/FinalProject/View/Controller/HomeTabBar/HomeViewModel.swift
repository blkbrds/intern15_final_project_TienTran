//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class HomeViewModel {
    var navigationDirection = false

    var currentPage = 0 {
        didSet {
            if oldValue > currentPage {
                navigationDirection = true
            } else {
                navigationDirection = false
            }
        }
    }

    var categories: [CategoryType] {
        return SettingManager.shared().categories
    }

    var articlesArray: [[News]] = []
    var isLoading: [Bool] = []
    var currentPageParam: [Int] = []
    var canLoadMore: [Bool] = []

    var isRefreshing = false

    let group = DispatchGroup()
}

extension HomeViewModel {

    func numberOfCategories() -> Int {
        categories.count
    }

    func getCategoryCellViewModel(indexPath: IndexPath) -> CategoryCellViewModel {
        return CategoryCellViewModel(textCategoryString: categories[indexPath.row].text, isEnable: currentPage == indexPath.row)
    }

    func getHomeChildViewModel(index: Int) -> HomeChildViewModel {
        return HomeChildViewModel(articles: articlesArray[index], category: categories[index], isLoading: isLoading[index], index: index)
    }

    func configData() {
        let count = categories.count
        articlesArray = Array(repeating: [], count: count)
        isLoading = Array(repeating: true, count: count)
        currentPageParam = Array(repeating: 1, count: count)
        canLoadMore = Array(repeating: true, count: count)
    }
}

extension HomeViewModel {

    func fecthData(index: Int, category: CategoryType, completion: @escaping Completion) {
        APIManager.News.getTopHeadlines(page: 1, category: category.param, country: "us") { result in
            switch result {
            case .failure(let error):
                completion(false, error.localizedDescription)
            case .success(let response):
                if response.articles.isEmpty {
                    completion(false, "Empty data")
                } else {
                    let articles: [News] = response.articles
                    self.setCategoryInNews(articles: articles, category: category)
                    self.articlesArray[index] = articles
                    completion(true, "")
                }
            }
            self.isLoading[index] = false
        }
    }

    func refreshData(index: Int, category: CategoryType, completion: @escaping Completion) {
        isRefreshing = true
        APIManager.News.getTopHeadlines(page: 1, category: category.param, country: "us") { result in
            switch result {
            case .failure(let error):
                completion(false, error.localizedDescription)
            case .success(let response):
                let articles: [News] = response.articles
                self.setCategoryInNews(articles: articles, category: category)
                self.articlesArray[index] = articles
                self.canLoadMore[index] = true
                self.currentPageParam[index] = 1

                completion(true, "")
            }
            self.isRefreshing = false
        }
    }

    func loadMoreApi(index: Int, category: CategoryType, completion: @escaping Completion) {
        isLoading[index] = true
        currentPageParam[index] += 1
        APIManager.News.getTopHeadlines(page: currentPageParam[index], category: category.param, country: "us") { result in
            switch result {
            case .failure(let error):
                completion(false, error.localizedDescription)
            case .success(let response):
                let articles: [News] = response.articles
                if articles.count > 0 {
                    self.setCategoryInNews(articles: articles, category: category)
                    self.articlesArray[index].append(contentsOf: articles)
                    completion(true, "")
                } else {
                    self.canLoadMore[index] = false
                    completion(false, "Can't loadmore!")
                }
            }
            self.isLoading[index] = false
        }
    }

    /// add category
    func setCategoryInNews(articles: [News], category: CategoryType) {
        articles.forEach { $0.categoryNews = category.param }
    }
}

enum CategoryType: Int, CaseIterable {
    case us = 0
    case business
    case technology
    case health
    case science
    case sports
    case entertainment

    var text: String {
        switch self {
        case .us:
            return "U.S."
        case .business:
            return "Business"
        case .technology:
            return "Technology"
        case .health:
            return "Health"
        case .science:
            return "Science"
        case .sports:
            return "Sports"
        case .entertainment:
            return "Entertainment"
        }
    }

    var param: String {
        switch self {
        case .us:
            return "general"
        case .business:
            return "business"
        case .technology:
            return "technology"
        case .health:
            return "health"
        case .science:
            return "science"
        case .sports:
            return "sports"
        case .entertainment:
            return "entertainment"
        }
    }

    var imageName: String {
        switch self {
        case .us:
            return "us"
        case .business:
            return "business"
        case .technology:
            return "technology"
        case .health:
            return "health"
        case .science:
            return "science"
        case .sports:
            return "sports"
        case .entertainment:
            return "entertainment"
        }
    }

    static var allCases: [CategoryType] {
        return [.us, .health, .science, .technology, .sports, .entertainment, .business]
    }
}
