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
    @IBOutlet weak var scrollToTopButton: UIButton!

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
        tableView.register(UINib(nibName: Config.largeNewsCell, bundle: .main), forCellReuseIdentifier: Config.largeNewsCell)
        tableView.register(UINib(nibName: Config.smallNewsCell, bundle: .main), forCellReuseIdentifier: Config.smallNewsCell)
        tableView.register(UINib(nibName: Config.loadingCell, bundle: .main), forCellReuseIdentifier: Config.loadingCell)
        tableView.dataSource = self
        tableView.delegate = self

        /// config Refresh Control
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshViewController), for: .valueChanged)
    }

    /// config Loading View
    private func configLoadingView() {
        errorView.isHidden = true
        loadingView.backgroundColor = .white
        activityIndicatorView.startAnimating()
    }

    @objc private func refreshViewController() {
        guard !viewModel.isLoading else { return }
        if !viewModel.isRefreshing {
            viewModel.isRefreshing = true
            viewModel.refreshData { (done, _) in
                if done {
                    self.tableView.reloadData()
                    self.viewModel.isRefreshing = false
                    self.refreshControl.endRefreshing()
                } else {
                    self.viewModel.isRefreshing = false
                    #warning("API Error")
                }
            }
        }
    }

    private func loadAPI() {
        viewModel.loadAPI { (done, _) in
            if done {
                self.activityIndicatorView.stopAnimating()
                self.loadingView.isHidden = true
                self.tableView.reloadData()
            } else {
                self.activityIndicatorView.stopAnimating()
                self.errorView.isHidden = false
                #warning("API Error")
            }
        }
    }

    private func loadMore() {
        guard !viewModel.isLoading, viewModel.canLoadMore else { return }

        viewModel.isLoading = true
        viewModel.loadMoreAPI { (done, _) in
            if done {
                self.viewModel.isLoading = false
                self.tableView.reloadData()
            } else {
                self.viewModel.isLoading = false
                self.viewModel.canLoadMore = false
                #warning("API Error:")
                print("Can't load more") /// delete print later
            }
        }
    }

    @IBAction func scrollToTopButtonTochUpInside(_ sender: UIButton) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

// MARK: - NewsTableViewCellDelegate
extension BaseHomeChildViewController: NewsTableViewCellDelegate {
    func cell(_ cell: NewsTableViewCell, needPerform action: NewsTableViewCell.Action) {
        switch action {
        case .loadImage(let indexPath):
            viewModel.loadImage(indexPath: indexPath) { image in
                guard indexPath.row < self.viewModel.articles.count else { return }
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
        var identifierString = Config.smallNewsCell
        switch indexPath.row % 4 {
        case 0:
            identifierString = Config.largeNewsCell
        default:
            identifierString = Config.smallNewsCell
        }
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: identifierString, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        newsCell.delegate = self
        newsCell.viewModel = viewModel.getNewsCellViewModel(at: indexPath)
        return newsCell
    }
}

// MARK: - TableView Delegate
extension BaseHomeChildViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row % 4 {
        case 0:
            return 240
        default:
            return 160
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsDetail = NewsDetailViewController()
        newsDetail.viewModel = viewModel.getNewsDetailViewModel(at: indexPath)
        nextToViewController(viewcontroller: newsDetail)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height
        let scrollViewFrameHeigth = scrollView.frame.height

        if contentOffsetY >= contentSizeHeight - scrollViewFrameHeigth * 1.25 {
            loadMore()
        }
    }
}

// MARK: - Config
extension BaseHomeChildViewController {

    struct Config {
        static let largeNewsCell = "LargeNewsCell"
        static let smallNewsCell = "SmallNewsCell"
        static let loadingCell = "LoadingCell"
    }
}
