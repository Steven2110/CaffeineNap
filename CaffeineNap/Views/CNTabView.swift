//
//  CNTabView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 06.03.2023.
//

import SwiftUI

struct CNTabView: View {
    
    @State private var selectedItem = 1
    @State private var previousSelectedItem = 1
    @EnvironmentObject private var beverageManager: CNBeverageManager
    @EnvironmentObject private var logManager: CNLogManager
    
    @State private var isPresentingAddSheet = false
    
    var body: some View {
        TabView(selection: $selectedItem) {
            CNHomeView()
                .tabItem { Label("Home", image: "home-icon") }
                .tag(1)
            NavigationView {
                CNRecipeListView()
            }
                .tabItem{ Label("CNRecipe", systemImage: "mug.fill") }
                .tag(2)
            Text("Add Drinks Page/Sheet!")
                .tabItem{ Label("Add Drinks", systemImage: "plus.circle").environment(\.symbolVariants, .none) }
                .tag(3)
            NavigationView {
                CNBeveragesListView()
            }
                .tabItem{ Label("Beverages", systemImage: "cup.and.saucer") }
                .tag(4)
            ProfileView()
                .tabItem{ Label("Settings", systemImage: "gearshape.fill") }
                .tag(5)
        }
        .accentColor(.brandPrimary)
        .onChange(of: selectedItem) { newValue in
            if newValue == 3 {
                isPresentingAddSheet = true
                selectedItem = previousSelectedItem
            } else {
                previousSelectedItem = newValue
            }
        }
        .onAppear {
            CloudKitManager.shared.getUserRecord()
            Task {
                if beverageManager.beverages.isEmpty {
                    do {
                        beverageManager.beverages = try await CloudKitManager.shared.fetchBeveragesList()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingAddSheet) {
            AddLogBeverageListView(showParentSheet: $isPresentingAddSheet)
        }

    }
}

struct CNTabView_Previews: PreviewProvider {
    static var previews: some View {
        CNTabView()
    }
}
