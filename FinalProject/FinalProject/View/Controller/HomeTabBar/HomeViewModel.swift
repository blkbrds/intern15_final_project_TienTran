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

    func resetArrayData() {
        let count = categories.count
        articlesArray = Array(repeating: [], count: count)
        isLoading = Array(repeating: true, count: count)
        currentPageParam = Array(repeating: 1, count: count)
        canLoadMore = Array(repeating: true, count: count)
    }
}

extension HomeViewModel {

    func loadApi(completion: @escaping Completion) {
        resetArrayData()
        DispatchQueue.global(qos: .userInitiated).async {
            self.categories.enumerated().forEach { (index, category) in
                self.group.enter()
                APIManager.News.getTopHeadlines(page: 1, category: category.param, country: "us") { result in
                    switch result {
                    case .failure(let error):
                        print("\(category.text) load fail: - \(error.localizedDescription)!")
                        #warning("Delete print later handle error")
                    case .success(let response):
                        if response.articles.isEmpty {
                            #warning("Delete print later handle error")
                            print("\(category.text) data empty !")
                            // Delete print later
                        } else {
                            let articles: [News] = response.articles
                            self.setCategoryInNews(articles: articles, category: category)
                            self.articlesArray[index] = articles
                        }
                    }
                    self.group.leave()
                    self.isLoading[index] = false
                    #warning("Delete print later")
                    print("\(category.text) load done!")
                }
            }

            /// loadApiDispatchGroup.wait()
            self.group.notify(queue: .main) {
                print("------Loaded done!.------")
                completion(true, "")
            }
        }
    }

    func refreshData(index: Int, category: CategoryType, completion: @escaping Completion) {

        DispatchQueue.global(qos: .userInitiated).async {
            var bool: Bool = false
            var error: APIError = .error("")
            self.isRefreshing = true
            APIManager.News.getTopHeadlines(page: 1, category: category.param, country: "us") { result in
                switch result {
                case .failure(let erro):
                    // call back
                    bool = false
                    error = erro
                case .success(let response):
                    let articles: [News] = response.articles
                    self.setCategoryInNews(articles: articles, category: category)
                    self.articlesArray[index] = articles
                    self.canLoadMore[index] = true
                    self.currentPageParam[index] = 1
                    // call back
                    bool = true
                }
                self.isRefreshing = false
                completion(bool, error.localizedDescription)
            }
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
        #warning("Delete print later")
        print(articlesArray[index].count)
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
