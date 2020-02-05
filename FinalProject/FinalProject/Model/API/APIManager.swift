//
//  API.Manager.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

struct APIManager {

    static let api_key = "60f0d8ac682040768931b4d4611d7f50"

    // MARK: - config
    struct Path {
        static let base_domain = "https://newsapi.org"
        static let base_path = "/v2"
    }

    //MARK: - Domain
    struct News { }

    struct Downloader { }
}

extension APIManager.Path {

    struct TopHeadlines {
        static let top_headlines = "/top-headlines"
        static var path: String { return base_domain + base_path + top_headlines }

        let category: String
        let country: String
        let pageSize: Int
        let page: Int

        var url: String { return APIManager.Path.TopHeadlines.path + "?country=" + country + "&category=" + category + "&apiKey=" + APIManager.api_key + "&page=" + "\(page)" + "&pageSize=" + "\(pageSize)" }
    }
}
