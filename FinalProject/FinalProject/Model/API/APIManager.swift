//
//  API.Manager.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

struct APIManager {

    static let apiKey = "29bc913b0d1046a0a2c022139e9f003f"
    //    29bc913b0d1046a0a2c022139e9f003f
    //    60f0d8ac682040768931b4d4611d7f50
    //    8aca27737cb7450f806b28ae1fa14d88

    // MARK: - config
    struct Path {
        static let baseDomain = "https://newsapi.org"
        static let basePath = "/v2"
    }

    // MARK: - Domain
    struct News { }

    struct Downloader { }
}

extension APIManager.Path {

    struct TopHeadlines {
        static let topHeadlines = "/top-headlines"
        static var path: String { return baseDomain + basePath + topHeadlines }

        let category: String
        let country: String
        let pageSize: Int
        let page: Int

        var url: String {
            return APIManager.Path.TopHeadlines.path + "?country=" + country + "&category=" + category + "&apiKey=" + APIManager.apiKey + "&page=" + "\(page)" + "&pageSize=" + "\(pageSize)"
        }
    }

    struct Everything {
        static let everything = "/everything"
        static var path: String { return baseDomain + basePath + everything }

        let query: String
        let pageSize: Int
        let page: Int

        var url: String {
            return APIManager.Path.Everything.path + "?q=" + query + "&apiKey=" + APIManager.apiKey + "&page=" + "\(page)" + "&pageSize=" + "\(pageSize)"
        }
    }

}
