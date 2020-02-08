//
//  News.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//
import RealmSwift
import Realm

final class Source: Object, Codable {
    @objc dynamic var name: String = ""
    
    override class func primaryKey() -> String? {
        return "name"
    }
}

final class News: Object, Codable {
    var source: Source? = Source()
    @objc dynamic var titleNews: String = ""
    @objc dynamic var urlNews: String = ""
    @objc dynamic var urlImage: String = ""
    @objc dynamic var publishedAt: Date = Date.currentDate()
    
    enum CodingKeys: String, CodingKey {
        case source
        case titleNews = "title"
        case urlNews = "url"
        case urlImage = "urlToImage"
        case publishedAt
    }

    override class func primaryKey() -> String? {
        return "titleNews"
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
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
