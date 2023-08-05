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
