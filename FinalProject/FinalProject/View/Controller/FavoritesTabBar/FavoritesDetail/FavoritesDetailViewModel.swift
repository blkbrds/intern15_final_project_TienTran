//
//  FavoritesDetailViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/7/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class FavoritesDetailViewModel {
    var articles: [News] = []
}

extension FavoritesDetailViewModel {
    func numberOfListNews() -> Int {
        return articles.count
    }

    func getNewsCellViewModel(at indexPath: IndexPath) -> NewsTableViewCellViewModel {
        _ = articles[indexPath.row]
        let newsCellViewModel = NewsTableViewCellViewModel(
            newsTitle: "newsTitle",
            nameSource: "nameSource",
            publishedAt: Date.currentDate(),
            urlImage: "urlImage",
            urlNews: "urlNews",
            indexPath: indexPath)
        return newsCellViewModel
    }
    
    func getArticlesFormReaml(){
        
    }
}
