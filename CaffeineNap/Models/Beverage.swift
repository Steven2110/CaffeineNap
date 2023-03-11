//
//  Beverage.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 08.03.2023.
//

import Foundation

enum VolumeType {
    case single, double, triple, small, medium, large
}

struct Beverage: Identifiable {
    let id: UUID = UUID()
    var icon: String
    var name: String
    var base: Base
    var type: [DrinkType]
    var volumeAndCaffeineAmount: [VolumeCaffeineAmount]
//    var caffeineAmount: [CaffeineAmount]
    var caffeinePer100: Double?
    
    enum DrinkType {
        case iced, hot
    }
    
    enum Base {
        case coffee, tea, soda, energyDrink
    }
}

struct VolumeCaffeineAmount: Identifiable {
    let id: UUID = UUID()
    var type: VolumeType
    var volume: Double
    var amount: Double
}

//struct CaffeineAmount: Identifiable {
//    let id: UUID = UUID()
//    var type: VolumeType
//    var amount: Double
//}
