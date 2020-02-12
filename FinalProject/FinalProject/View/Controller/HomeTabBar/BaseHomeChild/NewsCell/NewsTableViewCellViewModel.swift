//
//  NewsTableViewCellViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 1/14/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class NewsTableViewCellViewModel {
    var publishedAt: Date
    var newsTitle: String
    var nameSource: String
    var urlImage: String
    var urlNews: String
    var indexPath: IndexPath

    init(newsTitle: String, nameSource: String, publishedAt: Date, urlImage: String, urlNews: String, indexPath: IndexPath) {
        self.newsTitle = newsTitle
        self.nameSource = nameSource
        self.publishedAt = publishedAt
        self.urlImage = urlImage
        self.urlNews = urlNews
        self.indexPath = indexPath
    }
}
