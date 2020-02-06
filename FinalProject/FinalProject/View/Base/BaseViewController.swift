//
//  BaseViewController.swift
//  BaiTapTongHop
//
//  Created by PCI0002 on 12/30/19.
//  Copyright © 2019 TranVanTien. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }

    // MARK : setup Data & UI
    func setupData() { }

    func setupUI() { }

    func nextToViewController(viewcontroller: UIViewController) {
        navigationController?.pushViewController(viewcontroller, animated: true)
    }

    func previousToViewController() {
        navigationController?.popViewController(animated: true)
    }

    func previousToViewController(viewcontroller: UIViewController) {
        navigationController?.popToViewController(viewcontroller, animated: true)
    }
}
