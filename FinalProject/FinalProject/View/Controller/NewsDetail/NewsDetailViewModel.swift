//
//  NewsDetailViewModel.swift
//  FinalProject
//
//  Created by PCI0002 on 2/5/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

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
    var favoritesImage: String? {
        if isFavorited {
            return "heart.fill"
        } else {
            return "heart"
        }
    }

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

    func setupObsever() {
        RealmManager.shared().setupObserve(News.self) { (done, error) in
            if done {
                self.delegate?.viewModel(self, needPerform: .reload)
            } else {
                self.delegate?.viewModel(self, needPerform: .error)
            }
        }
    }
}
