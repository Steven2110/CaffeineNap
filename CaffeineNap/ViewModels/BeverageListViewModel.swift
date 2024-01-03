//
//  BeverageListViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 11.06.2023.
//

import SwiftUI

final class BeverageListViewModel: ObservableObject {
    
    @Published var selectedList: [CNBeverage] = []
    @Published var selectedCategory: Category = .all
    
    @Published var showAlert: Bool = false
    @Published var alert: AlertItem?
    @Published var isLoading: Bool = false
    
    func setSelectionList(from beverageManager: CNBeverageManager, animation: Bool = false) {
        DispatchQueue.main.async { [self] in
            if animation {
                withAnimation(.easeInOut(duration: 1.5)) {
                    selectedList = beverageManager.getFilteredList(of: selectedCategory)
                }
            } else {
                selectedList = beverageManager.getFilteredList(of: selectedCategory)
            }
        }
    }
    
    func deleteBeverage(_ beverage: CNBeverage, on beverageManager: CNBeverageManager) async {
        let index = selectedList.firstIndex { $0.id == beverage.id }
        
        do {
            let deletedRecordID = try await CloudKitManager.shared.deleteRecord(id: beverage.id)
            
            if deletedRecordID == beverage.id {
                DispatchQueue.main.async {
                    self.selectedList.remove(at: index!)
                }
                beverageManager.remove(beverage)
            }
        } catch {
            showAlert = true
            alert = AlertContext.failedDeleteBeverage
        }
    }
    
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
