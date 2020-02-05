//
//  News.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

struct Source: Codable {
    var id: String?
    var name: String = ""
}

struct News: Codable {
    var source: Source = Source()
    var titleNews: String = ""
    var urlNews: String = ""
    var urlImage: String?
    var publishedAt: Date?

    enum CodingKeys: String, CodingKey {
        case source
        case titleNews = "title"
        case urlNews = "url"
        case urlImage = "urlToImage"
        case publishedAt
    }
}

extension News {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decode(Source.self, forKey: .source)
        titleNews = try container.decode(String.self, forKey: .titleNews)
        urlNews = try container.decode(String.self, forKey: .urlNews)
        urlImage = try container.decode(String.self, forKey: .urlImage)

        let dateString = try container.decode(String.self, forKey: .publishedAt)
        let formatter = DateFormatter.iso8601Full
        if let date = formatter.date(from: dateString) {
            publishedAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .publishedAt,
                in: container,
                debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}
