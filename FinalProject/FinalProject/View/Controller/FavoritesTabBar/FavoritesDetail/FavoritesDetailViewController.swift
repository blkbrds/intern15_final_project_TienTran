//
//  FavoritesDetailViewController.swift
//  FinalProject
//
//  Created by PCI0002 on 2/7/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

final class FavoritesDetailViewController: BaseViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = FavoritesDetailViewModel()

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        title = "Favorites Detail"
        configTableView()
    }

    // MARK: - Private funcs
    private func configTableView() {
        tableView.register(UINib(nibName: Config.newsTableViewCell, bundle: .main), forCellReuseIdentifier: Config.newsTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - TableViewDelegate
extension FavoritesDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

// MARK: - TableViewDataSource
extension FavoritesDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.newsTableViewCell, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getNewsCellViewModel(at: indexPath)
        return cell
    }
}

// MARK: - Config
extension FavoritesDetailViewController {

    struct Config {
        static let newsTableViewCell = "NewsTableViewCell"
    }
}

