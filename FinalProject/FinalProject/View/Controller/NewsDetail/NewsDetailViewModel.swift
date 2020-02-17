//
//  NewsDetailViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/5/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import UIKit

protocol NewsDetailViewModelDelegate: class {
    func viewModel(_ viewModel: NewsDetailViewModel, needPerform action: NewsDetailViewModel.Action)
}

final class NewsDetailViewModel {

    enum Action {
        case reload, error
    }

    var news: News?
    var isFavorited: Bool = false
    var indexPath: IndexPath?
    var favoritesImageString: String { return isFavorited ? "bookmark.fill" : "bookmark" }

    weak var delegate: NewsDetailViewModelDelegate?

    init() { }

    init(news: News, indexPath: IndexPath, isFavorited: Bool = false) {
        self.news = news
        self.indexPath = indexPath
        self.isFavorited = isFavorited
    }
}

extension NewsDetailViewModel {

    func addNewsInFavorites(completion: @escaping Completion) {
        guard let news = news else { return }
        RealmManager.shared().addObject(object: news) { (done, error) in
            if done {
                self.isFavorited = true
                completion(done, "")
            } else {
                completion(done, error)
            }
        }
    }

    func removeNewsInFavorites(completion: @escaping Completion) {
        guard let news = news else { return }
        RealmManager.shared().deleteObject(object: news, forPrimaryKey: news.urlNews) { (done, error) in
            if done {
                self.isFavorited = false
                completion(done, "")
            } else {
                completion(done, error)
            }
        }
    }

    /// check favorites contains news?
    func isRealmContainsObject() -> Bool {
        guard let news = news else { return false }
        return RealmManager.shared().isRealmContainsObject(object: news, forPrimaryKey: news.urlNews)
    }

    /// dowload image
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let news = news else { completion(nil); return }

        if let newsImageData = UserDefaults.standard.data(forKey: news.urlImage ?? "") {
            let newsImage = UIImage(data: newsImageData)
            completion(newsImage)
        } else {
            APIManager.Downloader.downloadImage(urlString: news.urlImage ?? "") { image in
                if let image = image {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
