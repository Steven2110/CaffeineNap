//
//  AddLogBeverageViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 20.07.2023.
//

import CloudKit

final class AddLogBeverageViewModel: ObservableObject {
    
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
            } else if amount == 1 { } else {
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
    
    func addLog() async {
        showLoadingView()
        
        let logRecord: CKRecord = CKRecord(recordType: RecordType.log)
        logRecord[CNLog.kBeverageName] = beverage.name
        logRecord[CNLog.kBeverageAmount] = amount
        logRecord[CNLog.kCaffeineAmount] = selectedVolume!.amount * Double(amount)
        logRecord[CNLog.kVolume] = selectedVolume!.volume * Double(amount)
        logRecord[CNLog.kDrinkTime] = timeDrink
        let database: DatabaseType = beverage.isCustom ? .privateDB : .publicDB
        do {
            let beverageRecord = try await CloudKitManager.shared.fetchRecord(from: database, with: beverage.id)
            print(beverageRecord)
            logRecord[CNLog.kBeverage] = CKRecord.Reference(record: beverageRecord, action: .none)
        } catch {
            print("Error fetchign beverage record")
        }
        
        do {
            let record = try await CloudKitManager.shared.save(record: logRecord)
            print("Record saved: \(record)")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        hideLoadingView()
    }
    
    private func showLoadingView() { DispatchQueue.main.async { self.isLoading = true } }
    private func hideLoadingView() { DispatchQueue.main.async { self.isLoading = false } }
}
