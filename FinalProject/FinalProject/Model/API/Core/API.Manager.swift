//
//  API.Manager.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

struct APIManager {

    // MARK: - config
    struct Path {
        static let base_domain = "https://newsapi.org"
        static let base_path = "/v2"
        static let api_key = "29bc913b0d1046a0a2c022139e9f003f"
    }

    //MARK: - Domain
    struct News { }
}

extension APIManager.Path {

    struct TopHeadlines {
        static let top_headlines = "/top-headlines"
        static var path: String { return base_domain + base_path + top_headlines }

        let category: String
        let country: String
        let pageSize: Int
        let page: Int
        
        var url: String { return APIManager.Path.TopHeadlines.path + "?country=" + country + "&category=" + category + "&apiKey=" + api_key + "&page=" + "\(page)" +  "&pageSize=" + "\(pageSize)"}
    }
}
