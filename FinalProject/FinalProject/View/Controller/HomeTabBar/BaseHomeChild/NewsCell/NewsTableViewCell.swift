//
//  NewsTableViewCell.swift
//  BaiTapTongHop
//
//  Created by PCI0002 on 12/30/19.
//  Copyright © 2019 TranVanTien. All rights reserved.
//

import UIKit

final class NewsTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var nameSourceLabel: UILabel!
    @IBOutlet weak var iconSourceImageView: UIImageView!

    // MARK: - Properties
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
        newsImageView.layer.cornerRadius = 7
        iconSourceImageView.layer.cornerRadius = 10
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        publishedLabel.text = viewModel.publishedLabel
        newsTitleLabel.text = viewModel.newsTitleLabel
        nameSourceLabel.text = viewModel.nameSourceLabel
    }
}
