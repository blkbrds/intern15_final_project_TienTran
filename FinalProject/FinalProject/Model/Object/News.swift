//
//  News.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import RealmSwift

final class Source: Object, Codable {
    @objc dynamic var id: String?
    @objc dynamic var name: String?

    override class func primaryKey() -> String? {
        return "name"
    }
}

final class News: Object, Codable {
    @objc dynamic var source: Source? = Source()
    @objc dynamic var titleNews: String?
    @objc dynamic var urlNews: String?
    @objc dynamic var urlImage: String?
    @objc dynamic var publishedAt: Date?
    @objc dynamic var author: String?
    @objc dynamic var content: String?
    @objc dynamic var descriptionNews: String?
    @objc dynamic var categoryNews: String?

    enum CodingKeys: String, CodingKey {
        case titleNews = "title"
        case urlNews = "url"
        case urlImage = "urlToImage"
        case descriptionNews = "description"
        case publishedAt, content, source, author
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
            urlImage = try? container.decode(String.self, forKey: .urlImage)
            content = try? container.decode(String.self, forKey: .content)
            author = try? container.decode(String.self, forKey: .author)
            descriptionNews = try? container.decode(String.self, forKey: .descriptionNews)
            urlNews = try? container.decode(String.self, forKey: .urlNews)
            if let dateString = try? container.decode(String.self, forKey: .publishedAt) {
                let formatter = DateFormatter.iso8601Full
                if let date = formatter.date(from: dateString) {
                    publishedAt = date
                }
            }
        }
    }
}
