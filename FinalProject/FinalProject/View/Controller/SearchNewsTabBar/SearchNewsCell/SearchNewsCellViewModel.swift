//
//  SearchNewsCellViewModel.swift
//  FinalProject
//
//  Created by TranVanTien on 2/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

final class SearchNewsCellViewModel {
    var news: News
    var indexPath: IndexPath

    init(news: News, indexPath: IndexPath) {
        self.news = news
        self.indexPath = indexPath
    }
}
