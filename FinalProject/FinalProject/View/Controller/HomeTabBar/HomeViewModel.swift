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

    var canLoadMore: Bool = true

    let group = DispatchGroup()
}

extension HomeViewModel {

    func numberOfCategories() -> Int {
        categories.count
    }

    func getCategoryCellViewModel(indexPath: IndexPath) -> CategoryCellViewModel {
        return CategoryCellViewModel(textCategoryLabel: categories[indexPath.row].text, isEnable: currentPage == indexPath.row)
    }

    func getHomeChildViewModel(index: Int) -> BaseHomeChildViewModel {
        return BaseHomeChildViewModel(articles: articlesArray[index], category: categories[index], isLoading: isLoading[index], index: index)
    }

    func resetArrayData() {
        let count = categories.count
        articlesArray = Array(repeating: [], count: count)
        isLoading = Array(repeating: true, count: count)
        currentPageParam = Array(repeating: 1, count: count)

    }
}

extension HomeViewModel {

    func loadApi(completion: @escaping Completion) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.categories.enumerated().forEach { (index, category) in
                self.group.enter()
                APIManager.News.getTopHeadlines(page: 1, category: category.param, country: "us") { result in
                    switch result {
                    case .failure(let error):
                        #warning("API Error")
                        print("\(category.text) load fail: - \(error.localizedDescription)!")
                        // Delete print later
                    case .success(let response):
                        if response.articles.isEmpty {
                            #warning("API Error")
                            print("\(category.text) data empty !")
                            // Delete print later
                        } else {
                            let articles: [News] = response.articles
                            articles.forEach { $0.categoryNews = category.param }
                            self.articlesArray[index] = articles
                        }
                    }
                    self.group.leave()
                    self.isLoading[index] = false
                    print("\(category.imageName) load done!")
                }
            }
            //        loadApiDispatchGroup.wait()
            self.group.notify(queue: .main) {
                print("Loaded done!.")
                completion(true, "")
            }
        }
    }

    func refreshData(index: Int, category: CategoryType, completion: @escaping Completion) {
        DispatchQueue.global(qos: .userInitiated).sync {
            var bool: Bool = false
            var error: APIError = .error("")
            APIManager.News.getTopHeadlines(page: 1, category: category.param, country: "us") { result in
                switch result {
                case .failure(let erro):
                    // call back
                    bool = false
                    error = erro
                case .success(let response):
                    let articles: [News] = response.articles
                    articles.forEach { $0.categoryNews = category.param }
                    self.articlesArray[index] = articles
                    self.canLoadMore = true
                    self.currentPageParam[index] = 1
                    // call back
                    bool = true
                }
            }

            self.group.notify(queue: .main) {
                print("Refresh done!.")
                completion(bool, error.localizedDescription)
            }
        }
    }
    /*
     /// load api
     func refreshData(compeltion: @escaping Completion) {
         APIManager.News.getTopHeadlines(page: 1, category: category.param, country: "us") { result in
             switch result {
             case .failure(let error):
                 // call back
                 compeltion(false, error.localizedDescription)
             case .success(let response):
                 self.articles = response.articles
                 self.canLoadMore = true
                 self.currentPageParam = 1
                 self.setCategoryInNews()
                 // call back
                 compeltion(true, "")
             }
         }
     }

     */
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
