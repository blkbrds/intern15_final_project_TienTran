//
//  NewsDetailViewController.swift
//  BaiTapTongHop
//
//  Created by PCI0002 on 12/30/19.
//  Copyright © 2019 TranVanTien. All rights reserved.
//

import UIKit

final class NewsDetailViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var favoritesButton: UIButton!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet weak var customView: UIView!

    // MARK: - Propertites

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        configUI()
        configCustomNavigationBar()
    }

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Private funcs
    private func configUI() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)

//        navigationController?.navigationBar.isHidden = true
        commentTextField.clipsToBounds = true
        commentTextField.layer.cornerRadius = 15
        commentTextField.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        commentTextField.layer.borderWidth = 1
    }

    private func configCustomNavigationBar() {

//        guard let navi = navigationController else { return }
//        let navBarSize = navi.navigationBar.bounds.size
//        let origin = CGPoint(x: navBarSize.width / 2, y: navBarSize.height / 2)
////        pageControl.frame = CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>)
//
//        navigationItem.titleView?.addSubview(pageControl)
        guard let customNavigationBarView = Bundle.main.loadNibNamed("CustomNavigationBarView", owner: self, options: nil)?.first as? CustomNavigationBarView else { return }
        customNavigationBarView.frame = customView.frame
        customNavigationBarView.delegate = self
        customView.addSubview(customNavigationBarView)
    }
}

//
extension NewsDetailViewController: CustomNavigationBarViewDelegate {
    func customView(_ customView: CustomNavigationBarView, needPerform action: CustomNavigationBarView.Action) {
        switch action {
        case .backToView:
            guard let viewControllers = navigationController?.viewControllers else { return }
            for vc in viewControllers where vc is HomeViewController {
                let homeViewVC = vc as! HomeViewController
                popToViewController(viewcontroller: homeViewVC)
            }
        }
    }
}
