//
//  AlertItem.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 02.05.2023.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id: UUID = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}


struct AlertContext {
    // - MARK: - ProfileView Errors
    static let invalidProfile = AlertItem(
        title: Text("Invalid Profile"),
        message: Text("All fields are required as well as a profile photo.\nPlease try again."),
        dismissButton: .default(Text("Ok"))
    )
}
