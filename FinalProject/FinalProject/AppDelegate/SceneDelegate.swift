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
        case following

        var title: String {
            switch self {
            case .home: return App.String.homeTabBar
            case .following: return App.String.followingTabBar
            }
        }
    }

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        configTabBarController()
        window?.makeKeyAndVisible()

        let dataImages: DictionaryDataImage = [:]
        UserDefaults.standard.set(dataImages, forKey: "dataImages")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        /// Remove all image data
        UserDefaults.standard.removeObject(forKey: "dataImages")
    }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }

    private func configTabBarController() {
        let homeScreen = UINavigationController(rootViewController: HomeViewController())
        let followingScreen = UINavigationController(rootViewController: FollowingViewController())
        followingScreen.tabBarItem = UITabBarItem(title: ScreenType.following.title, image: #imageLiteral(resourceName: "ic-following"), tag: ScreenType.following.rawValue)
        homeScreen.tabBarItem = UITabBarItem(title: ScreenType.home.title, image: #imageLiteral(resourceName: "ic-headlines"), tag: ScreenType.home.rawValue)

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeScreen, followingScreen]
        window?.rootViewController = tabBarController
    }
}

