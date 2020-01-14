//
//  String.Ext.swift
//  FinalProject
//
//  Created by PCI0002 on 1/14/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

extension String {
    func toTime() -> String {
        let dateStringT = self.replacingOccurrences(of: "T", with: " ")
        let dateStringZ = dateStringT.replacingOccurrences(of: "Z", with: "")
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let previousDateFormated: Date? = dateFormatter.date(from: dateStringZ)
        let difference = currentDate.timeIntervalSince(previousDateFormated!)
        let differenceInDays = Int(difference / (60 * 60 * 24))
        let differenceInHour = Int(difference / (60 * 60))
        let differenceInMinute = Int(difference / 60)
        if differenceInMinute < 60 {
            return "\(differenceInMinute) minutes ago"
        } else if differenceInHour < 24 {
            return "\(differenceInHour) hours ago"
        } else {
            return "\(differenceInDays) day ago"
        }
    }
}
