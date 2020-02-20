//
//  SettingSubTabsCell.swift
//  FinalProject
//
//  Created by PCI0002 on 2/17/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

protocol SettingSubTabsCellDelegate: class {
    func cell(_ cell: SettingSubTabsCell, needdPerform action: SettingSubTabsCell.Action)
}

final class SettingSubTabsCell: UITableViewCell {

    enum Action {
        case changeStatusButton(indexPath: IndexPath)
    }

    @IBOutlet private weak var categoryImageView: UIImageView!
    @IBOutlet private weak var checkButton: UIButton!

    weak var delegate: SettingSubTabsCellDelegate?
    var viewModel: SettingSubTabsCellViewModel? {
        didSet {
            updateUI()
        }
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
