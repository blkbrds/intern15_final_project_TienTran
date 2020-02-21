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
    @IBOutlet private weak var placeholdArticlesSearchNewsView: UIView!
    @IBOutlet private weak var messageSearchLabel: UILabel!

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

        configMessageSearch()
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
        resultsSearchController.searchBar.delegate = self
        navigationItem.searchController = resultsSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func configMessageSearch() {
        messageSearchLabel.text = "Search for Articles above"
    }

    private func configFlowLayout() {
        // auto resize item
        if let flowLayout = searchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)

            let width = UIScreen.main.bounds.width
            let itemWidth: CGFloat = width - 20
            let itemHeight: CGFloat = itemWidth * 0.6

            flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }

    private func reloadSearchNewsViewController() {
        if viewModel.isEmmtySearchItems() {
            placeholdArticlesSearchNewsView.isHidden = false
            messageSearchLabel.text = "Sorry, no results found for your\nsearch: \(viewModel.queryString)"
        } else {
            placeholdArticlesSearchNewsView.isHidden = true
        }
        searchCollectionView.reloadData()
    }

    @objc private func searchNews() {
        guard !viewModel.isLoading else { return }
        viewModel.searchNews(page: 1) { [weak self] (done, _) in
            guard let this = self else { return }
            if done {
                this.reloadSearchNewsViewController()
            } else {
                #warning("Show alert")
            }
        }
    }

    private func loadMoreSearchNews() {
        guard !viewModel.isLoading, viewModel.canLoadMore else { return }
        let nextPage = viewModel.currentPage + 1
        viewModel.searchNews(page: nextPage) { [weak self] (done, error) in
            guard let this = self else { return }
            if done {
                this.reloadSearchNewsViewController()
            } else {
                #warning("Show alert/ Delete print later")
                print(error)
            }
        }
    }
}

extension SearchNewsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelSearchNews()
        reloadSearchNewsViewController()
        configMessageSearch()
    }
}

extension SearchNewsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

        if let searchString = searchController.searchBar.text {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchNews), object: nil)
            viewModel.queryString = searchString
            guard viewModel.queryString != viewModel.oldQueryString else { return }
            perform(#selector(searchNews), with: nil, afterDelay: 1.5)
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
        let newsDetail = NewsDetailViewController()
        newsDetail.viewModel = viewModel.getNewsDetailViewModel(at: indexPath)
        nextToViewController(viewcontroller: newsDetail)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !viewModel.searchItems.isEmpty else { return }
        let contentOffsetY = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height
        let scrollViewFrameHeigth = scrollView.frame.height

        if contentOffsetY >= contentSizeHeight - scrollViewFrameHeigth * 1 {
            loadMoreSearchNews()
        }
    }
}

extension SearchNewsViewController: SearchNewsCellDelegate {
    func cell(_ cell: SearchNewsCell, needPerform action: SearchNewsCell.Action) {
        switch action {
        case .loadImage(let indexPath):
            viewModel.loadImage(indexPath: indexPath) { image in
                guard indexPath.row < self.viewModel.searchItems.count else { return }
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
