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
    @IBOutlet private weak var publishedLabel: UILabel!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var nameSourceLabel: UILabel!
    @IBOutlet private weak var iconSourceImageView: UIImageView!

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
        iconSourceImageView.clipsToBounds = true
        iconSourceImageView.layer.cornerRadius = 5
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        publishedLabel.text = viewModel.publishedAt.toString()
        newsTitleLabel.text = viewModel.newsTitle
        nameSourceLabel.text = viewModel.nameSource
        newsImageView.image = #imageLiteral(resourceName: "news-default")
        if let dataImages = UserDefaults.standard.dictionary(forKey: "dataImages") as? DictionaryDataImage,
            let dataImage = dataImages[viewModel.urlImage] {
            UIView.animate(withDuration: 1.5,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    self.newsImageView.image = UIImage(data: dataImage) },
                completion: nil)
        } else {
            delegate?.cell(self, needPerform: .loadImage(indexPath: viewModel.indexPath))
        }
    }
}
