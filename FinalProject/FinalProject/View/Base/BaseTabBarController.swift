//
//  BaseTabBarController.swift
//  BaiTapTongHop
//
//  Created by PCI0002 on 12/30/19.
//  Copyright © 2019 TranVanTien. All rights reserved.
//

import UIKit

final class BaseTabBarController: UITabBarController {
    enum ScreenType: Int {
        case home = 0
        case following

        var title: String {
            switch self {
            case .home: return "Headlines"
            case .following: return "Following"
            }
        }
    }

    static weak var shared: BaseTabBarController?

    private var homeScreen = UINavigationController(rootViewController: HomeViewController())
    private var followingScreen = UINavigationController(rootViewController: FollowingViewController())

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        BaseTabBarController.shared = self
        configViewController()
        configUI()
    }

    // MARK: - Private funcs
    private func configViewController() {
        followingScreen.tabBarItem = UITabBarItem(title: ScreenType.following.title, image: #imageLiteral(resourceName: "ic-following"), tag: ScreenType.following.rawValue)
        homeScreen.tabBarItem = UITabBarItem(title: ScreenType.home.title, image: #imageLiteral(resourceName: "ic-headlines"), tag: ScreenType.home.rawValue)

//        var viewControllers: [UIViewController]?
//        viewControllers?.append(homeScreen)
//        viewControllers?.append(followingScreen)

        setViewControllers([homeScreen, followingScreen], animated: true)
    }

    private func configUI() {
        tabBar.tintColor = .black
    }
}
