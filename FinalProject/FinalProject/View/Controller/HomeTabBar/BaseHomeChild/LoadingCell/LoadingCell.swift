//
//  LoadingCell.swift
//  FinalProject
//
//  Created by PCI0002 on 1/30/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import UIKit

final class LoadingCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
        activityIndicator.color = UIColor.black
    }
}
