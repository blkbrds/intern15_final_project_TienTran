//
//  FavoritesCell.swift
//  FinalProject
//
//  Created by PCI0002 on 2/6/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

final class FavoritesCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var numberFavoritesLabel: UILabel!

    var viewModel: FavoritesCellViewModel? {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        categoryImageView.image = UIImage(named: viewModel.imageName)
        numberFavoritesLabel.text = String(viewModel.numberFavorites)
    }
}
