//
//  UIViewController.swift
//  FinalProject
//
//  Created by TranVanTien on 2/24/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

extension UIViewController {

    func alert(title: String? = nil, msg: String, buttons: [String] = ["OK"], preferButton: String = "", handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        for button in buttons {
            // Bold button title
            if !preferButton.isEmpty && preferButton == button {
                let action = UIAlertAction(title: button, style: .default, handler: { action in
                    handler?(action)
                })
                alert.addAction(action)
                alert.preferredAction = action
            } else {
                let action = UIAlertAction(title: button, style: .default, handler: nil)
                alert.addAction(action)
            }
        }

        present(alert, animated: true, completion: nil)
    }
}
