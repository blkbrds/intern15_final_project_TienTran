//
//  SceneDelegate.swift
//  FinalProject
//
//  Created by PCI0002 on 1/3/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    enum ScreenType: Int {
        case home = 0
        case favorites
        case search

        var title: String {
            switch self {
            case .home:
                return App.String.homeTabBar
            case .favorites:
                return App.String.followingTabBar
            case .search:
                return App.String.searchTabBar
            }
        }
    }

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        configTabBarController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Remove all image data
        APIManager.Downloader.clearImageData()
    }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

    private func configTabBarController() {
        let homeScreen = UINavigationController(rootViewController: HomeViewController())
        let favoritesScreen = UINavigationController(rootViewController: FavoritesViewController())
        let searchScreen = UINavigationController(rootViewController: SearchNewsViewController())
        favoritesScreen.tabBarItem = UITabBarItem(title: ScreenType.favorites.title, image: #imageLiteral(resourceName: "bookmark"), tag: ScreenType.favorites.rawValue)
        homeScreen.tabBarItem = UITabBarItem(title: ScreenType.home.title, image: #imageLiteral(resourceName: "logo"), tag: ScreenType.home.rawValue)
        searchScreen.tabBarItem = UITabBarItem(title: ScreenType.search.title, image: #imageLiteral(resourceName: "search"), tag: ScreenType.search.rawValue)
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeScreen, favoritesScreen, searchScreen]
        window?.rootViewController = tabBarController
    }
}
