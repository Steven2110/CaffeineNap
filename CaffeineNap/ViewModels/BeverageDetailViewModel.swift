//
//  BeverageDetailViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 14.07.2023.
//

import Foundation
import CloudKit

final class BeverageDetailViewModel: ObservableObject {
    
    var beverage: CNBeverage
    @Published var volumeCaffeineAmounts: [VolumeCaffeineAmount] = []
    @Published var isLoading: Bool = false
    
    init(beverage: CNBeverage) {
        self.beverage = beverage
    }
    
    @MainActor
    func fetchVolumeCaffeine() async {
        showLoadingView()
        print("GETTING")
        do {
            let dbLocation: DatabaseType = beverage.isCustom ? .privateDB : .publicDB
            volumeCaffeineAmounts = try await CloudKitManager.shared.fetchVolumeCaffeineAmounts(dbLocation, for: beverage.id)
            hideLoadingView()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
