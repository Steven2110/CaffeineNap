//
//  DoubleExt.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 25.04.2024.
//

import Foundation

extension Double {
    func round(decimalPlaces: Int) -> Double {
        let multiplier: Double = pow(10.0, Double(decimalPlaces))
        return (self * multiplier).rounded() / multiplier
    }
}
