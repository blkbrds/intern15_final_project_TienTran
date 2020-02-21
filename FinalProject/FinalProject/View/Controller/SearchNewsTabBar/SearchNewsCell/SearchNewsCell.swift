//
//  SearchNewsCell.swift
//  FinalProject
//
//  Created by TranVanTien on 2/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

protocol SearchNewsCellDelegate: class {
    func cell(_ cell: SearchNewsCell, needPerform action: SearchNewsCell.Action)
}

class SearchNewsCell: UICollectionViewCell {

    enum Action {
        case loadImage(indexPath: IndexPath)
    }

    @IBOutlet private weak var publishedLabel: UILabel!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var nameSourceLabel: UILabel!
    @IBOutlet private weak var iconSourceImageView: UIImageView!

    weak var delegate: SearchNewsCellDelegate?
    var viewModel: SearchNewsCellViewModel? {
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
        nameSourceLabel.clipsToBounds = true
        nameSourceLabel.layer.cornerRadius = 7
        publishedLabel.clipsToBounds = true
        publishedLabel.layer.cornerRadius = 7
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        publishedLabel.text = viewModel.news.publishedAt?.relativelyFormatted(short: false)
        newsTitleLabel.text = viewModel.news.titleNews
        nameSourceLabel.text = viewModel.news.source?.name ?? ""

        if let dataImages = UserDefaults.standard.dictionary(forKey: "dataImages") as? DictionaryDataImage, let dataImage = dataImages[viewModel.news.urlImage ?? ""] {
            newsImageView.image = UIImage(data: dataImage)
        } else {
            newsImageView.image = #imageLiteral(resourceName: "news-default")
            delegate?.cell(self, needPerform: .loadImage(indexPath: viewModel.indexPath))
        }
    }
}
