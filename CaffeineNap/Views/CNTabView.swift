//
//  CNTabView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 06.03.2023.
//

import SwiftUI

struct CNTabView: View {
    var body: some View {
        TabView {
            CNHomeView()
                .tabItem { Label("Home", image: "home-icon") }
            Text("Caffeine Nap page!")
                .tabItem{ Label("CaffeineNap", systemImage: "moon.zzz") }
            Text("Add Drinks Page/Sheet!")
                .tabItem{ Label("Add Drinks", systemImage: "plus.circle").environment(\.symbolVariants, .none) }
            CNBeveragesListView()
                .tabItem{ Label("Beverages", systemImage: "cup.and.saucer") }
            Text("Settings & Profile Page!")
                .tabItem{ Label("Settings", systemImage: "gearshape.fill") }
        }.accentColor(.brandPrimary)
    }
}

struct CNTabView_Previews: PreviewProvider {
    static var previews: some View {
        CNTabView()
    }
}
