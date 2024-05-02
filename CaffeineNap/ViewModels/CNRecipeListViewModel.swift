//
//  CNRecipeListViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 24.04.2024.
//

import Foundation

final class CNRecipeListViewModel: ObservableObject {
    
    @Published var recipes: [CNRecipe] = []
    
    @Published var isLoading: Bool = false
    
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
