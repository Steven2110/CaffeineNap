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
    
    static let noUserRecord = AlertItem(
        title: Text("No User Record"),
        message: Text("You must log into iCloud on your phone in order to utilize CaffeineNap's profile. Please log in on your phone's settings."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let createProfileSuccess = AlertItem(
        title: Text("Profile Created Successfully"),
        message: Text("Your profile has been successfully created."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let createProfileFailure = AlertItem(
        title: Text("Failed to Create Profile"),
        message: Text("We are unable to create your profile at this time.\nPlease contact developer email for help."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let unableToGetProfile = AlertItem(
        title: Text("Unable to Retrieve Profile"),
        message: Text("We are unable to retrieve your profile at this time.Please check your internet connection and try again later or contact developer email for help."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let updateProfileSuccess = AlertItem(
        title: Text("Profile Update Successfully"),
        message: Text("Your CaffeineNap profile was updated successfully."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let updateProfileFail = AlertItem(
        title: Text("Failed to Update Profile"),
        message: Text("We were unable to update your CaffeineNap profile at this time.\nPlease try again later."),
        dismissButton: .default(Text("Ok"))
    )
    
    // MARK: - Add custom beverages errors
    static let errorBeverageField = AlertItem(
        title: Text("Missing or Wrong Input"),
        message: Text("One of the beverage's general information is not filled or there are some mistakes.\nPlease check and try again."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let errorCaffeineVolumeField = AlertItem(
        title: Text("Missing or Wrong Input"),
        message: Text("One of the beverage's caffeine or volume field is not filled or there are some mistakes.\nPlease check and try again."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let failedSavingCaffeineVolume = AlertItem(
        title: Text("Network Error"),
        message: Text("Unable to save beverage's Volume and Caffeine Amount to CloudKit Database.\nPlease try again later."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let successSavingBeverage = AlertItem(
        title: Text("Successfully Saved Beverage"),
        message: Text("Saving beverage done successfully."),
        dismissButton: .default(Text("Ok"))
    )
    
    static let failedSavingBeverage = AlertItem(
        title: Text("Network Error"),
        message: Text("Unable to save beverage to CloudKit Database.\nPlease try again later."),
        dismissButton: .default(Text("Ok"))
    )
}
