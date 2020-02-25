//
//  HomeViewController.swift
//  BaiTapTongHop
//
//  Created by PCI0002 on 12/30/19.
//  Copyright © 2019 TranVanTien. All rights reserved.
//

import UIKit

final class HomeViewController: BaseViewController {

    // MARK: - IBOutlet
    @IBOutlet private weak var categoriesCollectionView: UICollectionView!
    @IBOutlet private weak var contentView: UIView!

    // MARK: - Properties
    private var pageController: UIPageViewController!
    private var viewControllers = [HomeChildViewController]()
    private var viewModel = HomeViewModel()

    private var notificationCenter = NotificationCenter.default

    private var settingSubTabsButtonItem: UIBarButtonItem {
        let settingSubTabsButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(settingSubTabsButtonItemTouchUpInside))
        settingSubTabsButtonItem.tintColor = .purple
        return settingSubTabsButtonItem
    }

    private var searchButtonItem: UIBarButtonItem {
        let searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(goToSearchVCTouchUpInside))
        searchButtonItem.tintColor = .purple
        return searchButtonItem
    }

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        title = "News"
        configCategoriesCollectionView()
        configPageViewController()
        navigationItem.rightBarButtonItems = [settingSubTabsButtonItem, searchButtonItem]

        configObserver()
    }

    override func setupData() {
        super.setupData()
        APIManager.Downloader.configImageDataStorage()
        configData()
    }

    // MARK: - Private funcs
    private func configData() {
        viewModel.configData()
    }

    private func configCategoriesCollectionView() {
        categoriesCollectionView.register(UINib(nibName: Config.categoryCell, bundle: .main), forCellWithReuseIdentifier: Config.categoryCell)
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        configFlowLayout()
    }

    private func configFlowLayout() {
        // auto resize item
        if let flowLayout = categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 10
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 25)
        }
    }

    private func configPageViewController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        addChild(pageController)
        contentView.addSubview(pageController.view)
        pageController.view.frame = contentView.bounds
        configHomeChildViewController()
        pageController.didMove(toParent: self)

        pageController.dataSource = self
        pageController.delegate = self
    }

    private func configHomeChildViewController() {
        var newViewControllers: [HomeChildViewController] = []
        let categories = viewModel.categories
        categories.enumerated().forEach { (index, _) in
            let viewController = HomeChildViewController()
            viewController.delegate = self
            viewController.viewModel = viewModel.getHomeChildViewModel(index: index)
            viewController.view.tag = index
            newViewControllers.append(viewController)
        }
        viewControllers = newViewControllers
        guard viewControllers.count > 0 else { return }
        pageController.setViewControllers([viewControllers[0]], direction: .forward, animated: false)
    }

    private func configObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDataSetting), name: NSNotification.Name.settingCategories, object: nil)
    }

    private func fetchDataHomeChildViewController() {
        viewControllers.enumerated().forEach { (index, viewController) in
            viewController.viewModel = viewModel.getHomeChildViewModel(index: index)
        }
    }

    private func scrollToPageChildViewController() {
        let direction: UIPageViewController.NavigationDirection = viewModel.navigationDirection ? UIPageViewController.NavigationDirection.forward : UIPageViewController.NavigationDirection.reverse
        pageController.setViewControllers([viewControllers[viewModel.currentPage]], direction: direction, animated: true)
    }

    private func scrollToCategory() {
        categoriesCollectionView.scrollToItem(at: IndexPath(row: viewModel.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        for i in 0..<viewModel.categories.count {
            let indexPath = IndexPath(item: i, section: 0)
            if let cell = categoriesCollectionView.cellForItem(at: indexPath) as? CategoryCell {
                cell.viewModel = viewModel.getCategoryCellViewModel(indexPath: indexPath)
            }
        }

        guard viewModel.errors[viewModel.currentPage] != "" else { return }
        let error = viewModel.errors[viewModel.currentPage]
        alert(title: App.String.homeTabBar, msg: error, buttons: ["Ok"], preferButton: "Ok", handler: { _ in
                let currentPage = self.viewModel.currentPage
                let homeChildViewModel = self.viewControllers[currentPage].viewModel
                homeChildViewModel.articles = []
                self.viewControllers[currentPage].viewModel = homeChildViewModel
            })
    }

    @objc private func settingSubTabsButtonItemTouchUpInside() {
        let settingSubTabsViewController = SettingSubTabsViewController()
        nextToViewController(viewcontroller: settingSubTabsViewController)
    }

    @objc private func goToSearchVCTouchUpInside() {
        tabBarController?.selectedIndex = 2
    }

    @objc private func fetchDataSetting() {
        viewModel.configData()
        configHomeChildViewController()
        viewModel.currentPage = 0
        categoriesCollectionView.reloadData()
        categoriesCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .settingCategories, object: nil)
    }
}

