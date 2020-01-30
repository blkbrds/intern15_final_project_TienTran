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
        updateUI()

        /// Remove all image data
        UserDefaults.standard.dictionaryRepresentation().keys.enumerated().forEach { (i, key) in
            if key.matchesRegex(for: "https*") && i > 150 {
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

    private func updateUI() {
        tableView.reloadData()
    }

    private func loadAPI() {
        // MARK: - test cho mot man hinh
        if viewModel.screenType == .us {
            viewModel.loadAPI { (done, msg) in
                if done {
                    self.viewModel.isFirstData = done
                    self.updateUI()
                } else {
                    #warning("show alert")
                    print("API ERROR: \(msg)")
                }
            }
        }
    }

    private func loadMore() {
        // MARK: - test cho mot man hinh
        if viewModel.screenType == .us {
            if !viewModel.isLoading {
                viewModel.isLoading = true
                print("loadmore")
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
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
    }
}

// MARK: - TableView Datasource
extension BaseHomeChildViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return viewModel.numberOfListNews()
        case 1:
            return 1
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isFirstData {
            switch indexPath.section {
            case 0:
                guard let newsCell = tableView.dequeueReusableCell(withIdentifier: Config.newsTableViewCell, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
                newsCell.delegate = self
                newsCell.viewModel = viewModel.getNewsCellViewModel(indexPath: indexPath)
                return newsCell
            case 1:
                guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: Config.loadingCell, for: indexPath) as? LoadingCell else { return UITableViewCell() }
                loadingCell.activityIndicator.startAnimating()
                return loadingCell
            default:
                return UITableViewCell()
            }
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
            switch indexPath.section {
            case 0:
                return 160
            case 1:
                return 25
            default:
                return 0
            }
        } else {
            return tableView.frame.height
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsDetail = NewsDetailViewController()
//        #warning("Config: send link show news")
        pushViewController(viewcontroller: newsDetail)
    }
}

// MARK: - Config
extension BaseHomeChildViewController {

    struct Config {
        static let newsTableViewCell = "NewsTableViewCell"
        static let loadingCell = "LoadingCell"
    }
}
