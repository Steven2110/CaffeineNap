//
//  BeverageListViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 11.06.2023.
//

import Foundation

final class BeverageListViewModel: ObservableObject {
    
    @Published var selectedList: [CNBeverage] = []
    @Published var selectedCategory: Category = .all
    
    @Published var isLoading: Bool = false
    
    func setSelectionList(with: Category, from beverageManager: CNBeverageManager) {
        DispatchQueue.main.async { [self] in
            selectedCategory = with
            selectedList = beverageManager.getFilteredList(of: selectedCategory)
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
            print("Error can't delete: \(error.localizedDescription)")
        }
    }
    
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
