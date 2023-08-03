//
//  MainInfoViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 01.08.2023.
//

import SwiftUI

class MainInfoViewModel: ObservableObject {
    
    @Published var currentCaffeineAmount: Double = 0.0
    @Published var maxCaffeineAmount: Double = 500.0
    @Published var totalTodayCaffeine: Double = 0.0
    
    @Published var alertness: Alertness = .low
    
    @Published var beverageCupAmount = 0.0
    @Published var cupAmountSpecifier = "%.0f"
    private var caffeineThreshold: Double = 100.0
    var beverageAmountMeasurementUnit: String {
        if beverageCupAmount > 1 {
            return " cups"
        }
        return " cup"
    }
    
    enum Alertness: CustomStringConvertible {
        case low, medium, high
        
        var description: String {
            switch self {
            case .low:
                return "Low"
            case .medium:
                return "Medium"
            case .high:
                return "High"
            }
        }
    }
    
    func updateInfo(from logs: [CNLog]) {
        let totalCaffeineLogs = logs.map( { $0.caffeineAmount } )
        let totalCup = logs.map( {$0.beverageAmount} )
        
        withAnimation(.easeIn) {
            totalTodayCaffeine = totalCaffeineLogs.reduce(0, +)
            beverageCupAmount = totalCup.reduce(0, +)
            if floor(beverageCupAmount) != beverageCupAmount { cupAmountSpecifier = "%.1f" }
        }
        
        withAnimation(.easeIn(duration: 1.0)) {
            currentCaffeineAmount = calculateCurrentCaffeineLevel(from: logs)
            alertness = getAlertness(of: currentCaffeineAmount)
            // TODO: Calculate prediction for sleep time
        }
    }
    
    private func getAlertness(of level: Double) -> Alertness {
        // - Low: x <= 1/3 Max
        // - Medium: 1/3 Max < x <= 2/3 Max
        // - High: x > 2/3 Max
        if currentCaffeineAmount <= maxCaffeineAmount / 3 {
            return .low
        } else if currentCaffeineAmount > maxCaffeineAmount / 3 && currentCaffeineAmount <= 2 * maxCaffeineAmount / 3 {
            return .medium
        } else {
            return .high
        }
    }
    
    private func calculateCurrentCaffeineLevel(from logs: [CNLog]) -> Double {
        let halfLife = 4.0 * 60.0 * 60.0 // In seconds
        var level = 0.0
        
        let calendar = Calendar.current
        
        for i in 0..<logs.count {
            if !calendar.isDateInToday(logs[i].drinkTime) {
                break
            }
            if i == logs.count - 1 {
                level += logs[i].caffeineAmount * (1 - 0.5 * (Date.now - logs[i].drinkTime) / halfLife)
            } else {
                level += logs[i].caffeineAmount * (1 - 0.5 * (logs[i + 1].drinkTime - logs[i].drinkTime) / halfLife)
            }
            if level <= 0 {
                return 0.0
            }
        }
        
        return level
    }
}
