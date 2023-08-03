//
//  DateExt.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 01.08.2023.
//

import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
