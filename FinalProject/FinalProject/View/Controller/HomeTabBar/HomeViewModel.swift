//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class HomeViewModel {
    var currentIndex = 0
    var selectedIndex = 0
    var categories: [HomeScreenType] = HomeScreenType.allCases
}

// MARK: - config tableview
extension HomeViewModel {
    func numberOfCategories() -> Int {
        categories.count
    }

    func getCategoryCellViewModel(indexPath: IndexPath) -> CategoryCellViewModel {
        return CategoryCellViewModel(textCategoryLabel: categories[indexPath.row].titleCategory, isEnable: selectedIndex == indexPath.row)
    }
}

enum HomeScreenType: Int, CaseIterable {
    case us
    case business
    case technology
    case health
    case science
    case sports
    case entertainment

    var titleCategory: String {
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
    
    var valueCategory: String {
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
}
