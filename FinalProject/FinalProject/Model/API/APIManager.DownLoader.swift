//
//  API.DownLoader.swift
//  FinalProject
//
//  Created by PCI0002 on 1/15/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import UIKit

typealias DictionaryDataImage = [String: Data]

extension APIManager.Downloader {

    static func downloadImage(urlString: String, completion: @escaping
        (UIImage?) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        API.shared().request(url: url, urlSessionConfiguration: URLSessionConfiguration.default) { result in
            switch result {
            case .failure:
                // call back
                completion(nil)
            case .success(let data):
                if let data = data {
                    configSaveImage(urlString, data)
                    let image = UIImage(data: data)
                    completion(image)
                } else {
                    // call back
                    completion(nil)
                }
            }
        }
    }

    static var dataImageKeys = [String]()

    static private func configSaveImage(_ urlString: String, _ data: Data) {
        guard var dataImages = UserDefaults.standard.dictionary(forKey: "dataImages") as? DictionaryDataImage else {
            return
        }
        dataImageKeys.append(urlString)
        dataImages[urlString] = data

        if dataImageKeys.count > 60 {
            dataImages.removeValue(forKey: dataImageKeys[0])
            dataImageKeys.remove(at: 0)
        }

        UserDefaults.standard.set(dataImages, forKey: "dataImages")
    }
}
