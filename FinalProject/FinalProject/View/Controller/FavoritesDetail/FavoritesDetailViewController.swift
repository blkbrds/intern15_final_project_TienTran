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
    private var editBarButtonItem = UIBarButtonItem()
    private var deleteBarButtonItem: UIBarButtonItem {
        let deleteBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteNewsButtonTouchUpInside))
        return deleteBarButtonItem
    }

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        title = "Favorites of \(viewModel.categoryType.text)"
        configTableView()
        configObserve()

        editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTouchUpInside))
        navigationItem.rightBarButtonItem = editBarButtonItem
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
        viewModel.fetchData { [weak self] (done, message) in
            guard let this = self else { return }
            if done {
                this.tableView.reloadData()
            } else {
                let titleDetail = this.viewModel.categoryType.text
                this.alert(title: "Bookmarks Detail \(titleDetail)", msg: message, buttons: ["Ok"], preferButton: "Ok", handler: { _ in
                        this.previousToViewController()
                    })
            }
        }
    }

    private func configObserve() {
        viewModel.setupObserve { [weak self] (done, message) in
            guard let this = self else { return }
            if done {
                this.fetchData()
                this.tableView.reloadData()
            } else {
                this.alert(title: "Bookmarks Detail", msg: message, buttons: ["Ok"], preferButton: "Ok", handler: nil) }
        }
    }

    @objc private func editButtonTouchUpInside() {
        let isEditing = !tableView.isEditing
        tableView.setEditing(isEditing, animated: true)
        if tableView.isEditing {
            editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(editButtonTouchUpInside))
            navigationItem.rightBarButtonItems = [editBarButtonItem, deleteBarButtonItem]
        } else {
            editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTouchUpInside))
            navigationItem.rightBarButtonItems = [editBarButtonItem]
        }
    }

    @objc private func deleteNewsButtonTouchUpInside() {
        alert(title: "Delete this news?", msg: "This action cannot be undone", buttons: ["Ok", "Cancel"], preferButton: "Ok") { _ in
            guard let selectedRows = self.tableView.indexPathsForSelectedRows else { return }
            let articles: [News] = selectedRows.compactMap { self.viewModel.articles[$0.row] }
            self.viewModel.removeArticlesInFavorites(articles: articles) { [weak self] (done, message) in
                guard let this = self else { return }
                if done {
                    this.tableView.beginUpdates()
                    this.tableView.deleteRows(at: selectedRows, with: .automatic)
                    this.tableView.endUpdates()
                } else {
                    this.alert(title: "Bookmarks Detail", msg: message, buttons: ["Ok"], preferButton: "Ok", handler: nil) }
            }
        }
    }

    deinit {
        viewModel.invalidateNotificationToken()
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
        if tableView.isEditing { return }
        tableView.deselectRow(at: indexPath, animated: true)
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
                guard indexPath.row < self.viewModel.articles.count else { return }
                if image != nil {
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        case .delete(let indexPath):
            alert(title: "Delete this news?", msg: "This action cannot be undone", buttons: ["Ok", "Cancel"], preferButton: "Ok") { _ in
                self.viewModel.removeNewsInFavorites(indexPath: indexPath) { [weak self] (done, message) in
                    guard let this = self else { return }
                    if done {
                        this.tableView.deleteRows(at: [indexPath], with: .left)
                    } else {
                        this.alert(title: "Bookmarks Detail", msg: message, buttons: ["Ok"], preferButton: "Ok", handler: nil)
                    }
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
