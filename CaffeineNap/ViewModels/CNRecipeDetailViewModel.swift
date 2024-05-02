//
//  CNRecipeDetailViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 28.04.2024.
//

import CloudKit

final class CNRecipeDetailViewModel: ObservableObject {
    
    @Published var user: CNProfile = CNProfile(record: CKRecord(recordType: RecordType.profile))
    @Published var recipe: CNRecipe
    
    @Published var rating: Int = 0
    @Published var currentUserRating: CNRecipeRating = CNRecipeRating(record: CKRecord(recordType: RecordType.recipeRating))
    
    @Published var alert: AlertItem?
    @Published var isLoading: Bool = false
    
    @Published var isOwnRecipe: Bool = false
    
    init(recipe: CNRecipe) {
        self.recipe = recipe
    }
    
    func startUp() async {
        DispatchQueue.main.async { self.showLoadingView() }
        await fetchInstructionsTools()
        await fetchCurrentUserRatingAndOwnership()
        DispatchQueue.main.async { self.hideLoadingView() }
    }
    
    func fetchInstructionsTools() async {
        do {
            recipe.tools = try await CloudKitManager.shared.fetchRecipeTools(for: recipe.id)
            recipe.instructions = try await CloudKitManager.shared.fetchRecipeInstructions(for: recipe.id)
        } catch {
            DispatchQueue.main.async {
                self.alert = AlertContext.failedFetchRecipeDetail
            }
        }
    }
    
    func fetchCurrentUserRatingAndOwnership() async {
        do {
            let fetchedUser = try await CloudKitManager.shared.fetchProfile()
            let fetchedUserRating = recipe.ratings.first { $0.by.recordID == fetchedUser.id } ?? currentUserRating
            let isRecipeOwnedByCurrentUser = recipe.author.id == fetchedUser.id
            DispatchQueue.main.async { [self] in
                user = fetchedUser
                currentUserRating = fetchedUserRating
                isOwnRecipe = isRecipeOwnedByCurrentUser
            }
        } catch {
            DispatchQueue.main.async {
                self.alert = AlertContext.failedFetchRecipeDetail
            }
        }
    }
    
    func saveRating() async {
        DispatchQueue.main.async {
            self.showLoadingView()
        }
        
        do {
            // Try to fetch the rating record
            if let rating = try await CloudKitManager.shared.fetchCurrentUserRatingRecord(forRecipe: recipe.id, byUser: user.id) {
                // If the rating record exists, update it
                rating[CNRecipeRating.kRating] = currentUserRating.rating
                rating[CNRecipeRating.kBy] = CKRecord.Reference(recordID: user.id, action: .deleteSelf)
                rating[CNRecipeRating.kRecipe] = CKRecord.Reference(recordID: recipe.id, action: .deleteSelf)
                
                let recordsSaved = try await CloudKitManager.shared.save(.publicDB, record: rating)
            } else {
                // If the rating record doesn't exist, create a new one
                let rating = CKRecord(recordType: RecordType.recipeRating)
                rating[CNRecipeRating.kRating] = currentUserRating.rating
                rating[CNRecipeRating.kBy] = CKRecord.Reference(recordID: user.id, action: .deleteSelf)
                rating[CNRecipeRating.kRecipe] = CKRecord.Reference(recordID: recipe.id, action: .deleteSelf)
                
                let recordsSaved = try await CloudKitManager.shared.save(.publicDB, record: rating)
            }
        } catch {
            DispatchQueue.main.async  { [self] in
                alert = AlertContext.failedSavingRating
                hideLoadingView()
            }
        }
    }
    
    func showLoadingView() { isLoading = true }
    func hideLoadingView() { isLoading = false }
}
