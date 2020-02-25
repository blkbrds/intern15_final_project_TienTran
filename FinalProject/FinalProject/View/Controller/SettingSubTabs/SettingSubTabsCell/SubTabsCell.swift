//
//  SubTabsCell.swift
//  FinalProject
//
//  Created by TranVanTien on 2/24/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

protocol SubTabsCellDelegate: class {
    func cell(_ cell: SubTabsCell, needdPerform action: SubTabsCell.Action)
}

final class SubTabsCell: UICollectionViewCell {

    enum Action {
        case changeStatusButton(indexPath: IndexPath)
    }

    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var checkButton: UIButton!

    weak var delegate: SubTabsCellDelegate?
    var viewModel: SubTabsCellViewModel? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }

    private func configUI() {
        categoryImageView.clipsToBounds = true
        categoryImageView.layer.cornerRadius = 10
    }

    func updateUI() {
        guard let viewModel = viewModel else { return }
        categoryImageView.image = UIImage(named: viewModel.category.imageName)
        checkButton.setBackgroundImage(UIImage(systemName: viewModel.backgroundImageString), for: .normal)
        checkButton.tintColor = viewModel.isEnable ? #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1): #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }

    @IBAction private func checkButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel, viewModel.category != .us, viewModel.category != .health else { return }
        delegate?.cell(self, needdPerform: .changeStatusButton(indexPath: viewModel.indexPath))
    }
}
