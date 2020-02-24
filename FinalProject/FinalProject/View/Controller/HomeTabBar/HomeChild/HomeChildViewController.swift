//
//  BaseHomeChildViewController.swift
//  BaiTapTongHop
//
//  Created by TranVanTien on 1/1/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

protocol HomeChildViewControllerDelegate: class {
    func viewController(_ viewController: HomeChildViewController, needPerform action: HomeChildViewController.Action)
}

final class HomeChildViewController: BaseViewController {
    enum Action {
        case fetchData(index: Int, category: CategoryType)
        case loadMore(index: Int, category: CategoryType)
        case pullToRefresh(index: Int, category: CategoryType)
    }

    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var errorView: UIView!

    // MARK: - Properties
    var viewModel: HomeChildViewModel = HomeChildViewModel() {
        didSet {
            guard tableView != nil else { return }
            fetchData()
        }
    }

    var notificationCenter = NotificationCenter.default
    private var refreshControl = UIRefreshControl()
    weak var delegate: HomeChildViewControllerDelegate?

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        configLoadingView()
        configTableView()
    }

    override func setupData() {
        super.setupData()
        delegate?.viewController(self, needPerform: .fetchData(index: viewModel.index, category: viewModel.category))
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
        refreshControl.addTarget(self, action: #selector(refreshHomeChildVC), for: .valueChanged)
    }

    /// config Loading View
    private func configLoadingView() {
        errorView.isHidden = true
        loadingView.backgroundColor = .white
        activityIndicatorView.startAnimating()
    }

    private func fetchData() {
        activityIndicatorView.stopAnimating()
        if viewModel.articles.count > 1 {
            loadingView.isHidden = true
            tableView.reloadData()
            #warning("Delete print later")
            print("\(viewModel.category.text):  \(viewModel.articles.count)")
        } else {
            errorView.isHidden = false
        }

        guard refreshControl.isRefreshing else { return }
        refreshControl.endRefreshing()
    }

    @objc private func reloadHomeChildVC() {
        activityIndicatorView.stopAnimating()
        if viewModel.articles.count > 1 {
            loadingView.isHidden = true
            tableView.reloadData()
        } else {
            errorView.isHidden = false
        }
    }

    @objc private func refreshHomeChildVC() {
        delegate?.viewController(self, needPerform: .pullToRefresh(index: viewModel.index, category: viewModel.category))
    }

    private func loadMore() {
        delegate?.viewController(self, needPerform: .loadMore(index: viewModel.index, category: viewModel.category))
    }
}

// MARK: - NewsTableViewCellDelegate
extension HomeChildViewController: NewsTableViewCellDelegate {
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
extension HomeChildViewController: UITableViewDataSource {
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
extension HomeChildViewController: UITableViewDelegate {
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
extension HomeChildViewController {

    struct Config {
        static let largeNewsCell = "LargeNewsCell"
        static let smallNewsCell = "SmallNewsCell"
        static let loadingCell = "LoadingCell"
    }
}
