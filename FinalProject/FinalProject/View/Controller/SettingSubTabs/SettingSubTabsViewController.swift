//
//  SettingSubTabsViewController.swift
//  FinalProject
//
//  Created by PCI0002 on 2/17/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

final class SettingSubTabsViewController: BaseViewController {

    @IBOutlet private weak var collectionView: UICollectionView!

    var viewModel = SettingSubTabsViewModel()
    private var saveSubTabsBarButtonItem: UIBarButtonItem {
        let saveSubTabsBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveSettingSubTabsTouchUpInside))
        saveSubTabsBarButtonItem.tintColor = UIColor.purple.withAlphaComponent(0.55)
        return saveSubTabsBarButtonItem
    }

    override func setupUI() {
        super.setupUI()
        configCollectionView()
        title = "Customize subtabs"
        navigationItem.rightBarButtonItem = saveSubTabsBarButtonItem
    }

    override func setupData() {
        super.setupData()
        viewModel.getAllCellViewModel()
    }

    private func configCollectionView() {
        collectionView.register(UINib(nibName: Config.subTabsCell, bundle: .main), forCellWithReuseIdentifier: Config.subTabsCell)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    @objc func saveSettingSubTabsTouchUpInside() {
        viewModel.saveSettingSubTabs { (done, message) in
            if done {
                self.alert(title: "Setting SubTabs", msg: "Change setting success", buttons: ["Ok"], preferButton: "Ok", handler: { _ in
                    self.previousToViewController()
                    })
            } else {
                self.alert(title: "Setting SubTabs", msg: message, buttons: ["Please setting again"], preferButton: "", handler: nil)
            }
        }
    }
}

extension SettingSubTabsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNumberOfRowsInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Config.subTabsCell, for: indexPath) as? SubTabsCell else { return UICollectionViewCell() }
        cell.viewModel = viewModel.getSettingSubTabsCellViewModel(at: indexPath)
        cell.delegate = self
        return cell
    }
}

extension SettingSubTabsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        let itemWidth: CGFloat = width / 2 - 15
        let itemHeight: CGFloat = itemWidth * 0.7
        return CGSize(width: itemWidth, height: itemHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
    }
}

extension SettingSubTabsViewController: SubTabsCellDelegate {
    func cell(_ cell: SubTabsCell, needdPerform action: SubTabsCell.Action) {
        switch action {
        case .changeStatusButton(let indexPath):
            viewModel.changeStatus(with: indexPath) { [weak self] (done, message) in
                guard let this = self else { return }
                if done {
                    this.collectionView.reloadItems(at: [indexPath])
                } else {
                    alert(title: this.description, msg: message, buttons: ["Ok"], preferButton: "Ok", handler: nil)
                }
            }
        }
    }
}

// MARK: - Config
extension SettingSubTabsViewController {

    struct Config {
        static let settingSubTabsCell = "SettingSubTabsCell"
        static let subTabsCell = "SubTabsCell"
    }
}
