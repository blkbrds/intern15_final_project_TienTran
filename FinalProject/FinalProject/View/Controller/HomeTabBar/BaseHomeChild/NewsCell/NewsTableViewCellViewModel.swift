//
//  NewsTableViewCellViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 1/14/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class NewsTableViewCellViewModel {
    var publishedLabel: String
    var newsTitleLabel: String
    var nameSourceLabel: String
    var urlImage: String
    var indexPath: IndexPath

    init(newsTitleLabel: String,
        nameSourceLabel: String,
        publishedLabel: String,
        urlImage: String,
        indexPath: IndexPath) {
        self.newsTitleLabel = newsTitleLabel
        self.nameSourceLabel = nameSourceLabel
        self.publishedLabel = publishedLabel
        self.urlImage = urlImage
        self.indexPath = indexPath
    }
}
