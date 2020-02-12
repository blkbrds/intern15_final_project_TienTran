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

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsSourceLabel: UILabel!
    @IBOutlet weak var newsPublishedAtLabel: UILabel!

    var delegate: SearchNewsCellDelegate?
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
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        newsPublishedAtLabel.text = viewModel.news.publishedAt?.relativelyFormatted(short: true)
        newsTitleLabel.text = viewModel.news.titleNews
        newsSourceLabel.text = viewModel.news.source?.name ?? ""

        if let dataImages = UserDefaults.standard.dictionary(forKey: "dataImages") as? DictionaryDataImage, let dataImage = dataImages[viewModel.news.urlImage ?? ""] {
            newsImageView.image = UIImage(data: dataImage)
        } else {
            newsImageView.image = #imageLiteral(resourceName: "news-default")
            delegate?.cell(self, needPerform: .loadImage(indexPath: viewModel.indexPath))
        }
    }
}
