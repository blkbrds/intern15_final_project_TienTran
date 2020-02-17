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

    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var moveButton: UIButton!

    weak var delegate: SettingSubTabsCellDelegate?
    var viewModel: SettingSubTabsCellViewModel? {
        didSet {
            updateUI()
        }
    }

    func updateUI() {
        guard let viewModel = viewModel else { return }
        categoryLabel.text = viewModel.category.text
        print(viewModel.backgroundImageString)
        checkButton.setImage(UIImage(systemName: viewModel.backgroundImageString), for: .normal)
    }

    @IBAction private func checkButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        print(viewModel.isEnable)
        delegate?.cell(self, needdPerform: .changeStatusButton(indexPath: viewModel.indexPath))
    }
}
