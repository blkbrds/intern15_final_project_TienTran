//
//  CustomNavigationBarView.swift
//  FinalProject
//
//  Created by PCI0002 on 2/5/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

protocol CustomNavigationBarViewDelegate: class {
    func customView(_ customView: CustomNavigationBarView, needPerform action: CustomNavigationBarView.Action)
}

final class CustomNavigationBarView: UIView {

    enum Action {
        case previousToViewController
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var pageControl: UIPageControl!

    // MARK: - Properties
    weak var delegate: CustomNavigationBarViewDelegate?

    // MARK: - IBAction
    @IBAction private func backToViewTouchUpInside(_ sender: Any) {
        delegate?.customView(self, needPerform: .previousToViewController)
    }
}
