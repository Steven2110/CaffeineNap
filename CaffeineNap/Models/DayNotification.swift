//
//  DayNotification.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 10.03.2023.
//

import Foundation

struct DayNotification: Identifiable, Equatable {
    let id: UUID = UUID()
    var day: String
    var short: String
    var letter: String
}
