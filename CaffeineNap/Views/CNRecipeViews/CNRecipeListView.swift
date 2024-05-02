//
//  CNRecipeListView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 23.04.2024.
//

import SwiftUI

struct CNRecipeListView: View {
    
    @State private var showForm: Bool = false
    @State private var shouldRefetch: Bool = false
    
    @State private var recipes: [CNRecipe] = []
    
    var body: some View {
        ScrollView {
            ForEach(recipes) { recipe in
                NavigationLink {
                    CNRecipeDetailView(vm: .init(recipe: recipe))
                } label: {
                    CNRecipeRowView(recipe: recipe)
                }
            }.padding()
        }
        .navigationTitle("Recipe")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showForm.toggle() } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .task {
            do {
                recipes = try await CloudKitManager.shared.fetchRecipesList()
            } catch {
                print("Error fetching recipes: \(error.localizedDescription)")
            }
        }
        .sheet(isPresented: $showForm, onDismiss: {
            Task {
                do {
                    recipes = try await CloudKitManager.shared.fetchRecipesList()
                } catch {
                    print("Error fetching recipes: \(error.localizedDescription)")
                }
            }
        }) {
            CNRecipeFormView()
        }
    }
}

#Preview {
    CNRecipeListView()
}
