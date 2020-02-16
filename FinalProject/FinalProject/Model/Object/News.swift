//
//  News.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import RealmSwift

final class Source: Object, Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""

    override class func primaryKey() -> String? {
        return "name"
    }
}

final class News: Object, Codable {
    @objc dynamic var source: Source? = Source()
    @objc dynamic var titleNews: String? = ""
    @objc dynamic var urlNews: String? = ""
    @objc dynamic var urlImage: String? = ""
    @objc dynamic var publishedAt: Date? = Date.currentDate()
    @objc dynamic var content: String? = ""
    @objc dynamic var categoryNews: String? = ""

    enum CodingKeys: String, CodingKey {
        case source = "source"
        case titleNews = "title"
        case urlNews = "url"
        case urlImage = "urlToImage"
        case publishedAt
        case content
    }

    override class func primaryKey() -> String? {
        return "urlNews"
    }

    required init() {
        super.init()
    }

    required init(from decoder: Decoder) {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            source = try? container.decode(Source.self, forKey: .source)
            titleNews = try? container.decode(String.self, forKey: .titleNews)
            urlNews = try? container.decode(String.self, forKey: .urlNews)
            urlImage = try? container.decode(String.self, forKey: .urlImage)
            content = try? container.decode(String.self, forKey: .content)

            let formatter = DateFormatter.iso8601Full
            if let dateString = try? container.decode(String.self, forKey: .publishedAt),
                let date = formatter.date(from: dateString) {
                publishedAt = date
            }
        }
    }
}
