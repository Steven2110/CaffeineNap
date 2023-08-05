//
//  ChartData.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 03.08.2023.
//

import Foundation

struct ChartData: Identifiable {
    let id: UUID = UUID()
    let time: Date
    var caffeineAmount: Double
}
