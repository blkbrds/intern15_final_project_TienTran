//
//  FavoritesDetailCellViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/12/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class FavoritesDetailCellViewModel {
    var news: News
    var indexPath: IndexPath

    init(news: News, indexPath: IndexPath) {
        self.news = news
        self.indexPath = indexPath
    }
}