// MARK: - CollectionView DataSource, Delegate
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCategories()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let categoryCell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: Config.categoryCell, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        categoryCell.viewModel = viewModel.getCategoryCellViewModel(indexPath: indexPath)
        return categoryCell
    }

    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if viewModel.currentPage != indexPath.row {
            viewModel.currentPage = indexPath.row
            scrollToPageChildViewController()
            scrollToCategory()
        }
    }
}

// MARK: - PageViewController DataSource, Delegate
extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? HomeChildViewController else { return nil }
        let index: Int = viewController.view.tag
        guard index == 0 else {
            let viewController = viewControllers[index - 1]
            return viewController
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? HomeChildViewController else { return nil }
        var index: Int = viewController.view.tag
        index += 1
        guard index == viewModel.categories.count else {
            let viewController = viewControllers[index]
            return viewController
        }
        return nil
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewModel.categories.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished, let vc = pageViewController.viewControllers?.first {
            viewModel.currentPage = vc.view.tag
            scrollToCategory()
        }
    }
}

extension HomeViewController: HomeChildViewControllerDelegate {
    func viewController(_ viewController: HomeChildViewController, needPerform action: HomeChildViewController.Action) {
        switch action {
        case .pullToRefresh(let index, let category):
            guard !viewModel.isLoading[index] else { return }
            viewModel.refreshData(index: index, category: category) { [weak self] (done, message) in
                guard let this = self else { return }
                if done {
                    let articles = this.viewModel.articlesArray[index]
                    let homeChildViewModel = this.viewControllers[index].viewModel
                    homeChildViewModel.articles = articles
                    this.viewControllers[index].viewModel = homeChildViewModel
                } else {
                    this.alert(title: App.String.homeTabBar, msg: message, buttons: ["Ok"], preferButton: "Oke", handler: nil)
                    print("\(this.viewModel.categories[index]): \(message)") // Delete print later
                }
            }
        case .loadMore(let index, let category):
            guard !viewModel.isLoading[index], viewModel.canLoadMore[index] else { return }
            viewModel.loadMoreApi(index: index, category: category) { [weak self] (done, message) in
                guard let this = self else { return }
                if done {
                    let articles = this.viewModel.articlesArray[index]
                    let homeChildViewModel = this.viewControllers[index].viewModel
                    homeChildViewModel.articles = articles
                    this.viewControllers[index].viewModel = homeChildViewModel
                } else {
                    this.alert(title: App.String.homeTabBar, msg: message, buttons: ["Ok"], preferButton: "Oke", handler: nil)
                    print("\(this.viewModel.categories[index]): \(message)") // Delete print later
                }
            }
        case .fetchData(let index, let category):
            viewModel.fecthData(index: index, category: category) { [weak self] (done, message) in
                guard let this = self else { return }
                if done {
                    let articles = this.viewModel.articlesArray[index]
                    let homeChildViewModel = this.viewControllers[index].viewModel
                    homeChildViewModel.articles = articles
                    this.viewControllers[index].viewModel = homeChildViewModel
                } else {
                    this.viewModel.errors[index] = message
                }
            }
        }
    }
}

// MARK: - Config
extension HomeViewController {

    struct Config {
        static let categoryCell = "CategoryCell"
    }
}
