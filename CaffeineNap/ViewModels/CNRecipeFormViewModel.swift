//
//  CNRecipeFormViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 24.04.2024.
//

import CloudKit
import UIKit

final class CNRecipeFormViewModel: ObservableObject {
    
    @Published var author: CNProfile = CNProfile(record: CKRecord.init(recordType: RecordType.profile))
    
    var recipeRecordID: CKRecord.ID?
    @Published var recipeName: String = ""
    @Published var recipeDescription: String = ""
    @Published var type: String = "Espresso"
    @Published var caffeineAmount: Double = 0.0
    @Published var waterVolume: Double = 0.0
    @Published var preparationTime: Double = 1.0
    
    @Published var tempTools: [[String: Any]] = [
        [
            "name": "",
            "amount": 1,
            "unit": "pcs"
        ]
    ]
    @Published var tempInstructions: [[String: Any]] = [
        [
            "id": UUID(),
            "step": 1,
            "instruction": ""
        ]
    ]
    
    @Published var selectedImage: UIImage = UIImage(named: "Icon1")!
    
    @Published var alert: AlertItem?
    @Published var isLoading: Bool = false
    
    init(recipe: CNRecipe) {
        recipeRecordID = recipe.id
        recipeName = recipe.name
        recipeDescription = recipe.description
        type = recipe.type
        caffeineAmount = recipe.caffeineAmount
        waterVolume = recipe.waterVolume
        preparationTime = recipe.preparationTime
        
        tempTools.removeAll()
        tempInstructions.removeAll()
        
        for tool in recipe.tools {
            tempTools.append(
                [
                    "id": tool.id,
                    "name": tool.name,
                    "amount": tool.amount,
                    "unit": tool.unit
                ]
            )
        }
        
        for instruction in recipe.instructions {
            tempInstructions.append(
                [
                    "id": instruction.id,
                    "step": instruction.step,
                    "instruction": instruction.instruction
                ]
            )
        }
        tempInstructions.sort { (dict1, dict2) -> Bool in
            guard let step1 = dict1["step"] as? Int, let step2 = dict2["step"] as? Int else {
                return false
            }
            return step1 < step2
        }
        
        print(tempInstructions)
    }
    
    init() { }
    
    func addTool() {
        tempTools.append(
            [
                "id": UUID(),
                "name": "",
                "amount": 1,
                "unit": "pcs",
                "isOptional": false
            ]
        )
    }
    
    func addInstruction() {
        let newStep: Int = tempInstructions.count + 1
        tempInstructions.append(
            [
                "id": UUID(),
                "step": newStep,
                "instruction": ""
            ]
        )
    }
    
    func deleteTool(at index: Int) {
        tempTools.remove(at: index)
    }
    
    func deleteInstruction(at index: Int) {
        tempInstructions.remove(at: index)
        let totalStep: Int = tempInstructions.count
        for i in index..<totalStep {
            tempInstructions[i]["step"] = i + 1
        }
    }
    
    func saveRecipe() async {
        DispatchQueue.main.async {
            self.showLoadingView()
        }
        
        guard checkValidity() else {
            DispatchQueue.main.async { [self] in
                alert = AlertContext.errorRecipeField
                hideLoadingView()
            }
            return
        }
        
        var recordsToSave: [CKRecord] = []
        let recipe: CKRecord = CKRecord(recordType: RecordType.recipe)
        
        recipe[CNRecipe.kName] = recipeName
        recipe[CNRecipe.kDescription] = recipeDescription
        recipe[CNRecipe.kType] = type
        recipe[CNRecipe.kCaffeineAmount] = caffeineAmount.round(decimalPlaces: 2)
        recipe[CNRecipe.kWaterVolume] = waterVolume.round(decimalPlaces: 2)
        recipe[CNRecipe.kPreparationTime] = preparationTime
        recipe[CNRecipe.kAuthor] = CKRecord.Reference(recordID: author.id, action: .deleteSelf)
        recipe[CNRecipe.kImage] = selectedImage.convertToCKAsset()
        recordsToSave.append(recipe)
        
        for tool in tempTools {
            let toolRecord: CKRecord = CKRecord(recordType: RecordType.recipeTool)
            
            toolRecord[CNRecipeTool.kName] = tool["name"] as? String ?? ""
            toolRecord[CNRecipeTool.kAmount] = tool["name"] as? Double ?? 0.0
            toolRecord[CNRecipeTool.kUnit] = tool["unit"] as? String ?? ""
            let isOptional = tool["isOptional"] as? Bool ?? false
            toolRecord[CNRecipeTool.kIsOptional] = isOptional ? 1 : 0
            toolRecord[CNRecipeTool.kRecipe] = CKRecord.Reference(recordID: recipe.recordID, action: .deleteSelf)
            
            recordsToSave.append(toolRecord)
        }
        
        for instruction in tempInstructions {
            let instructionRecord: CKRecord = CKRecord(recordType: RecordType.recipeInstruction)
            
            instructionRecord[CNRecipeInstruction.kStep] = instruction["step"] as? Int ?? 0
            instructionRecord[CNRecipeInstruction.kInstruction] = instruction["instruction"] as? String ?? ""
            instructionRecord[CNRecipeInstruction.kRecipe] = CKRecord.Reference(recordID: recipe.recordID, action: .deleteSelf)
            
            recordsToSave.append(instructionRecord)
        }
        
        do {
            print(recordsToSave)
            let records = try await CloudKitManager.shared.batchSave(.publicDB, records: recordsToSave)
            print("RECORD")
            print(records)
            print("Done save")
            DispatchQueue.main.async { [self] in
                alert = AlertContext.successSavingRecipe
                hideLoadingView()
            }
        } catch {
            print("Error saving records: \(error.localizedDescription)")
            DispatchQueue.main.async { [self] in
                alert = AlertContext.failedSavingRecipe
                hideLoadingView()
            }
        }
    }
    
