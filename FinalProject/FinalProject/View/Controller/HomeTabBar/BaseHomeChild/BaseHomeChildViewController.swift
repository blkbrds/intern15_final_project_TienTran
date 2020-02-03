//
//  BaseHomeChildViewController.swift
//  BaiTapTongHop
//
//  Created by TranVanTien on 1/1/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

final class BaseHomeChildViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var errorView: UIView!

    // MARK: - Properties
    var viewModel = BaseHomeChildViewModel()
    private var refreshControl = UIRefreshControl()

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        configLoadingView()
        configTableView()
    }

    override func setupData() {
        super.setupData()
        loadAPI()
    }

    // MARK: - Private funcs
    private func configTableView() {
        tableView.register(UINib(nibName: Config.newsTableViewCell, bundle: .main), forCellReuseIdentifier: Config.newsTableViewCell)
        tableView.register(UINib(nibName: Config.loadingCell, bundle: .main), forCellReuseIdentifier: Config.loadingCell)
        tableView.dataSource = self
        tableView.delegate = self

        /// config Refresh Control
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshViewController), for: .valueChanged)
    }

    /// config Loading View
    private func configLoadingView() {
        if !viewModel.isFirstData {
            errorView.isHidden = true
            loadingView.backgroundColor = .white
            activityIndicatorView.startAnimating()
        }
    }

    @objc private func refreshViewController() {
        if !viewModel.isRefreshing {
            viewModel.isRefreshing = true
            viewModel.refreshData { (done, error) in
                if done {
                    self.tableView.reloadData()
                    self.viewModel.isRefreshing = false
                } else {
                    self.viewModel.isRefreshing = false
                    print("API ERROR: \(error)")
                }
            }
            refreshControl.endRefreshing()
        }
    }

    private func loadAPI() {
        viewModel.loadAPI { (done, error) in
            if done {
                self.viewModel.isFirstData = done
                self.activityIndicatorView.stopAnimating()
                self.loadingView.isHidden = true
                self.tableView.reloadData()
            } else {
                print("\(self.viewModel.screenType.titleCategory): \(done)")
                self.activityIndicatorView.stopAnimating()
                self.errorView.isHidden = false
                print("API ERROR: \(error)")
            }
        }
    }

    private func loadMore() {
        if !viewModel.isLoading {
            viewModel.isLoading = true
            viewModel.loadMoreAPI { (done, error) in
                if done {
                    self.viewModel.isLoading = false
                    self.tableView.reloadData()
                } else {
                    self.viewModel.isLoading = false
                    print("API ERROR: \(error)")
                }
            }
        }
    }
}

// MARK: -  NewsTableViewCellDelegate
extension BaseHomeChildViewController: NewsTableViewCellDelegate {
    func cell(_ cell: NewsTableViewCell, needPerform action: NewsTableViewCell.Action) {
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

// MARK: - TableView Datasource
extension BaseHomeChildViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfListNews()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: Config.newsTableViewCell, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        newsCell.delegate = self
        newsCell.viewModel = viewModel.getNewsCellViewModel(indexPath: indexPath)
        return newsCell
    }
}

// MARK: - TableView Delegate
extension BaseHomeChildViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsDetail = NewsDetailViewController()
        //        #warning("Config: send link show news")
        pushViewController(viewcontroller: newsDetail)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height
        let scrollViewFrameHeigth = scrollView.frame.height

        if contentOffsetY >= contentSizeHeight - scrollViewFrameHeigth {
            loadMore()
        }
    }
}

// MARK: - Config
extension BaseHomeChildViewController {

    struct Config {
        static let newsTableViewCell = "NewsTableViewCell"
        static let loadingCell = "LoadingCell"
    }
}
