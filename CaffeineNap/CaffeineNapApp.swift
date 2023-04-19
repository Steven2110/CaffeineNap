//
//  CaffeineNapApp.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 06.03.2023.
//

import SwiftUI

@main
struct CaffeineNapApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            CNTabView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
