//
//  NewsTableViewCellViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 1/14/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import UIKit

final class NewsTableViewCellViewModel {
    var publishedLabel: String
    var newsTitleLabel: String
    var nameSourceLabel: String
    var newsImage: UIImage?
    var urlStringImage: String
    var indexPath: IndexPath

    init(newsTitleLabel: String,
        nameSourceLabel: String,
        publishedLabel: String,
        urlStringImage: String,
        newsImage: UIImage? = nil,
        indexPath: IndexPath) {
        self.newsTitleLabel = newsTitleLabel
        self.nameSourceLabel = nameSourceLabel
        self.publishedLabel = publishedLabel
        self.urlStringImage = urlStringImage
        self.indexPath = indexPath
        self.newsImage = newsImage
    }
}
