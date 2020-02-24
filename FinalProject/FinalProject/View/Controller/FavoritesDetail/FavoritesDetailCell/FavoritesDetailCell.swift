//
//  FavoritesDetailCell.swift
//  FinalProject
//
//  Created by PCI0002 on 2/11/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

protocol FavoritesDetailCellDelegate: class {
    func cell(_ cell: FavoritesDetailCell, needPerform action: FavoritesDetailCell.Action)
}

final class FavoritesDetailCell: UITableViewCell {

    enum Action {
        case loadImage(indexPath: IndexPath)
        case delete(indexPath: IndexPath)
    }

    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var titleNewsLabel: UILabel!
    @IBOutlet private weak var publishedLabel: UILabel!
    @IBOutlet private weak var deleteNewsButton: UIButton!
    @IBOutlet private weak var nameSourceLabel: UILabel!
    @IBOutlet private weak var iconSourceImageView: UIImageView!

    weak var delegate: FavoritesDetailCellDelegate?
    var viewModel: FavoritesDetailCellViewModel? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    private func configUI() {
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 5
        deleteNewsButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        tintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        publishedLabel.text = (viewModel.news.publishedAt ?? Date.currentDate()).relativelyFormatted(short: false)
        titleNewsLabel.text = viewModel.news.titleNews
        nameSourceLabel.text = viewModel.news.source?.name

        if let dataImages = UserDefaults.standard.dictionary(forKey: "dataImages") as? DictionaryDataImage, let urlImage = viewModel.news.urlImage, let dataImage = dataImages[urlImage] {
            newsImageView.image = UIImage(data: dataImage)
        } else {
            newsImageView.image = #imageLiteral(resourceName: "news-default")
            delegate?.cell(self, needPerform: .loadImage(indexPath: viewModel.indexPath))
        }
    }

    @IBAction private func deleteNewsButtonTouchUpInside(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, needPerform: .delete(indexPath: viewModel.indexPath))
    }
}
