//
//  CNLog.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 20.07.2023.
//

import CloudKit

struct CNLog: Identifiable {
    
    static let kBeverageIcon = "beverageIcon"
    static let kBeverageName = "beverageName"
    static let kBeverageAmount = "beverageAmount"
    static let kCaffeineAmount = "caffeineAmount"
    static let kVolume = "volume"
    static let kDrinkTime = "drinkTime"
    static let kBeverage = "beverage"
    
    let id: CKRecord.ID
    let beverageIcon: String
    let beverageName: String
    let beverageAmount: Double
    let caffeineAmount: Double
    let volume: Double
    let drinkTime: Date
    let beverage: CKRecord.Reference?
    
    init(beverageIcon: String, beverageName: String, beverageAmount: Double, caffeineAmount: Double, volume: Double, drinkTime: Date) {
        self.id = CKRecord.ID(recordName: beverageName)
        self.beverageIcon = beverageIcon
        self.beverageName = beverageName
        self.beverageAmount = beverageAmount
        self.caffeineAmount = caffeineAmount
        self.volume = volume
        self.drinkTime = drinkTime
        self.beverage = nil
    }
    
    init(record: CKRecord) {
        id = record.recordID
        beverageIcon = record[CNLog.kBeverageIcon] as? String ?? "coffee-cup"
        beverageName = record[CNLog.kBeverageName] as? String ?? ""
        beverageAmount = record[CNLog.kBeverageAmount] as? Double ?? 0.0
        caffeineAmount = record[CNLog.kCaffeineAmount] as? Double ?? 0.0
        volume = record[CNLog.kVolume] as? Double ?? 0.0
        drinkTime = record[CNLog.kDrinkTime] as? Date ?? Date()
        beverage = record[CNLog.kBeverage] as? CKRecord.Reference
    }
}
