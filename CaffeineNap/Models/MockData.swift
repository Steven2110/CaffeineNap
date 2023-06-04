//
//  MockData.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 08.03.2023.
//

import CloudKit

struct MockData {
    static var profile: CKRecord {
        let record = CKRecord(recordType: "CNUser")
        record["username"] = "steven2110"
        record["firstName"] = "Steven"
        record["lastName"] = "Wijaya"
        
        return record
    }
    
    static let customDrinks: [Beverage] = [Beverage]()
    
    static let coffee: [Beverage] = [
        Beverage(
            icon: "espresso-cup",
            name: "Espresso",
            base: .coffee,
            type: [.hot],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .single, volume: 30.0, amount: 63.6),
                VolumeCaffeineAmount(type: .double, volume: 60.0, amount: 127.2),
                VolumeCaffeineAmount(type: .triple, volume: 90.0, amount: 190.8)
            ],
            caffeinePer100: 212
        ),
        Beverage(
            icon: "coffee-cup",
            name: "Americano",
            base: .coffee,
            type: [.hot],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .small, volume: 150.0, amount: 64.8),
                VolumeCaffeineAmount(type: .medium, volume: 200.0, amount: 86.4),
                VolumeCaffeineAmount(type: .large, volume: 350.0, amount: 152.25)
            ],
            caffeinePer100: 43.2
        ),
        Beverage(
            icon: "coffee-cup",
            name: "Long Black",
            base: .coffee,
            type: [.hot],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .small, volume: 150.0, amount: 64.8),
                VolumeCaffeineAmount(type: .medium, volume: 200.0, amount: 86.4),
                VolumeCaffeineAmount(type: .large, volume: 350.0, amount: 152.25)
            ],
            caffeinePer100: 43.2
        ),
        Beverage(
            icon: "coffee-cup",
            name: "Black Coffee",
            base: .coffee,
            type: [.hot],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .small, volume: 150.0, amount: 64.8),
                VolumeCaffeineAmount(type: .medium, volume: 200.0, amount: 86.4),
                VolumeCaffeineAmount(type: .large, volume: 350.0, amount: 152.25)
            ],
            caffeinePer100: 43.2
        ),
        Beverage(
            icon: "takeaway-cup",
            name: "Cold Brew",
            base: .coffee,
            type: [.iced],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .small, volume: 250.0, amount: 137.722),
                VolumeCaffeineAmount(type: .medium, volume: 300.0, amount: 165.266),
                VolumeCaffeineAmount(type: .large, volume: 450.0, amount: 247.899)
            ],
            caffeinePer100: 55.0887
        ),
        Beverage(
            icon: "takeaway-cup",
            name: "Latte",
            base: .coffee,
            type: [.hot, .iced],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .small, volume: 250.0, amount: 81.33),
                VolumeCaffeineAmount(type: .medium, volume: 300.0, amount: 97.6),
                VolumeCaffeineAmount(type: .large, volume: 450.0, amount: 146.4)
            ],
            caffeinePer100: 32.533
        ),
        Beverage(
            icon: "coffee-cup",
            name: "Cappuccino",
            base: .coffee,
            type: [.hot, .iced],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .small, volume: 250.0, amount: 108.333),
                VolumeCaffeineAmount(type: .medium, volume: 300.0, amount: 130),
                VolumeCaffeineAmount(type: .large, volume: 450.0, amount: 195)
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
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .single, volume: 250.0, amount: 50.0)
            ],
            caffeinePer100: 20.0
        ),
        Beverage(
            icon: "tea-cup",
            name: "Green Tea",
            base: .tea,
            type: [.hot, .iced],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .single, volume: 250.0, amount: 30.0)
            ],
            caffeinePer100: 12.0
        ),
        Beverage(
            icon: "tea-cup",
            name: "Matcha",
            base: .tea,
            type: [.hot, .iced],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .single, volume: 250.0, amount: 67.625)
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
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .small, volume: 250.0, amount: 80.0),
                VolumeCaffeineAmount(type: .medium, volume: 355.0, amount: 80.0),
                VolumeCaffeineAmount(type: .large, volume: 473.0, amount: 80.0)
            ]
        ),
        Beverage(
            icon: "can",
            name: "Monster",
            base: .energyDrink,
            type: [.iced],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .large, volume: 500.0, amount: 160.0)
            ]
        ),
        Beverage(
            icon: "plastic-bottle",
            name: "Fire Ox",
            base: .energyDrink,
            type: [.iced],
            volumeAndCaffeineAmount: [
                VolumeCaffeineAmount(type: .medium, volume: 500.0, amount: 30.0),
                VolumeCaffeineAmount(type: .large, volume: 1000.0, amount: 30.0)
            ]
        ),
    ]
    
    static let medicine: [Medicine] = [
        Medicine(icon: "tablets", name: "Solpadeine", caffeineContent: 65),
        Medicine(icon: "tablets", name: "Rinicold Hotcup", caffeineContent: 30)
    ]
}
