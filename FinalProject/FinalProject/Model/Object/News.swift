//
//  News.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import RealmSwift

final class Source: Object, Codable {
    @objc dynamic var id: String? = ""
    @objc dynamic var name: String? = ""

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
    @objc dynamic var author: String? = ""
    @objc dynamic var content: String? = ""
    @objc dynamic var descriptionNews: String? = ""
    @objc dynamic var categoryNews: String? = ""

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

    required init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            if let source = try? container.decode(Source.self, forKey: .source) {
                self.source = source
            }
            if let titleNews = try? container.decode(String.self, forKey: .titleNews) {
                self.titleNews = titleNews
            }
            if let urlImage = try? container.decode(String.self, forKey: .urlImage) {
                self.urlImage = urlImage
            }
            if let content = try? container.decode(String.self, forKey: .content) {
                self.content = content
            }
            if let author = try? container.decode(String.self, forKey: .author) {
                self.author = author
            }
            if let descriptionNews = try? container.decode(String.self, forKey: .descriptionNews) {
                self.descriptionNews = descriptionNews
            }
            if let urlNews = try? container.decode(String.self, forKey: .urlNews) {
                self.urlNews = urlNews
            }
            if let dateString = try? container.decode(String.self, forKey: .publishedAt) {
                let formatter = DateFormatter.iso8601Full
                if let date = formatter.date(from: dateString) {
                    publishedAt = date
                }
            }
        }
    }
}
