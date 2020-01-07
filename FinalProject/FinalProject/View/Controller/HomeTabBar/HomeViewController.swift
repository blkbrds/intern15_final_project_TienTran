//
//  HomeViewController.swift
//  BaiTapTongHop
//
//  Created by PCI0002 on 12/30/19.
//  Copyright © 2019 TranVanTien. All rights reserved.
//

import UIKit

final class HomeViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var menuCategoryCollectionView: UICollectionView!

    // MARK: - Properties
    private var selectedIndex = 0
    private let menuCategoryCell = "MenuCategoryCell"
    private let menuCategory = ["U.S", "Business", "Technology", "Health", "Science", "Sports", "Entertainment"]

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        title = "Headlines"
        configMenuCategoryCollectionView()
    }

    // MARK: - Private funcs
    private func configMenuCategoryCollectionView() {
        menuCategoryCollectionView.register(UINib(nibName: menuCategoryCell, bundle: .main), forCellWithReuseIdentifier: menuCategoryCell)
        menuCategoryCollectionView.dataSource = self
        menuCategoryCollectionView.delegate = self
        // auto resize item
        if let flowLayout = menuCategoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }

    private func scrollToCategoryMenu(at selectedIndex: Int) {
        menuCategoryCollectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)

        for i in 0..<menuCategory.count {
            if let cell = menuCategoryCollectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? MenuCategoryCell {
                cell.configUI(isEnable: i == selectedIndex)
            }
        }
    }
}

// MARK: - CollectionView DataSource, Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuCategory.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let menuCell = menuCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: menuCategoryCell, for: indexPath) as? MenuCategoryCell else { return UICollectionViewCell() }
        menuCell.configUI(category: menuCategory[indexPath.row], isEnable: selectedIndex == indexPath.row)
        return menuCell
    }

    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        scrollToCategoryMenu(at: selectedIndex)
    }
}
