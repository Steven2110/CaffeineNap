//
//  MockData.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 08.03.2023.
//

import Foundation

struct MockData {
    static let customDrinks: [Beverage] = [Beverage]()
    static let coffee: [Beverage] = [
        Beverage(
            icon: "espresso-cup",
            name: "Espresso",
            base: .coffee,
            type: [.hot],
            volume: [
                .single: 30.0,
                .double: 60.0,
                .triple: 90.0
            ],
            caffeineAmount: [
                .single: 63.6,
                .double: 127.2,
                .triple: 190.8
            ],
            caffeinePer100: 212
        ),
        Beverage(
            icon: "coffee-cup",
            name: "Americano",
            base: .coffee,
            type: [.hot],
            volume: [
                .small: 150.0,
                .medium: 200.0,
                .large: 350.0
            ],
            caffeineAmount: [
                .small: 64.8,
                .medium: 86.4,
                .large: 152.25
            ],
            caffeinePer100: 43.2
        ),
        Beverage(
            icon: "coffee-cup",
            name: "Long Black",
            base: .coffee,
            type: [.hot],
            volume: [
                .small: 150.0,
                .medium: 200.0,
                .large: 350.0
            ],
            caffeineAmount: [
                .small: 64.8,
                .medium: 86.4,
                .large: 152.25
            ],
            caffeinePer100: 43.2
        ),
        Beverage(
            icon: "coffee-cup",
            name: "Black Coffee",
            base: .coffee,
            type: [.hot],
            volume: [
                .small: 150.0,
                .medium: 200.0,
                .large: 350.0
            ],
            caffeineAmount: [
                .small: 64.8,
                .medium: 86.4,
                .large: 152.25
            ],
            caffeinePer100: 43.2
        ),
        Beverage(
            icon: "takeaway-cup",
            name: "Cold Brew",
            base: .coffee,
            type: [.iced],
            volume: [
                .small: 250.0,
                .medium: 300.0,
                .large: 450.0
            ],
            caffeineAmount: [
                .small: 137.722,
                .medium: 165.266,
                .large: 247.899
            ],
            caffeinePer100: 55.0887
        ),
        Beverage(
            icon: "takeaway-cup",
            name: "Latte",
            base: .coffee,
            type: [.hot, .iced],
            volume: [
                .small: 250.0,
                .medium: 300.0,
                .large: 450.0
            ],
            caffeineAmount: [
                .small: 81.33,
                .medium: 97.6,
                .large: 146.4
            ],
            caffeinePer100: 32.533
        ),
        Beverage(
            icon: "coffee-cup",
            name: "Cappuccino",
            base: .coffee,
            type: [.hot, .iced],
            volume: [
                .small: 250.0,
                .medium: 300.0,
                .large: 450.0
            ],
            caffeineAmount: [
                .small: 108.333,
                .medium: 130,
                .large: 195
            ],
            caffeinePer100: 43.333
        )
    ]
    
    static let tea: [Beverage] = [
        Beverage(
            icon: "tea-cup",
            name: "Black Tea",
            base: .tea,
            type: [.hot, .iced],
            volume: [
                .single: 250.0
            ],
            caffeineAmount: [
                .single: 50.0
            ],
            caffeinePer100: 20.0
        ),
        Beverage(
            icon: "tea-cup",
            name: "Green Tea",
            base: .tea,
            type: [.hot, .iced],
            volume: [
                .single: 250.0
            ],
            caffeineAmount: [
                .single: 30.0
            ],
            caffeinePer100: 12.0
        ),
        Beverage(
            icon: "tea-cup",
            name: "Matcha",
            base: .tea,
            type: [.hot, .iced],
            volume: [
                .single: 250.0
            ],
            caffeineAmount: [
                .single: 67.625
            ],
            caffeinePer100: 27.05
        )
    ]
    
    static let sodaED: [Beverage] = [
        Beverage(
            icon: "can",
            name: "RedBull",
            base: .energyDrink,
            type: [.iced],
            volume: [
                .small: 250.0,
                .medium: 355.0,
                .large: 473.0
            ],
            caffeineAmount: [
                .small: 80.0,
                .medium: 80.0,
                .large: 80.0
            ]
        ),
        Beverage(
            icon: "can",
            name: "Monster",
            base: .energyDrink,
            type: [.iced],
            volume: [
                .large: 500
            ],
            caffeineAmount: [
                .large: 160.0
            ]
        ),
        Beverage(
            icon: "plastic-bottle",
            name: "Fire Ox",
            base: .energyDrink,
            type: [.iced],
            volume: [
                .medium: 500.0,
                .large: 1000.0
            ],
            caffeineAmount: [
                .medium: 30.0,
                .large: 30.0
            ]
        ),
    ]
    
    static let medicine: [Medicine] = [
        Medicine(icon: "tablets", name: "Solpadeine", caffeineContent: 65),
        Medicine(icon: "tablets", name: "Rinicold Hotcup", caffeineContent: 30)
    ]
}
