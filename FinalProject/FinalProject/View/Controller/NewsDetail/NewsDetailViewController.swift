//
//  NewsDetailViewController.swift
//  BaiTapTongHop
//
//  Created by PCI0002 on 12/30/19.
//  Copyright © 2019 TranVanTien. All rights reserved.
//

import UIKit
import WebKit

final class NewsDetailViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet weak var webView: WKWebView!

    // MARK: - Propertites
    var viewModel: NewsDetailViewModel?

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        configUI()
        configNewsWebView()
        configBackForwardListNews()
    }

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Private funcs
    private func configUI() {
        navigationItem.title = ""
        guard let viewModel = viewModel else { return }
        title = viewModel.nameSource
    }

    private func configNewsWebView() {
        guard let viewModel = viewModel, let newsURL = URL(string: viewModel.urlNews) else { return }
        let urlRequest = URLRequest(url: newsURL)
        webView.load(urlRequest)
        webView.uiDelegate = self
    }

    private func configBackForwardListNews() {
        let backForwardNews = UIBarButtonItem(title: "<", style: .done, target: self, action: #selector(forwardListNews))
        navigationItem.rightBarButtonItem = backForwardNews
    }

    @objc private func forwardListNews() {
        let list = webView.backForwardList.backList
        
    }

    // MARK: - IBAction
    @IBAction private func changeFavoritesButtonTouchUpInside(_ sender: Any) {
        #warning("change favorites")
    }
}

// MARK: - WKUIDelegate
extension NewsDetailViewController: WKUIDelegate {

}

// MARK: - CustomNavigationBarViewDelegate
extension NewsDetailViewController: CustomNavigationBarViewDelegate {
    func customView(_ customView: CustomNavigationBarView, needPerform action: CustomNavigationBarView.Action) {
        switch action {
        case .previousToViewController:
            previousToViewController()
        }
    }
}
