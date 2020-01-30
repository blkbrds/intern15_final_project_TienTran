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
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func updateUI() {
        tableView.reloadData()
    }

    private func loadAPI() {
        viewModel.loadAPI { (done, msg) in
            if done {
                self.updateUI()
            } else {
                #warning("show alert")
                print("API ERROR: \(msg)")
            }
        }
    }
}

// MARK: TableView Datasource
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
}

// MARK: - Config
extension BaseHomeChildViewController {

    struct Config {
        static let newsTableViewCell = "NewsTableViewCell"
    }
}
