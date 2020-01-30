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
    var urlStringImage: String
    var indexPath: IndexPath

    init(newsTitleLabel: String,
        nameSourceLabel: String,
        publishedLabel: String,
        urlStringImage: String,
        indexPath: IndexPath) {
        self.newsTitleLabel = newsTitleLabel
        self.nameSourceLabel = nameSourceLabel
        self.publishedLabel = publishedLabel
        self.urlStringImage = urlStringImage
        self.indexPath = indexPath
    }
}
