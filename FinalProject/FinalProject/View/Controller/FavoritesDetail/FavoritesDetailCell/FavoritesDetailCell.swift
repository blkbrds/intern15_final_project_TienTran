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
    }

    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var contentNewsLabel: UILabel!
    @IBOutlet private weak var publishedLabel: UILabel!
    @IBOutlet private weak var deleteNewsButton: UIButton!

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
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        publishedLabel.text = viewModel.publishedAt.toString()
        contentNewsLabel.text = viewModel.contentNews

        if let dataImages = UserDefaults.standard.dictionary(forKey: "dataImages") as? DictionaryDataImage, let dataImage = dataImages[viewModel.urlImage] {
            newsImageView.image = UIImage(data: dataImage)
        } else {
            newsImageView.image = #imageLiteral(resourceName: "news-default")
            delegate?.cell(self, needPerform: .loadImage(indexPath: viewModel.indexPath))
        }
    }

    @IBAction private func deleteNewsButtonTouchUpInside(_ sender: Any) {
        #warning("delegate")
    }
}
