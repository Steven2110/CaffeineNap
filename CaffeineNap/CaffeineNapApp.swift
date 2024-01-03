//
//  CaffeineNapApp.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 06.03.2023.
//

import SwiftUI

@main
struct CaffeineNapApp: App {
    let beverageManager: CNBeverageManager = CNBeverageManager()
    let logManager: CNLogManager = CNLogManager()
    var body: some Scene {
        WindowGroup {
            CNTabView()
                .environmentObject(beverageManager)
                .environmentObject(logManager)
        }
    }
}
