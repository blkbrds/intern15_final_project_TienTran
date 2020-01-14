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
        func getTopHeadlines(category: String, country: String) -> String {
            return APIManager.Path.TopHeadlines(category: category, country: country).url
        }
    }

    struct QueryParam { }

    struct NewsResult {
        var listNews: [News]
    }

    static func getTopHeadlines(category: String, country: String, completion: @escaping APICompletion<NewsResult>) {
        let urlString = QueryString().getTopHeadlines(category: category, country: country)

        API.shared().request(urlString: urlString) { result in
            switch result {
            case .failure(let error):
                // call back
                completion(.failure(error))
            case .success(let data):
                if let data = data {
                    // parse data
                    let json = data.toJSON()
                    let results = json["articles"] as! [JSON]

                    // news
                    var listNews: [News] = []
                    for item in results {
                        let news = News(json: item)
                        listNews.append(news)
                    }

                    // result
                    let newsResult = NewsResult(listNews: listNews)

                    // call back
                    completion(.success(newsResult))
                } else {
                    // call back
                    completion(.failure(.error("Data is not format")))
                }
            }
        }
    }
}
