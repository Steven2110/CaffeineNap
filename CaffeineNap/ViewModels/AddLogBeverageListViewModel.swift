//
//  AddLogBeverageListViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 20.07.2023.
//

import SwiftUI

final class AddLogBeverageListViewModel: ObservableObject {
    
    @Published var selectedList: [CNBeverage] = []
    @Published var selectedCategory: Category = .all
    
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
    
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
