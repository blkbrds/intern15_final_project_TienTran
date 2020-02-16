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
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - Propertites
    var viewModel = NewsDetailViewModel()
    private var bookMarksBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(systemName: viewModel.favoritesImageString), style: .plain, target: self, action: #selector(changeBookMarkButtonTouchUpInside))
    }

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        configUI()
        configNewsWebView()
        addBookMarksBarButtonItem()
    }

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Private funcs
    private func configUI() {
        navigationItem.title = ""
        title = viewModel.news?.source?.name
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
    }

    private func configNewsWebView() {
        loadWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }

    private func loadWebView() {
        guard let urlNews = viewModel.news?.urlNews, let newsURL = URL(string: urlNews) else { return }
        let urlRequest = URLRequest(url: newsURL)
        webView.load(urlRequest)
    }

    private func addBookMarksBarButtonItem() {
        navigationItem.rightBarButtonItem = bookMarksBarButtonItem
    }

    private func changeStatusBookMarkButton() {
        bookMarksBarButtonItem.image = UIImage(systemName: viewModel.favoritesImageString)
        navigationItem.rightBarButtonItem = bookMarksBarButtonItem
//        bookMarksBarButtonItem.setBackgroundImage(UIImage(systemName: viewModel.favoritesImageString), for: .normal, barMetrics: .default)
        print(viewModel.favoritesImageString)
    }

    @objc private func changeBookMarkButtonTouchUpInside() {
        if viewModel.isFavorited {
            viewModel.removeNewsInFavorites { [weak self] (done, _) in
                guard let this = self else { return }
                if done {
                    this.changeStatusBookMarkButton()
                    #warning("Show alert")
                } else {
                    #warning("Realm Error")
                }
            }
        } else {
            viewModel.addNewsInFavorites { [weak self] (done, _) in
                guard let this = self else { return }
                if done {
                    this.changeStatusBookMarkButton()
                    #warning("Show alert")
                } else {
                    #warning("Realm Error")
                }
            }
        }
    }
}

// MARK: - WKUIDelegate
extension NewsDetailViewController: WKUIDelegate { }

extension NewsDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
}
