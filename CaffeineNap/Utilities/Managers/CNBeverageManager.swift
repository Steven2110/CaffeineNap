//
//  CNBeverageManager.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 14.07.2023.
//

import Foundation

final class CNBeverageManager: ObservableObject {
    @Published var beverages: [CNBeverage] = []
    
    private func sort() {
        beverages.sort { lhs, rhs in
            if lhs.base == rhs.base {
                return lhs.name < rhs.name
            }
            
            return lhs.base.rawValue < rhs.base.rawValue
        }
    }
    
    func remove(_ beverage: CNBeverage) {
        DispatchQueue.main.async { [self] in
            let index = beverages.firstIndex { $0.id == beverage.id }
            beverages.remove(at: index!)
            sort()
        }
    }
    
    func getFilteredList(of category: Category = .all) -> [CNBeverage] {
        switch category {
        case .all:
            return beverages
        case .custom:
            return beverages.filter { $0.isCustom }
        case .coffee:
            return beverages.filter { $0.base == .coffee }
        case .tea:
            return beverages.filter { $0.base == .tea }
        case .sodaED:
            return beverages.filter { $0.base == .soda || $0.base == .energyDrink }
        }
        
    }
}
