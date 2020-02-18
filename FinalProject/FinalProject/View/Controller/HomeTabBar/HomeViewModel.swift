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

    var categories: [CategoryType] = []
}

// MARK: - config tableview
extension HomeViewModel {
    func numberOfCategories() -> Int {
        categories.count
    }

    func getCategoryCellViewModel(indexPath: IndexPath) -> CategoryCellViewModel {
        return CategoryCellViewModel(textCategoryLabel: categories[indexPath.row].text, isEnable: currentPage == indexPath.row)
    }

    func fetchCategorise() {
        categories = SettingManager.shared().getTabCategories()
    }

    func fetchCategorise(complete: @escaping Completion) {
        let newCategories = SettingManager.shared().getTabCategories()
        if !newCategories.elementsEqual(categories) {
            categories = newCategories
            complete(true, "")
        }
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
