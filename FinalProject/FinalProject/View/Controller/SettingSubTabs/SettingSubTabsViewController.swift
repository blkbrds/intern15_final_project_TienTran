//
//  SettingSubTabsViewController.swift
//  FinalProject
//
//  Created by PCI0002 on 2/17/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

final class SettingSubTabsViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    var viewModel = SettingSubTabsViewModel()
    private var saveSubTabsBarButtonItem: UIBarButtonItem {
        let saveSubTabsBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveSettingSubTabsTouchUpInside))
        saveSubTabsBarButtonItem.tintColor = .purple
        return saveSubTabsBarButtonItem
    }

    override func setupUI() {
        super.setupUI()
        configTableView()
        title = "Customize subtabs"
        navigationItem.rightBarButtonItem = saveSubTabsBarButtonItem
    }

    override func setupData() {
        super.setupData()
        viewModel.getAllCellViewModel()
    }

    private func configTableView() {
        tableView.register(UINib(nibName: Config.settingSubTabsCell, bundle: .main), forCellReuseIdentifier: Config.settingSubTabsCell)
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc func saveSettingSubTabsTouchUpInside() {
        viewModel.saveSettingSubTabs()
    }
}

extension SettingSubTabsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension SettingSubTabsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.settingSubTabsCell, for: indexPath) as? SettingSubTabsCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getSettingSubTabsCellViewModel(at: indexPath)
        cell.delegate = self
        return cell
    }
}

extension SettingSubTabsViewController: SettingSubTabsCellDelegate {
    func cell(_ cell: SettingSubTabsCell, needdPerform action: SettingSubTabsCell.Action) {
        switch action {
        case .changeStatusButton(let indexPath):
            viewModel.changeStatus(with: indexPath) { [weak self] (done, error) in
                guard let this = self else { return }
                if done {
                    this.tableView.reloadRows(at: [indexPath], with: .none)
                } else {
                    #warning("Delete print later")
                    print("Error: \(error)")
                }
            }
        }
    }
}

// MARK: - Config
extension SettingSubTabsViewController {

    struct Config {
        static let settingSubTabsCell = "SettingSubTabsCell"
    }
}
