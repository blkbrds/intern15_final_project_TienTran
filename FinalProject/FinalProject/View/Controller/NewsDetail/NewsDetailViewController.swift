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
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var customView: UIView!
    @IBOutlet weak var webView: WKWebView!

    // MARK: - Propertites
    var viewModel: NewsDetailViewModel?

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        configUI()
        configCustomNavigationBar()
        configNewsWebView()
    }

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Private funcs
    private func configUI() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

        commentTextField.clipsToBounds = true
        commentTextField.layer.cornerRadius = 15
        commentTextField.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        commentTextField.layer.borderWidth = 1
    }

    private func configCustomNavigationBar() {
        guard let customNavigationBarView = Bundle.main.loadNibNamed("CustomNavigationBarView", owner: self, options: nil)?.first as? CustomNavigationBarView else { return }
        customNavigationBarView.frame = customView.bounds
        customNavigationBarView.delegate = self
        customView.addSubview(customNavigationBarView)
    }

    private func configNewsWebView() {
        guard let viewModel = viewModel, let newsURL = URL(string: viewModel.urlNews) else { return }
        let urlRequest = URLRequest(url: newsURL)
        webView.load(urlRequest)
        webView.uiDelegate = self
    }
    
    // MARK: - IBAction
    
    @IBAction private func changeFavoritesButtonTouchUpInside(_ sender: Any) {
        #warning("change favorites")
    }
}

// MARK: - WKUIDelegate
extension NewsDetailViewController: WKUIDelegate { }

// MARK: - CustomNavigationBarViewDelegate
extension NewsDetailViewController: CustomNavigationBarViewDelegate {
    func customView(_ customView: CustomNavigationBarView, needPerform action: CustomNavigationBarView.Action) {
        switch action {
        case .previousToViewController:
            guard let viewControllers = navigationController?.viewControllers else { return }
            for vc in viewControllers where vc is HomeViewController {
                let homeViewVC = vc as! HomeViewController
                previousToViewController(viewcontroller: homeViewVC)
            }
        }
    }
}
