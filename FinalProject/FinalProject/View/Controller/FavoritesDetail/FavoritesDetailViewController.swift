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
        title = "Favorites of \(viewModel.categoryType.text)"
        configTableView()
    }

    override func setupData() {
        super.setupData()
        fetchData()
    }

    // MARK: - Private funcs
    private func configTableView() {
        tableView.register(UINib(nibName: Config.favoritesDetailCell, bundle: .main), forCellReuseIdentifier: Config.favoritesDetailCell)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func fetchData() {
        viewModel.fetchData { (done, msg) in
            if done {
                self.tableView.reloadData()
            } else {
                print("Realm Error: \(msg)")
            }
        }
    }
}

// MARK: - TableViewDelegate
extension FavoritesDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsDetail = NewsDetailViewController()
        newsDetail.viewModel = viewModel.getNewsDetailViewModel(at: indexPath)
        nextToViewController(viewcontroller: newsDetail)
    }
}

// MARK: - TableViewDataSource
extension FavoritesDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Config.favoritesDetailCell, for: indexPath) as? FavoritesDetailCell else { return UITableViewCell() }
        cell.delegate = self
        cell.viewModel = viewModel.getFavoritesDetailCellViewModel(at: indexPath)
        return cell
    }
}

extension FavoritesDetailViewController: FavoritesDetailCellDelegate {
    func cell(_ cell: FavoritesDetailCell, needPerform action: FavoritesDetailCell.Action) {
        switch action {
        case .loadImage(let indexPath):
            viewModel.loadImage(indexPath: indexPath) { image in
                if image != nil {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
}

// MARK: - Config
extension FavoritesDetailViewController {

    struct Config {
        static let favoritesDetailCell = "FavoritesDetailCell"
    }
}

