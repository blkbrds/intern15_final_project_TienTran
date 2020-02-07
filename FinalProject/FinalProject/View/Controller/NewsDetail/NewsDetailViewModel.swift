//
//  NewsDetailViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/5/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class NewsDetailViewModel {

    var urlNews: String
    var nameSource: String
    var isFavorites: Bool
    var indexPath: IndexPath
    var favoritesImage: String {
        if isFavorites {
            return "heart.fill"
        } else {
            return "heart"
        }
    }

    init(urlNews: String, nameSource: String, isFavorites: Bool = false, indexPath: IndexPath) {
        self.urlNews = urlNews
        self.nameSource = nameSource
        self.isFavorites = isFavorites
        self.indexPath = indexPath
    }
}
