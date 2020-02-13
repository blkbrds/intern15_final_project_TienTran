//
//  UIImageViewExt.swift
//  FinalProject
//
//  Created by PCI0002 on 1/14/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }

    func loadImageFormURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    #warning("Error: error.localizedDescription")
                } else {
                    if let data = data, let image = UIImage(data: data) {
                        self.image = image
                    }
                }
            }
        }
        dataTask.resume()
    }
}
