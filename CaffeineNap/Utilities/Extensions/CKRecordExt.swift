//
//  CKRecordExt.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 13.06.2023.
//

import CloudKit

extension CKRecord {
    func convertToCNBeverage() -> CNBeverage { CNBeverage(record: self) }
    
    func convertToVolumeCaffeineAmount() -> VolumeCaffeineAmount {
        VolumeCaffeineAmount(record: self)
    }
    
    func convertToCNLog() -> CNLog {
        CNLog(record: self)
    }
    
    func convertToCNProfile() -> CNProfile {
        CNProfile(record: self)
    }
    
    func convertToCNRecipe() -> CNRecipe {
        CNRecipe(record: self)
    }
    
    func convertToCNRecipeRating() -> CNRecipeRating {
        CNRecipeRating(record: self)
    }
    
    func convertToCNRecipeTool() -> CNRecipeTool {
        CNRecipeTool(record: self)
    }
    
    func convertToCNRecipeInstruction() -> CNRecipeInstruction {
        CNRecipeInstruction(record: self)
    }
}