    func updateRecipe() async {
        DispatchQueue.main.async {
            self.showLoadingView()
        }
        
        guard checkValidity() else {
            DispatchQueue.main.async { [self] in
                alert = AlertContext.errorRecipeField
                hideLoadingView()
            }
            return
        }
        
        var recordsToSave: [CKRecord] = []
        do {
            let recipe = try await CloudKitManager.shared.fetchRecord(from: .publicDB, with: recipeRecordID!)
            recipe[CNRecipe.kName] = recipeName
            recipe[CNRecipe.kDescription] = recipeDescription
            recipe[CNRecipe.kType] = type
            recipe[CNRecipe.kCaffeineAmount] = caffeineAmount.round(decimalPlaces: 2)
            recipe[CNRecipe.kWaterVolume] = waterVolume.round(decimalPlaces: 2)
            recipe[CNRecipe.kPreparationTime] = preparationTime
            recipe[CNRecipe.kAuthor] = CKRecord.Reference(recordID: author.id, action: .deleteSelf)
            recipe[CNRecipe.kImage] = selectedImage.convertToCKAsset()
            recordsToSave.append(recipe)
            
            for tool in tempTools {
                if tool["id"] is UUID {
                    let toolRecord: CKRecord = CKRecord(recordType: RecordType.recipeTool)
                    
                    toolRecord[CNRecipeTool.kName] = tool["name"] as? String ?? ""
                    toolRecord[CNRecipeTool.kAmount] = tool["name"] as? Double ?? 0.0
                    toolRecord[CNRecipeTool.kUnit] = tool["unit"] as? String ?? ""
                    let isOptional = tool["isOptional"] as? Bool ?? false
                    toolRecord[CNRecipeTool.kIsOptional] = isOptional ? 1 : 0
                    toolRecord[CNRecipeTool.kRecipe] = CKRecord.Reference(recordID: recipe.recordID, action: .deleteSelf)
                    
                    recordsToSave.append(toolRecord)
                } else if tool["id"] is CKRecord.ID {
                    let toolRecordID = tool["id"] as! CKRecord.ID
                    let toolRecord: CKRecord = try await CloudKitManager.shared.fetchRecord(from: .publicDB, with: toolRecordID)
                    
                    toolRecord[CNRecipeTool.kName] = tool["name"] as? String ?? ""
                    toolRecord[CNRecipeTool.kAmount] = tool["name"] as? Double ?? 0.0
                    toolRecord[CNRecipeTool.kUnit] = tool["unit"] as? String ?? ""
                    let isOptional = tool["isOptional"] as? Bool ?? false
                    toolRecord[CNRecipeTool.kIsOptional] = isOptional ? 1 : 0
                    toolRecord[CNRecipeTool.kRecipe] = CKRecord.Reference(recordID: recipe.recordID, action: .deleteSelf)
                    
                    recordsToSave.append(toolRecord)
                }
            }
            
            for instruction in tempInstructions {
                if instruction["id"] is UUID {
                    let instructionRecord: CKRecord = CKRecord(recordType: RecordType.recipeInstruction)
                    
                    instructionRecord[CNRecipeInstruction.kStep] = instruction["step"] as? Int ?? 0
                    instructionRecord[CNRecipeInstruction.kInstruction] = instruction["instruction"] as? String ?? ""
                    instructionRecord[CNRecipeInstruction.kRecipe] = CKRecord.Reference(recordID: recipe.recordID, action: .deleteSelf)
                    
                    recordsToSave.append(instructionRecord)
                } else if instruction["id"] is CKRecord.ID {
                    let instructionRecordID = instruction["id"] as! CKRecord.ID
                    let instructionRecord: CKRecord = try await CloudKitManager.shared.fetchRecord(from: .publicDB, with: instructionRecordID)
                    
                    instructionRecord[CNRecipeInstruction.kStep] = instruction["step"] as? Int ?? 0
                    instructionRecord[CNRecipeInstruction.kInstruction] = instruction["instruction"] as? String ?? ""
                    instructionRecord[CNRecipeInstruction.kRecipe] = CKRecord.Reference(recordID: recipe.recordID, action: .deleteSelf)
                    
                    recordsToSave.append(instructionRecord)
                }
            }
        } catch {
            print("Error fetching existing record: \(error.localizedDescription)")
            return
        }
        
        do {
            print(recordsToSave)
            let records = try await CloudKitManager.shared.batchSave(.publicDB, records: recordsToSave)
            print("RECORD")
            print(records)
            print("Done save")
            DispatchQueue.main.async { [self] in
                alert = AlertContext.successSavingRecipe
                hideLoadingView()
            }
        } catch {
            print("Error saving records: \(error.localizedDescription)")
            DispatchQueue.main.async { [self] in
                alert = AlertContext.failedSavingRecipe
                hideLoadingView()
            }
        }
    }
    
    func deleteRecipe() async {
        
    }
    
    func checkValidity() -> Bool {
        guard !recipeName.isEmpty,
              !recipeDescription.isEmpty else {
            return false
        }
        
        var dataFull: Bool = true
        
        for (tool, instruction) in zip(tempTools, tempInstructions) {
            let toolName = tool["name"] as? String ?? ""
            let instruction = instruction["instruction"] as? String ?? ""
            dataFull = dataFull && !toolName.isEmpty && !instruction.isEmpty
        }
        
        return dataFull
    }
    
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
