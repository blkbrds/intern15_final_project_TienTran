//
//  NewsDetailViewController.swift
//  BaiTapTongHop
//
//  Created by PCI0002 on 12/30/19.
//  Copyright © 2019 TranVanTien. All rights reserved.
//

import UIKit
import SafariServices

final class NewsDetailViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var contentNewsLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!

    // MARK: - Propertites
    var viewModel = NewsDetailViewModel()
    private var bookMarksBarButtonItem: UIBarButtonItem {
        let bookMarksBarButtonItem = UIBarButtonItem(image: UIImage(systemName: viewModel.favoritesImageString), style: .plain, target: self, action: #selector(changeBookMarkButtonTouchUpInside))
        bookMarksBarButtonItem.tintColor = .purple
        return bookMarksBarButtonItem
    }

    // MARK: - config
    override func setupUI() {
        super.setupUI()
        configUI()
        addBookMarksBarButtonItem()
    }

    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Private funcs
    private func configUI() {
        navigationItem.title = ""
        title = viewModel.news?.source?.name

        readMoreButton.clipsToBounds = true
        readMoreButton.layer.cornerRadius = 5

        guard let news = viewModel.news else { return }

        newsTitleLabel.text = news.titleNews
        authorLabel.text = news.author
        contentNewsLabel.text = news.content

        if let publishedAt = news.publishedAt {
            readMoreButton.setTitle("\(publishedAt.relativelyFormatted(short: false)) • Read More...", for: .normal)
        } else {
            readMoreButton.setTitle("Read More...", for: .normal)
        }

        newsImageView.image = #imageLiteral(resourceName: "news-default")
        if let dataImages = UserDefaults.standard.dictionary(forKey: "dataImages") as? DictionaryDataImage,
            let dataImage = dataImages[news.urlImage ?? ""] {
            self.newsImageView.image = UIImage(data: dataImage)
        } else {
            viewModel.loadImage { (image) in
                if let image = image {
                    self.newsImageView.image = image
                }
            }
        }
    }

    private func addBookMarksBarButtonItem() {
        navigationItem.rightBarButtonItem = bookMarksBarButtonItem
    }

    private func changeStatusBookMarkButton() {
        bookMarksBarButtonItem.image = UIImage(systemName: viewModel.favoritesImageString)
        navigationItem.rightBarButtonItem = bookMarksBarButtonItem
    }

    @objc private func changeBookMarkButtonTouchUpInside() {
        if viewModel.isFavorited {
            viewModel.removeNewsInFavorites { [weak self] (done, message) in
                guard let this = self else { return }
                if done {
                    this.changeStatusBookMarkButton()
                } else {
                    this.alert(title: "News Detail", msg: message, buttons: ["Ok"], preferButton: "Ok", handler: nil)
                }
            }
        } else {
            viewModel.addNewsInFavorites { [weak self] (done, message) in
                guard let this = self else { return }
                if done {
                    this.changeStatusBookMarkButton()
                } else {
                    this.alert(title: "News Detail", msg: message, buttons: ["Ok"], preferButton: "Ok", handler: nil)
                }
            }
        }
    }

    private func openInSafari() {
        guard let news = viewModel.news else { return }

        if let url = URL(string: news.urlNews ?? "https://www.apple.com") {
            let sfSafariVC = SFSafariViewController(url: url)
            sfSafariVC.delegate = self
            sfSafariVC.preferredControlTintColor = .purple
            sfSafariVC.modalPresentationStyle = .formSheet
            present(sfSafariVC, animated: true)
        }
    }

    @IBAction private func readMoreButtonTouchUpInside(_ sender: UIButton) {
        openInSafari()
    }
}

extension NewsDetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }

    func safariViewController(_ controller: SFSafariViewController, excludedActivityTypesFor URL: URL, title: String?) -> [UIActivity.ActivityType] {
        return [.copyToPasteboard]
    }
}
