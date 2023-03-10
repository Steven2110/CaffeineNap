//
//  Constants.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 09.03.2023.
//

import UIKit

enum ImagePlaceHolder {
    static let avatar = UIImage(named: "default-avatar")!
}

enum NotificationsDay {
    static let days: [DayNotification] = [
        DayNotification(day: "Monday", short: "Mon", letter: "M"),
        DayNotification(day: "Tuesday", short: "Tue", letter: "T"),
        DayNotification(day: "Wednesday", short: "Wed", letter: "W"),
        DayNotification(day: "Thursday", short: "Thu", letter: "T"),
        DayNotification(day: "Friday", short: "Fri", letter: "F"),
        DayNotification(day: "Saturday", short: "Sat", letter: "S"),
        DayNotification(day: "Sunday", short: "Sun", letter: "S")
    ]
}
