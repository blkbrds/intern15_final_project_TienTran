//
//  NewsTableViewCell.swift
//  BaiTapTongHop
//
//  Created by PCI0002 on 12/30/19.
//  Copyright © 2019 TranVanTien. All rights reserved.
//

import UIKit

protocol NewsTableViewCellDelegate: class {
    func cell(_ cell: NewsTableViewCell, needPerform action: NewsTableViewCell.Action)
}

final class NewsTableViewCell: UITableViewCell {

    enum Action {
        case loadImage(indexPath: IndexPath)
    }

    // MARK: - IBOutlet
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var nameSourceLabel: UILabel!
    @IBOutlet weak var iconSourceImageView: UIImageView!

    // MARK: - Properties
    weak var delegate: NewsTableViewCellDelegate?
    var viewModel: NewsTableViewCellViewModel? {
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
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        publishedLabel.text = viewModel.publishedLabel
        newsTitleLabel.text = viewModel.newsTitleLabel
        nameSourceLabel.text = viewModel.nameSourceLabel
        if let newsImage = viewModel.newsImage {
            newsImageView.image = newsImage
        } else {
            delegate?.cell(self, needPerform: .loadImage(indexPath: viewModel.indexPath))
        }
    }
}
