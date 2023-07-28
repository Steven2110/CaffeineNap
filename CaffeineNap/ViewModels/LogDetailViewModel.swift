//
//  LogDetailViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 24.07.2023.
//

import CloudKit

final class LogDetailViewModel: ObservableObject {
    @Published var log: CNLog
    
    var logRecord: CKRecord?
    
    init(log: CNLog) {
        self.log = log
    }
    
    func updateLog() async {
        do {
            let logRecord = try await CloudKitManager.shared.fetchRecord(from: .privateDB, with: log.id)
            logRecord[CNLog.kBeverageName] = log.beverageName
            logRecord[CNLog.kBeverageIcon] = log.beverageIcon
            logRecord[CNLog.kBeverageAmount] = log.beverageAmount
            logRecord[CNLog.kBeverageSize] = log.beverageSize.rawValue
            logRecord[CNLog.kCaffeineAmount] = log.caffeineAmount
            logRecord[CNLog.kVolume] = log.volume
            logRecord[CNLog.kDrinkTime] = log.drinkTime
            print(logRecord)
            let updatedRecord = try? await CloudKitManager.shared.save(.privateDB, record: logRecord)
            guard updatedRecord != nil else {
                print("ERROR IN UPDATING RECORD")
                return
            }
            print(updatedRecord!)
        } catch {
            print("Error")
            return
        }
    }
    
    func deleteLog() async {
        let deletedRecord = try? await CloudKitManager.shared.deleteRecord(id: log.id)
        
        guard deletedRecord != nil else {
            print("Can't delete record")
            return
        }
        
        print(deletedRecord!)
    }
}
