//
//  Medicine.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 08.03.2023.
//

import Foundation

struct Medicine: Identifiable {
    let id: UUID = UUID()
    var icon: String
    var name: String
    var caffeineContent: Double
}
