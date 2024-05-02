//
//  CNLog.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 20.07.2023.
//

import CloudKit

struct CNLog: Identifiable, Equatable {
    
    static let kBeverageIcon = "beverageIcon"
    static let kBeverageName = "beverageName"
    static let kBeverageAmount = "beverageAmount"
    static let kBeverageSize = "beverageSize"
    static let kCaffeineAmount = "caffeineAmount"
    static let kVolume = "volume"
    static let kDrinkTime = "drinkTime"
    static let kBeverage = "beverage"
    
    let id: CKRecord.ID
    var beverageIcon: String
    var beverageName: String
    var beverageAmount: Double
    var beverageSize: VolumeType
    var caffeineAmount: Double
    var volume: Double
    var drinkTime: Date
//    var beverage: CKRecord.Reference?
    
    init(beverageIcon: String, beverageName: String, beverageAmount: Double, beverageSize: VolumeType, caffeineAmount: Double, volume: Double, drinkTime: Date) {
        self.id = CKRecord.ID(recordName: beverageName)
        self.beverageIcon = beverageIcon
        self.beverageName = beverageName
        self.beverageAmount = beverageAmount
        self.beverageSize = beverageSize
        self.caffeineAmount = caffeineAmount
        self.volume = volume
        self.drinkTime = drinkTime
//        self.beverage = nil
    }
    
    init(record: CKRecord) {
        id = record.recordID
        beverageIcon = record[CNLog.kBeverageIcon] as? String ?? "coffee-cup"
        beverageName = record[CNLog.kBeverageName] as? String ?? ""
        beverageAmount = record[CNLog.kBeverageAmount] as? Double ?? 0.0
        beverageSize = VolumeType.from(record[CNLog.kBeverageSize] as? String ?? "unknown")
        caffeineAmount = record[CNLog.kCaffeineAmount] as? Double ?? 0.0
        volume = record[CNLog.kVolume] as? Double ?? 0.0
        drinkTime = record[CNLog.kDrinkTime] as? Date ?? Date()
//        beverage = record[CNLog.kBeverage] as? CKRecord.Reference
    }
}
