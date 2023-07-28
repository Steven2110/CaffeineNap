//
//  CNBeverage.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 08.03.2023.
//

import CloudKit

struct CNBeverage: Identifiable {

    static let kName = "name"
    static let kIcon = "icon"
    static let kBase = "base"
    static let kType = "type"
    static let kCaffeinePer100 = "caffeinePer100"
    static let kVolumeAndCaffeineAmount = "volumeAndCaffeineAmount"
    static let kMinCaffeine = "minCaffeine"
    static let kMaxCaffeine = "maxCaffeine"
    static let kIsCustom = "isCustom"

    let id: CKRecord.ID
    var icon: String
    var name: String
    var base: Base
    var type: [DrinkType]
    var volumeAndCaffeineAmount: [VolumeCaffeineAmount]
    var caffeinePer100: Double?
    let minCaffeine: Int
    let maxCaffeine: Int
    let isCustom: Bool
    
    let volumeAndCaffeineAmountReference: [CKRecord.Reference]?
    
    enum DrinkType: String, Codable, CaseIterable {
        case iced, hot, unknown
        
        static func from(_ str: String) -> DrinkType {
            if str == "iced" {
                return .iced
            } else if str == "hot" {
                return .hot
            } else {
                return .unknown
            }
        }
    }
    
    enum Base: String, Codable, CaseIterable {
        case coffee, tea, soda, energyDrink, unknown
        
        static func from(_ str: String) -> Base {
            if str == "coffee" {
                return .coffee
            } else if str == "tea" {
                return .tea
            } else if str == "soda" {
                return .soda
            } else if str == "energyDrink" {
                return .energyDrink
            } else {
                return .unknown
            }
        }
    }
    
    
    init(icon: String, name: String, base: Base, type: [DrinkType], volumeAndCaffeineAmount: [VolumeCaffeineAmount], caffeinePer100: Double? = nil) {
        self.id = CKRecord.ID(recordName: name)
        self.icon = icon
        self.name = name
        self.base = base
        self.type = type
        self.volumeAndCaffeineAmount = volumeAndCaffeineAmount
        self.caffeinePer100 = caffeinePer100
        self.minCaffeine = Int(volumeAndCaffeineAmount.min { $0.amount < $1.amount }!.amount)
        self.maxCaffeine = Int(volumeAndCaffeineAmount.max { $0.amount < $1.amount }!.amount)
        self.volumeAndCaffeineAmountReference = nil
        self.isCustom = false
    }
    
    init(record: CKRecord) {
        id = record.recordID
        name = record[CNBeverage.kName] as? String ?? "N/A"
        icon = record[CNBeverage.kIcon] as? String ?? "N/A"
        base = Base.from(record[CNBeverage.kBase] as? String ?? "N/A")
        type = (record[CNBeverage.kType] as? [String] ?? [""]).map { DrinkType.from($0) }
        caffeinePer100 = record[CNBeverage.kCaffeinePer100] as? Double ?? 0.0
        minCaffeine = record[CNBeverage.kMinCaffeine] as? Int ?? 0
        maxCaffeine = record[CNBeverage.kMaxCaffeine] as? Int ?? 0
        volumeAndCaffeineAmountReference = record[CNBeverage.kVolumeAndCaffeineAmount] as? [CKRecord.Reference]
        volumeAndCaffeineAmount = []
        isCustom = ((record[CNBeverage.kIsCustom] as? Int ?? 0) != 0)
    }
}

enum VolumeType: String, CaseIterable, CustomStringConvertible, Identifiable {
    case single, double, triple, small, medium, large, unknown
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .single:
            return "Single"
        case .double:
            return "Double"
        case .triple:
            return "Triple"
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .unknown:
            return "Unknown"
        }
    }
    
    static func from(_ str: String) -> VolumeType {
        if str == "single" {
            return .single
        } else if str == "double" {
            return .double
        } else if str == "triple" {
            return .triple
        } else if str == "small" {
            return .small
        } else if str == "medium" {
            return .medium
        } else if str == "large" {
            return .large
        } else {
            return .unknown
        }
    }
}

struct VolumeCaffeineAmount: Identifiable {
    
    static let kType = "type"
    static let kVolume = "volume"
    static let kAmount = "amount"
    static let kBeverage = "beverage"
    
    var id: CKRecord.ID
    var type: VolumeType
    var volume: Double
    var amount: Double
    var beverage: CKRecord.Reference
                        
    init(type: VolumeType, volume: Double, amount: Double) {
        self.id = CKRecord.ID(recordName: String(describing: type))
        self.type = type
        self.volume = volume
        self.amount = amount
        beverage = CKRecord.Reference(recordID: CKRecord.ID(recordName: String(describing: type)), action: .deleteSelf)
    }
    
    init(record: CKRecord) {
        id = record.recordID
        type = VolumeType.from(record[VolumeCaffeineAmount.kType] as? String ?? "N/A")
        volume = record[VolumeCaffeineAmount.kVolume] as? Double ?? 0.0
        amount = record[VolumeCaffeineAmount.kAmount] as? Double ?? 0.0
        beverage = (record[VolumeCaffeineAmount.kBeverage] as? CKRecord.Reference)!
    }
}
