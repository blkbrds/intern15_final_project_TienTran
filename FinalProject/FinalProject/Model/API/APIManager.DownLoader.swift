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

    static func downloadImage(urlString: String, completion: @escaping APICompletion<UIImage?>) {

        API.shared().request(urlString: urlString) { result in
            switch result {
            case .failure(let error):
                // call back
                completion(.failure(error))
            case .success(let data):
                if let data = data {
                    // result
                    let image = UIImage(data: data)
                    // call back
                    completion(.success(image))
                    print(image)
                } else {
                    // call back
                    completion(.failure(.error("Data is not format")))
                }
            }
        }
    }
}
