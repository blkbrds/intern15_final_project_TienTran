//
//  BoolExt.swift
//  FinalProject
//
//  Created by TranVanTien on 1/30/20.
//  Copyright © 2020 TranVanTien. All rights reserved.
//

import Foundation

extension Date {
    func toString() -> String {
        let difference = Date.currentDate().timeIntervalSince(self)
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

    func relativelyFormatted(short: Bool) -> String {
        let now = Date.currentDate()
        let components = Calendar.autoupdatingCurrent.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute, .second],
            from: self,
            to: now)

        if let years = components.year, years > 0 {
            return short ? "\(years)y" : "\(years) year\(years == 1 ? "" : "s") ago"
        }

        if let months = components.month, months > 0 {
            return short ? "\(months)mo" : "\(months) month\(months == 1 ? "" : "s") ago"
        }

        if let weeks = components.weekOfYear, weeks > 0 {
            return short ? "\(weeks)w" : "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        }
        if let days = components.day, days > 0 {
            guard days > 1 else { return short ? "  y'day" : "yesterday" }

            return short ? "\(days)d" : "\(days) day\(days == 1 ? "" : "s") ago"
        }

        if let hours = components.hour, hours > 0 {
            return short ? "\(hours)h" : "\(hours) hour\(hours == 1 ? "" : "s") ago"
        }

        if let minutes = components.minute, minutes > 0 {
            return short ? "\(minutes) min" : "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        }

        if let seconds = components.second, seconds > 30 {
            return short ? "\(seconds)s" : "\(seconds) second\(seconds == 1 ? "" : "s") ago"
        }

        return "Just now"
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
