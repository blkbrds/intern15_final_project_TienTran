//
//  API.News.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

extension APIManager.News {
    struct QueryString {
        func getTopHeadlines(category: String, country: String, page: Int, pageSize: Int) -> String {
            return APIManager.Path.TopHeadlines(category: category, country: country, pageSize: pageSize, page: page).url
        }

        func getEverything(query: String, country: String, page: Int, pageSize: Int) -> String {
            return APIManager.Path.Everything(query: query, country: country, pageSize: pageSize, page: page).url
        }
    }

    struct QueryParam { }

    struct Response: Codable {
        var status: String
        var articles: [News]
    }

    static func getTopHeadlines(page: Int, pageSize: Int = 10, category: String, country: String, completion: @escaping APICompletion<Response>) {
        let urlString = QueryString().getTopHeadlines(category: category, country: country, page: page, pageSize: pageSize)
        API.shared().request(urlString: urlString) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(Response.self, from: data)
                        completion(.success(response))
                    } catch {
                        completion(.failure(.error(error.localizedDescription + "---- \(category)")))
                    }
                } else {
                    completion(.failure(.error("Data is not format")))
                }
            }
        }
    }

    static func getEverything(page: Int = 1, pageSize: Int = 20, query: String, country: String, completion: @escaping APICompletion<Response>) {
        let urlString = QueryString().getEverything(query: query, country: country, page: page, pageSize: pageSize)

        API.shared().request(urlString: urlString) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(Response.self, from: data)
                        completion(.success(response))
                    } catch {
                        completion(.failure(.error(error.localizedDescription + "---- \(query)")))
                    }
                } else {
                    completion(.failure(.error("Data is not format")))
                }
            }
        }
    }
}
