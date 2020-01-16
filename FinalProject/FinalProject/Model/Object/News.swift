//
//  News.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import UIKit

typealias JSON = [String: Any]

final class News {
    var titleNews: String
    var sourceName: String
    var urlNews: String
    var urlImage: String
    var newsImage: UIImage?
    var publishedAt: String

    init(json: JSON) {
        let source = json["source"] as! JSON
        self.sourceName = source["name"] as! String
        self.titleNews = json["title"] as! String
        self.urlNews = json["url"] as! String
        self.urlImage = json["urlToImage"] as? String ?? "https://www.feastalabang.com/wp-content/uploads/2018/07/FEAST-Series-Breaking-News-Postcard-FRONT.jpg"
        self.publishedAt = (json["publishedAt"] as! String).toTime()
    }
}
