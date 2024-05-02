//
//  CNRecipe.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 23.04.2024.
//

import UIKit
import CloudKit

struct CNRecipeRating: Identifiable {
    
    static let kBy = "by"
    static let kRating = "rating"
    static let kRecipe = "recipe"
    
    let id: CKRecord.ID
    let by: CKRecord.Reference
    var rating: Int
    
    var recipe: CKRecord.Reference
    
    init(record: CKRecord) {
        id = record.recordID
        by = (record[CNRecipeRating.kBy] as? CKRecord.Reference) ?? CKRecord.Reference(recordID: .init(recordName: RecordType.profile), action: .deleteSelf)
        rating = record[CNRecipeRating.kRating] as? Int ?? 0
        recipe = (record[CNRecipeRating.kRecipe] as? CKRecord.Reference) ?? CKRecord.Reference(recordID: .init(recordName: RecordType.recipe), action: .deleteSelf)
    }
}

struct CNRecipeTool: Identifiable {
    
    static let kName = "name"
    static let kAmount = "amount"
    static let kUnit = "unit"
    static let kIsOptional = "isOptional"
    static let kRecipe = "recipe"
    
    var id: CKRecord.ID
    var name: String
    var amount: Double
    var unit: String
    var isOptional: Bool = false
    
    var recipe: CKRecord.Reference
    
    func getAmountAndOptionalDesc() -> String {
        var desc = ""
        if amount > 0 {
            if hasFractionalPart(amount) {
                desc += "(" + String(format: "%.1f", amount)
            } else {
                desc += "(" + String(format: "%.0f", amount)
            }
            desc += " " + unit + ") "
        }
        if isOptional {
            desc += "(Optional)"
        }
        
        return desc
    }
    
    init(record: CKRecord) {
        id = record.recordID
        name = record[CNRecipeTool.kName] as? String ?? "N/A"
        amount = record[CNRecipeTool.kAmount] as? Double ?? 0.0
        unit = record[CNRecipeTool.kUnit] as? String ?? "N/A"
        isOptional = ((record[CNRecipeTool.kIsOptional] as? Int ?? 0) != 0)
        recipe = (record[CNRecipeTool.kRecipe] as? CKRecord.Reference)!
    }
}

struct CNRecipeInstruction: Identifiable {
    
    static let kStep = "step"
    static let kInstruction = "instruction"
    static let kRecipe = "recipe"
    
    var id: CKRecord.ID
    var step: Int
    var instruction: String
    
    var recipe: CKRecord.Reference
    
    init(record: CKRecord) {
        id = record.recordID
        step = record[CNRecipeInstruction.kStep] as? Int ?? 0
        instruction = record[CNRecipeInstruction.kInstruction] as? String ?? "N/A"
        recipe = (record[CNRecipeInstruction.kRecipe] as? CKRecord.Reference)!
    }
}

struct CNRecipe: Identifiable {
    
    static let kName = "name"
    static let kDescription = "description"
    static let kAuthor = "author"
    static let kImage = "image"
    static let kType = "type"
    static let kRatings = "ratings"
    static let kCaffeineAmount = "caffeineAmount"
    static let kWaterVolume = "waterVolume"
    static let kPreparationTime = "preparationTime"
    static let kTools = "tools"
    static let kInstructions = "instructions"
    
    let id: CKRecord.ID
    var name: String
    var description: String
    var author: CNProfile
    var image: CKAsset!
    var type: String
    var ratings: [CNRecipeRating]
    var caffeineAmount: Double
    var waterVolume: Double
    var preparationTime: Double
    var tools: [CNRecipeTool]
    var instructions: [CNRecipeInstruction]
    
    let authorReference: CKRecord.Reference
    
    // Functions
    func calculateRating() -> Double {
        guard !ratings.isEmpty else { return 0 }
        let ratingTotal = ratings.reduce(0) { $0 + $1.rating }
        let ratingAverage = Double(ratingTotal) / Double(ratings.count)
        return ratingAverage
    }
    
    func getRatingAmount() -> String {
        let numberFormatter = NumberFormatter()
        let ratingsAmount = ratings.count

        if ratingsAmount >= 1000000 {
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 1
            return "\(numberFormatter.string(from: NSNumber(value: Double(ratingsAmount) / 1000000))!)M"
        } else if ratingsAmount >= 1000 {
            numberFormatter.numberStyle = .decimal
            return "\(numberFormatter.string(from: NSNumber(value: Double(ratingsAmount) / 1000))!)k"
        } else {
            return "\(ratingsAmount)"
        }
    }
    
    init(record: CKRecord) {
        id = record.recordID
        name = record[CNRecipe.kName] as? String ?? "N/A"
        description = record[CNRecipe.kDescription] as? String ?? "N/A"
        author = CNProfile(record: CKRecord.init(recordType: RecordType.profile))
        image = record[CNRecipe.kImage] as? CKAsset
        type = record[CNRecipe.kType] as? String ?? "N/A"
        ratings = []
        caffeineAmount = record[CNRecipe.kCaffeineAmount] as? Double ?? 0.0
        waterVolume = record[CNRecipe.kWaterVolume] as? Double ?? 0.0
        preparationTime = record[CNRecipe.kPreparationTime] as? Double ?? 0.0
        tools = []
        instructions = []
             
        authorReference = (record[CNRecipe.kAuthor] as? CKRecord.Reference)!
    }
    
    func createRecipeImage() -> UIImage {
        guard let image = image else { return ImagePlaceHolder.recipeImage }
        return image.convertToUIImage(in: .recipeImage)
    }
}

