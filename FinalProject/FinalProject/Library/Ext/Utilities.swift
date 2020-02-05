//
//  BoolExt.swift
//  FinalProject
//
//  Created by TranVanTien on 1/30/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

extension String {

    func matchesRegex(for regex: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            let results = regex.matches(in: self, range: NSRange(location: 0, length: self.count))

            return results.count == 0 ? false : true
        } catch let error {
            print("error regex: \(error.localizedDescription)")
            return false
        }
    }

    func toTimeString() -> String {
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

typealias JSON = [String: Any]

extension Data {
    func toJSON() -> JSON {
        var json: JSON = [:]
        do {
            if let jsonObj = try JSONSerialization.jsonObject(with: self, options: .mutableLeaves) as? JSON {
                json = jsonObj
            }
        } catch {
            print("JSON casting error")
        }
        return json
    }
}

extension Date {
    func toString() -> String {
        let currentDate = Date()
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let epochDate = currentDate.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)

        let difference = timeZoneOffsetDate.timeIntervalSince(self)
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

    static func currentDate() -> Date {
        let currentDate = Date()
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let epochDate = currentDate.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timeZoneOffsetDate
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter
    }()
}
