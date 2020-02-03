//
//  API.DownLoader.swift
//  FinalProject
//
//  Created by PCI0002 on 1/15/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import UIKit

extension APIManager.Downloader {

    static func downloadImage(urlString: String, completion: @escaping
        (UIImage?) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        API.shared().request(url: url, urlSessionConfiguration: URLSessionConfiguration.ephemeral) { result in
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

    static var imageDataKeys = [String]()
    static private func configSaveImage(_ urlString: String, _ data: Data) {
        UserDefaults.standard.set(data, forKey: urlString)

        imageDataKeys.append(urlString)

        if imageDataKeys.count > 30 {
            UserDefaults.standard.removeObject(forKey: imageDataKeys[0])
            imageDataKeys.remove(at: 0)
        }
    }
}
