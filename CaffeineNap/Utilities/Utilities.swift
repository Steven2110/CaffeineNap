//
//  Utilities.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 13.06.2023.
//

import Foundation

func getImageSize(for size: VolumeType) -> Double {
    switch size {
    case .single:
        return 30.0
    case .double:
        return 45.0
    case .triple:
        return 60.0
    case .small:
        return 30.0
    case .medium:
        return 45.0
    case .large:
        return 60.0
    case .unknown:
        return 30.0
    }
}

func predictNext30MinutesCaffeineLevel(currentCaffeineLevel: Double) -> Double {
    return currentCaffeineLevel * (1 - 0.5 * (30.0 / 240.0))
}

func hasFractionalPart(_ number: Double) -> Bool {
    // Compare the original number with its rounded version
    return number != Double(Int(number))
}

func romanNumeral(for number: Int) -> String {
    guard number > 0 else { return "Invalid" }
    
    let romanNumerals: [(Int, String)] = [
        (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
        (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
        (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")
    ]
    
    var result = ""
    var remainder = number
    
    for (value, symbol) in romanNumerals {
        let quotient = remainder / value
        
        if quotient > 0 {
            result += String(repeating: symbol, count: quotient)
            remainder %= value
        }
    }
    
    return result
}
