//
//  CategoryCell.swift
//  FinalProject
//
//  Created by PCI0002 on 1/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

final class CategoryCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var backgroundColorView: UIView!

    // MARK: - Properties
    var viewModel: CategoryCellViewModel? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColorView.clipsToBounds = true
        backgroundColorView.layer.cornerRadius = 2
        categoryLabel.autoresizingMask = [.flexibleWidth]
    }

    func updateUI() {
        guard let viewModel = viewModel else { return }
        categoryLabel.text = viewModel.textCategoryLabel
        backgroundColorView.backgroundColor = viewModel.isEnable ? #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1): #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
