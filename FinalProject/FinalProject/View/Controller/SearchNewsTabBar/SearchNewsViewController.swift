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

    private var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        controller.searchBar.placeholder = "Search Anything..."
        controller.searchBar.searchBarStyle = .prominent
        controller.searchBar.tintColor = .black
        controller.searchBar.sizeToFit()
        return controller
    }()

    var viewModel = SearchNewsViewModel()

    override func setupUI() {
        super.setupUI()
        title = "Search News"
        configSearch()
        configCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !resultsSearchController.isActive else { return }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.resultsSearchController.searchBar.becomeFirstResponder()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultsSearchController.delegate = nil
        resultsSearchController.searchBar.delegate = nil
    }

    private func configCollectionView() {
        searchCollectionView.register(UINib(nibName: "SearchNewsCell", bundle: .main), forCellWithReuseIdentifier: "SearchNewsCell")
        searchCollectionView.dataSource = self
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
            flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 0, right: 5)

            let width = searchCollectionView.bounds.width
            let itemWidth: CGFloat = width - 10
            let itemHeight: CGFloat = itemWidth * 1.5

            flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }

    func loadNews(with query: String) {
        viewModel.searchNews(query: query) { (done, error) in
            if done {
                self.searchCollectionView.reloadSections([0])
            } else {
                print("API Error: \(error)")
            }
        }
    }

    deinit {
        self.searchCollectionView.delegate = nil
        self.searchCollectionView.dataSource = nil
    }
}

extension SearchNewsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchItems.removeAll(keepingCapacity: false)

        if let searchString = searchController.searchBar.text, searchString.count > 3 {
            loadNews(with: searchString)
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
