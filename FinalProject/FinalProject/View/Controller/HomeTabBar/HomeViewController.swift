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

    // MARK: - Properties
    private var pageController: UIPageViewController!
    private var viewControllers = [BaseHomeChildViewController]()
    private var viewModel = HomeViewModel()

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        title = "Headlines"
        configCategoriesCollectionView()
    }

    // MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configPageViewController()
        //        configCustomView() #warning("if many time ---- scroll view color")
    }

    // MARK: - Private funcs
    private func configCategoriesCollectionView() {
        categoriesCollectionView.register(UINib(nibName: Config.categoryCell, bundle: .main), forCellWithReuseIdentifier: Config.categoryCell)
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        // auto resize item
        if let flowLayout = categoriesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            flowLayout.estimatedItemSize = CGSize(width: 1, height: 1)
        }
    }

    private func configPageViewController() {
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        let widthScreen = UIScreen.main.bounds.width
        let heightScreen = UIScreen.main.bounds.height
        let yCategories = categoriesCollectionView.frame.maxY
        let heightCategories = categoriesCollectionView.frame.height

        pageController.view.frame = CGRect(x: 0, y: yCategories, width: widthScreen, height: heightScreen - heightCategories)
        addChild(pageController)
        view.addSubview(pageController.view)

        addChildViewController()

        pageController.setViewControllers([viewControllers[0]], direction: .forward, animated: false)
        pageController.didMove(toParent: self)

        pageController.dataSource = self
        pageController.delegate = self
    }

    private func addChildViewController() {
        for (index, type) in HomeScreenType.allCases.enumerated() {
            let viewController = BaseHomeChildViewController()
            viewController.viewModel.screenType = type
            viewController.view.tag = index
            viewControllers.append(viewController)
        }
    }

    private func scrollToPageChildViewController(at selectedIndex: Int) {
        scrollToCategory(at: selectedIndex)
        #warning("delete")
//        print("selectedIndex \(viewModel.selectedIndex)")
//        print("currentIndex \(viewModel.currentIndex)")
        let direction: UIPageViewController.NavigationDirection = (selectedIndex < viewModel.currentIndex) ? UIPageViewController.NavigationDirection.forward : UIPageViewController.NavigationDirection.reverse
        pageController.setViewControllers([viewControllers[selectedIndex]], direction: direction, animated: true)
    }

    private func scrollToCategory(at selectedIndex: Int) {
        categoriesCollectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
        viewModel.selectedIndex = selectedIndex
        for i in 0..<viewModel.categories.count {
            let indexPath = IndexPath(item: i, section: 0)
            if let cell = categoriesCollectionView.cellForItem(at: indexPath) as? CategoryCell {
                cell.viewModel = viewModel.getCategoryCellViewModel(indexPath: indexPath)
            }
        }
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
        viewModel.selectedIndex = indexPath.row
        scrollToPageChildViewController(at: viewModel.selectedIndex)
    }
}

// MARK: - PageViewController DataSource, Delegate
extension HomeViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? BaseHomeChildViewController else { return nil }
        let index: Int = viewController.view.tag
        guard index == 0 else {
            let viewController = viewControllers[index - 1]
            return viewController
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? BaseHomeChildViewController else { return nil }
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
            viewModel.currentIndex = vc.view.tag
            scrollToCategory(at: vc.view.tag)
        }
    }
}

// MARK: - Config
extension HomeViewController {

    struct Config {
        static let categoryCell = "CategoryCell"
    }
}
