//
//  FavoritesViewController.swift
//  FinalProject
//
//  Created by PCI0002 on 2/6/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

final class FavoritesViewController: BaseViewController {

    // MARK: - IBOulets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var noArticlesBookmarksView: UIView!

    // MARK: - Properties
    var viewModel = FavoritesViewModel()

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        title = "Bookmarks"
        noArticlesBookmarksView.isHidden = false
        configCollectionView()
        configObserve()
    }

    // MARK: - Private funcs
    private func configCollectionView() {
        collectionView.register(UINib(nibName: Config.favoritesCell, bundle: .main), forCellWithReuseIdentifier: Config.favoritesCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func configObserve() {
        viewModel.setupObserve { [weak self] (done, message) in
            guard let this = self else { return }
            if done {
                if this.viewModel.isEmtyBookmarks() {
                    this.noArticlesBookmarksView.isHidden = false
                } else {
                    this.noArticlesBookmarksView.isHidden = true
                }
                this.collectionView.reloadData()
            } else {
                this.alert(title: "Bookmarks", msg: message, buttons: ["Ok"], preferButton: "Ok", handler: nil)
            }
        }
    }

    deinit {
        viewModel.invalidateNotificationToken()
    }
}

// MARK: - CollectionView DataSource, Delegate
extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCategories()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let favoritesCell = collectionView.dequeueReusableCell(withReuseIdentifier: Config.favoritesCell, for: indexPath) as? FavoritesCell else { return UICollectionViewCell() }
        favoritesCell.viewModel = viewModel.getFavoritesCellViewModel(at: indexPath)
        return favoritesCell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let favoritesDetailVC = FavoritesDetailViewController()
        favoritesDetailVC.viewModel = viewModel.getFavoritesDetailViewModel(at: indexPath)
        nextToViewController(viewcontroller: favoritesDetailVC)
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let itemWidth: CGFloat = width / 2 - 15
        let itemHeight: CGFloat = itemWidth * 0.7
        return CGSize(width: itemWidth, height: itemHeight) }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    }
}

// MARK: - Config
extension FavoritesViewController {

    struct Config {
        static let favoritesCell = "FavoritesCell"
    }
}
