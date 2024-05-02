//
//  Constants.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 09.03.2023.
//

import UIKit

enum RecordType {
    static let profile = "CNProfile"
    static let beverage = "CNBeverage"
    static let volumeCaffeineAmount = "VolumeCaffeineAmount"
    static let log = "CNLog"
    static let recipe = "CNRecipe"
    static let recipeRating = "CNRecipeRating"
    static let recipeTool = "CNRecipeTool"
    static let recipeInstruction = "CNRecipeInstruction"
}

enum ImageDimension {
    case avatar
    case recipeImage
    
    var placeholder: UIImage {
        switch self {
        case .avatar:
            return ImagePlaceHolder.avatar
        case .recipeImage:
            return ImagePlaceHolder.recipeImage
        }
    }
}

enum ImagePlaceHolder {
    static let avatar = UIImage(named: "default-avatar")!
    static let recipeImage = UIImage(named: "Icon1")!
}

enum NotificationsDay {
    static let days: [DayNotification] = [
        DayNotification(day: "Monday", short: "Mon", letter: "M"),
        DayNotification(day: "Tuesday", short: "Tue", letter: "T"),
        DayNotification(day: "Wednesday", short: "Wed", letter: "W"),
        DayNotification(day: "Thursday", short: "Thu", letter: "T"),
        DayNotification(day: "Friday", short: "Fri", letter: "F"),
        DayNotification(day: "Saturday", short: "Sat", letter: "S"),
        DayNotification(day: "Sunday", short: "Sun", letter: "S")
    ]
}

enum Category: String, CaseIterable {
    case all = "All"
    case custom = "Custom Drink"
    case coffee = "Coffee"
    case tea = "Tea"
    case sodaED = "Soda & Energy drink"
//        case medicine = "Medicine"
}

enum Language: String  {
    case en
    case ru
    
    var description : String {
        switch self {
        case .en: return "English"
        case .ru: return "Russian"
        }
    }
}

let SPECIFIER: String = "%.2f"

let brewMethods: [String] = [
    "Pour Over",
    "Espresso",
    "Instant Coffee",
    "Cold Brew",
    "French Press",
    "Drip",
    "Aeropress"
]

let recipeToolUnits: [String] = [
    "pcs",
    "gr",
    "ml"
]
