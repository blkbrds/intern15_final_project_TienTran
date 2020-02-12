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
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var previousNewsButton: UIButton!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - Propertites
    var viewModel = NewsDetailViewModel()

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        configUI()
        configNewsWebView()
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

        previousNewsButton.isHidden = true
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

    // MARK: - IBAction
    @IBAction private func changeFavoritesButtonTouchUpInside(_ sender: Any) {
        #warning("change favorites")
    }

    @IBAction private func previousNewsButtonTouchUpInside(_ sender: Any) {
        loadWebView()
    }
}

// MARK: - WKUIDelegate
extension NewsDetailViewController: WKUIDelegate { }

extension NewsDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView.backForwardList.backList.count > 0 {
            previousNewsButton.isHidden = false
        }
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true
    }
}
