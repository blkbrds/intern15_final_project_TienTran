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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!

    // MARK: - Properties
    var viewModel = BaseHomeChildViewModel()

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Remove all image data
//        UserDefaults.standard.dictionaryRepresentation().keys.enumerated().forEach { (i, key) in
//            if key.matchesRegex(for: "https*") && i > 100 {
//                UserDefaults.standard.removeObject(forKey: key)
//            }
//        }
    }

    // MARK: - Private funcs
    private func configTableView() {
        tableView.register(UINib(nibName: Config.newsTableViewCell, bundle: .main), forCellReuseIdentifier: Config.newsTableViewCell)
        tableView.register(UINib(nibName: Config.loadingCell, bundle: .main), forCellReuseIdentifier: Config.loadingCell)
        tableView.dataSource = self
        tableView.delegate = self
    }

    /// Config Loading View
    private func configLoadingView() {
        if !self.viewModel.isFirstData {
            self.errorView.isHidden = true
            self.loadingView.backgroundColor = .white
            self.activityIndicatorView.startAnimating()
        }
    }

    private func loadAPI() {
        viewModel.loadAPI { (done, msg) in
            if done {
                self.viewModel.isFirstData = done
                self.activityIndicatorView.stopAnimating()
                self.loadingView.isHidden = true
                self.tableView.reloadData()
            } else {
                print("\(self.viewModel.screenType.titleCategory): \(done)")
                print("Curent: \(Thread.current)")
                self.activityIndicatorView.stopAnimating()
                self.errorView.isHidden = false
                print("API ERROR: \(msg)")
            }
        }
    }

    private func loadMore() {
        if !viewModel.isLoading {
            viewModel.isLoading = true
            viewModel.loadMoreAPI { (done, msg) in
                if done {
                    self.viewModel.isLoading = false
                    self.tableView.reloadData()
                } else {
                    self.viewModel.isLoading = false
                    print("API ERROR: \(msg)")
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

// MARK: -  TableView Delegate
extension BaseHomeChildViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsDetail = NewsDetailViewController()
        //        #warning("Config: send link show news")
        pushViewController(viewcontroller: newsDetail)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height
        let scrollViewFrameHeigth = scrollView.frame.height

        if !decelerate {
            if contentOffsetY >= contentSizeHeight - scrollViewFrameHeigth {
                loadMore()
            }
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
