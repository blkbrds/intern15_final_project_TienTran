//
//  News.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

struct Source: Codable {
    var name: String?
}

struct News: Codable {
    var source: Source?
    var titleNews: String?
    var urlNews: String?
    var urlImageNews: String?
    var publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case source
        case titleNews = "title"
        case urlNews = "url"
        case urlImageNews = "urlToImage"
        case publishedAt
    }
}
