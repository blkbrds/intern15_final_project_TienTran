//
//  SearchNewsViewController.swift
//  FinalProject
//
//  Created by TranVanTien on 2/13/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

final class SearchNewsViewController: BaseViewController {

    @IBOutlet private weak var searchCollectionView: UICollectionView!

    var viewModel = SearchNewsViewModel()

    private var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        controller.searchBar.placeholder = "Search Anything..."
        controller.searchBar.searchBarStyle = .default
        controller.searchBar.tintColor = .black
        controller.searchBar.sizeToFit()
        return controller
    }()

    override func setupUI() {
        super.setupUI()
        title = "Search News"
        configSearch()
        configCollectionView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultsSearchController.delegate = nil
        resultsSearchController.searchBar.delegate = nil
    }

    private func configCollectionView() {
        searchCollectionView.register(UINib(nibName: Config.searchNewsCell, bundle: .main), forCellWithReuseIdentifier: Config.searchNewsCell)
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        configFlowLayout()
    }

    private func configSearch() {
        resultsSearchController.searchResultsUpdater = self
        navigationItem.searchController = resultsSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func configFlowLayout() {
        // auto resize item
        if let flowLayout = searchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)

            let width = UIScreen.main.bounds.width
            let itemWidth: CGFloat = width - 20
            let itemHeight: CGFloat = itemWidth * 0.7

            flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }

    @objc private func searchNewsApi() {
        viewModel.searchNews { (done, _) in
            if done {
                self.searchCollectionView.reloadData()
            } else {
                #warning("Show alert")
            }
        }
    }
}

extension SearchNewsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

        if let searchString = searchController.searchBar.text {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchNewsApi), object: searchString)
            self.perform(#selector(searchNewsApi), with: self, afterDelay: 1.5)
            viewModel.queryString = searchString
            #warning("Delete print later")
            print(searchString)
        }
    }
}

extension SearchNewsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfListNews()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchNewsCell", for: indexPath) as? SearchNewsCell else { return UICollectionViewCell() }
        newsCell.delegate = self
        newsCell.viewModel = viewModel.getSearchNewsCellViewModel(at: indexPath)
        return newsCell
    }
}

extension SearchNewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        #warning("Forward")
    }
}

extension SearchNewsViewController: SearchNewsCellDelegate {
    func cell(_ cell: SearchNewsCell, needPerform action: SearchNewsCell.Action) {
        switch action {
        case .loadImage(let indexPath):
            viewModel.loadImage(indexPath: indexPath) { image in
                if image != nil {
                    self.searchCollectionView.reloadItems(at: [indexPath])
                }
            }
        }
    }
}

// MARK: - Config
extension SearchNewsViewController {

    struct Config {
        static let searchNewsCell = "SearchNewsCell"
    }
}
