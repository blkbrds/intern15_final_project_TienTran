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
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = BaseHomeChildViewModel()

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        configTableView()
    }

    override func setupData() {
        super.setupData()
        loadAPI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()

        // Remove all image data
        UserDefaults.standard.dictionaryRepresentation().keys.enumerated().forEach { (i, key) in
            if key.matchesRegex(for: "https*") && i > 100 {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }

    // MARK: - Private funcs
    private func configTableView() {
        tableView.register(UINib(nibName: Config.newsTableViewCell, bundle: .main), forCellReuseIdentifier: Config.newsTableViewCell)
        tableView.register(UINib(nibName: Config.loadingCell, bundle: .main), forCellReuseIdentifier: Config.loadingCell)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func loadAPI() {
        viewModel.loadAPI { (done, msg) in
            if done {
                self.viewModel.isFirstData = done
                self.tableView.reloadData()
            } else {
                #warning("show page error")
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
                    print("API ERROR: \(msg)")
                    self.viewModel.isLoading = false
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isFirstData {
            return viewModel.numberOfListNews()
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isFirstData {
            guard let newsCell = tableView.dequeueReusableCell(withIdentifier: Config.newsTableViewCell, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
            newsCell.delegate = self
            newsCell.viewModel = viewModel.getNewsCellViewModel(indexPath: indexPath)
            return newsCell
        } else {
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: Config.loadingCell, for: indexPath) as? LoadingCell else { return UITableViewCell() }
            loadingCell.activityIndicator.startAnimating()
            return loadingCell
        }
    }
}

// MARK: -  TableView Delegate
extension BaseHomeChildViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isFirstData {
            return 160
        } else {
            return tableView.frame.height
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isFirstData {
            let newsDetail = NewsDetailViewController()
            //        #warning("Config: send link show news")
            pushViewController(viewcontroller: newsDetail)
        }
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
