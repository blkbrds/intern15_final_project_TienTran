//
//  NewsTableViewCellViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 1/14/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class NewsTableViewCellViewModel {
    var publishedAt: String
    var newsTitle: String
    var nameSource: String
    var urlImage: String
    var indexPath: IndexPath

    init(newsTitle: String,
        nameSource: String,
        publishedAt: String,
        urlImage: String,
        indexPath: IndexPath) {
        self.newsTitle = newsTitle
        self.nameSource = nameSource
        self.publishedAt = publishedAt
        self.urlImage = urlImage
        self.indexPath = indexPath
    }
}
