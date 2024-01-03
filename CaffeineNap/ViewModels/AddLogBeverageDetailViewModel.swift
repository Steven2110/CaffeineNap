//
//  AddLogBeverageDetailViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 20.07.2023.
//

import CloudKit

final class AddLogBeverageDetailViewModel: ObservableObject {
    
    var beverage: CNBeverage
    @Published var volumeCaffeineAmounts: [VolumeCaffeineAmount] = []
    
    @Published var selectedVolume: VolumeCaffeineAmount?
    @Published var amount: Double = 1
    @Published var timeDrink: Date = Date.now
    
    @Published var isLoading: Bool = false
    
    @Published var specifier: String = "%.0f"
    
    init(beverage: CNBeverage) {
        self.beverage = beverage
    }
    
    func incrementAmount() {
        DispatchQueue.main.async { [self] in
            if amount == 1 {
                amount += 0.5
                specifier = "%.1f"
            } else if amount == 1.5 {
                amount += 0.5
                specifier = "%.0f"
            } else if amount == 0.5 {
                amount += 0.5
                specifier = "%.0f"
            } else { amount += 1}
        }
    }
    
    func decrementAmount() {
        DispatchQueue.main.async { [self] in
            if amount == 2 {
                amount -= 0.5
                specifier = "%.1f"
            } else if amount == 1.5 {
                amount -= 0.5
                specifier = "%.0f"
            } else if amount == 1 {
                amount -= 0.5
                specifier = "%.1f"
            } else if amount == 0.5 { /* do nothing */ } else {
                amount -= 1
            }
        }
    }
    
    @MainActor
    func fetchVolumeCaffeine() async {
        showLoadingView()
        print("GETTING")
        do {
            let dbLocation: DatabaseType = beverage.isCustom ? .privateDB : .publicDB
            volumeCaffeineAmounts = try await CloudKitManager.shared.fetchVolumeCaffeineAmounts(dbLocation, for: beverage.id)
            hideLoadingView()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func addLog(to logManager: CNLogManager) async {
        
        let logRecord: CKRecord = CKRecord(recordType: RecordType.log)
        logRecord[CNLog.kBeverageName] = beverage.name
        logRecord[CNLog.kBeverageIcon] = beverage.icon
        logRecord[CNLog.kBeverageAmount] = amount
        logRecord[CNLog.kBeverageSize] = selectedVolume!.type.rawValue
        logRecord[CNLog.kCaffeineAmount] = selectedVolume!.amount * Double(amount)
        logRecord[CNLog.kVolume] = selectedVolume!.volume * Double(amount)
        logRecord[CNLog.kDrinkTime] = timeDrink
        
        do {
            let record = try await CloudKitManager.shared.save(record: logRecord)
            print("Record saved: \(record)")
            logManager.addLog(record: record)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
    }
    
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
