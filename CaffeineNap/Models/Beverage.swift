//
//  Beverage.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 08.03.2023.
//

import Foundation

struct Beverage: Identifiable {
    let id: UUID = UUID()
    var icon: String
    var name: String
    var base: Base
    var type: [DrinkType]
    var volume: [VolumeType: Double]
    var caffeineAmount: [VolumeType: Double]
    var caffeinePer100: Double?
    
    enum VolumeType {
        case single, double, triple, small, medium, large
    }
    
    enum DrinkType {
        case iced, hot
    }
    
    enum Base {
        case coffee, tea, soda, energyDrink
    }
}

