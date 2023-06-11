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
    
    @State private var isPresentingAddSheet = false
    
    var body: some View {
        TabView(selection: $selectedItem) {
            CNHomeView()
                .tabItem { Label("Home", image: "home-icon") }
                .tag(1)
            Text("Caffeine Nap page!")
                .tabItem{ Label("CaffeineNap", systemImage: "moon.zzz") }
                .tag(2)
            Text("Add Drinks Page/Sheet!")
                .tabItem{ Label("Add Drinks", systemImage: "plus.circle").environment(\.symbolVariants, .none) }
                .tag(3)
            CNBeveragesListView()
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
        .onAppear { CloudKitManager.shared.getUserRecord() }
        .sheet(isPresented: $isPresentingAddSheet) {
            AddLogView(showParentSheet: $isPresentingAddSheet)
        }

    }
}

struct CNTabView_Previews: PreviewProvider {
    static var previews: some View {
        CNTabView()
    }
}
