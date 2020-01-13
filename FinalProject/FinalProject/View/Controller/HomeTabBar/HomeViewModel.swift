//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class HomeViewModel {

    // singleton
    private static var sharedHomeViewModel: HomeViewModel = {
        let homeViewModel = HomeViewModel()
        return homeViewModel
    }()

    static func shared() -> HomeViewModel {
        return sharedHomeViewModel
    }

    private init() {
        categories()
    }

    var selectedIndex = 0

    var menuCategory: [String] = []

    func categories() {
        for category in HomeScreenType.allCases {
            menuCategory.append(category.titleCategory)
        }
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
}
