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
    @Published var predictedSleepTime: Date = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
    
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
            predictedSleepTime = predictSleepTime(from: logs)
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
    
    private func predictSleepTime(from logs: [CNLog]) -> Date {
        // Un = a * r^(n-1)
        // a – highest caffeine level
        // r – 0.5
        // Un – sleep caffeine threshold
        // log_2(Un/a) = log_2(r^(n-1))
        // log_2(Un/a) = -(n - 1)
        // -log_2(Un/a) = n - 1
        // -log_2(Un/a) + 1 = n
        
        let usualSleepTime = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
        
        guard !logs.isEmpty else { return usualSleepTime }
        
        let (highestCaffeineLevel, latestConsumption) = calculateHighestCaffeineLevelAndTime(from: logs)
        print("Highest: \(highestCaffeineLevel)")
        let n: Double = -1 * log2(100 / highestCaffeineLevel) + 1
        print(n)
        if n < 0 {
            return usualSleepTime
        } else {
            let minute = n * 4 * 60
            
            let calendar = Calendar.current
            let prediction = calendar.date(byAdding: .minute, value: Int(minute), to: latestConsumption)!
            
            return prediction < usualSleepTime ? usualSleepTime : prediction
        }
    }
    
    private func calculateHighestCaffeineLevelAndTime(from logs: [CNLog]) -> (Double, Date) {
        
        let halfLife = 4.0 * 60.0 * 60.0
        var caffeineLevel: Double = 0.0
        
        guard !logs.isEmpty else { return (0.0, Date()) }
        
        let latestConsumptionTime = logs.max(by: { $0.drinkTime < $1.drinkTime })!.drinkTime
        
        let sortedLogs = logs.sorted(by: { $0.drinkTime < $1.drinkTime })
        
        for i in 0..<sortedLogs.count {
            if i == sortedLogs.count - 1 {
                caffeineLevel += sortedLogs[i].caffeineAmount
            } else {
                caffeineLevel += sortedLogs[i].caffeineAmount * (1 - 0.5 * (logs[i + 1].drinkTime - sortedLogs[i].drinkTime) / halfLife)
            }
        }
        
        return (caffeineLevel, latestConsumptionTime)
    }
    
    private func calculateCurrentCaffeineLevel(from logs: [CNLog]) -> Double {
        let halfLife = 4.0 * 60.0 * 60.0 // In seconds
        var level = 0.0
        
        let calendar = Calendar.current
        let sortedLogs = logs
        
        for i in 0..<sortedLogs.count {
            if !calendar.isDateInToday(logs[i].drinkTime) {
                break
            }
            if i == sortedLogs.count - 1 {
                level += sortedLogs[i].caffeineAmount * (1 - 0.5 * (Date.now - sortedLogs[i].drinkTime) / halfLife)
            } else {
                level += sortedLogs[i].caffeineAmount * (1 - 0.5 * (logs[i + 1].drinkTime - sortedLogs[i].drinkTime) / halfLife)
            }
            if level <= 0 {
                return 0.0
            }
        }
        
        return level
    }
}
