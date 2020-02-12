//
//  FavoritesDetailCellViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/12/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class FavoritesDetailCellViewModel {
    var publishedAt: Date
    var urlImage: String
    var urlNews: String
    var contentNews: String
    var indexPath: IndexPath

    init(publishedAt: Date,
        urlImage: String,
        urlNews: String,
        contentNews: String,
        indexPath: IndexPath) {
        self.publishedAt = publishedAt
        self.urlImage = urlImage
        self.urlNews = urlNews
        self.contentNews = contentNews
        self.indexPath = indexPath
    }
}
