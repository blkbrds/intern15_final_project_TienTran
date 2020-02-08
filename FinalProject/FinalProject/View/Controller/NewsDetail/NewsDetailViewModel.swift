//
//  NewsDetailViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/5/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class NewsDetailViewModel {

    var urlNews: String?
    var nameSource: String?
    var isFavorited: Bool = false
    var indexPath: IndexPath?
    var favoritesImage: String? {
        if isFavorited {
            return "heart.fill"
        } else {
            return "heart"
        }
    }

    init() { }
    
    init(urlNews: String, nameSource: String, isFavorited: Bool = false, indexPath: IndexPath) {
        self.urlNews = urlNews
        self.nameSource = nameSource
        self.isFavorited = isFavorited
        self.indexPath = indexPath
    }
}

extension NewsDetailViewModel {
    
    func addNewsInFavorites() {
        isFavorited = true
        print("Add oke")
    }
    
    func removeNewsInFavorites() {
        isFavorited = false
        print("Remove oke")
    }
}
