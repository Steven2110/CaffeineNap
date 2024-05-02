//
//  CloudKitManager.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 04.06.2023.
//

import CloudKit

enum DatabaseType { case publicDB, privateDB }

final class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    private init() { }
    
    private let container: CKContainer = CKContainer.default()
    
    var userRecord: CKRecord?
    
    private func getDatabaseContainer(_ of: DatabaseType) -> CKDatabase {
        switch of {
        case .publicDB:
            return container.publicCloudDatabase
        case .privateDB:
            return container.privateCloudDatabase
        }
    }
    
    func getUserRecord() {
        
        // Fetch UserRecordID from container
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print("Error fetching UserRecordID: \(error!.localizedDescription)")
                return
            }
            
            // Get UserRecord from public db
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print("Error fetching UserRecord: \(error!.localizedDescription)")
                    return
                }
                
                self.userRecord = userRecord
            }
        }
    }
       
    func batchSave(_ database: DatabaseType = .privateDB, records: [CKRecord]) async throws -> [CKRecord] {
    
        let database = getDatabaseContainer(database)
    
        let (savedResult, _) = try await database.modifyRecords(saving: records, deleting: [])
        print(savedResult)
        return savedResult.compactMap { _, result in try? result.get() }
    }
    
    func batchSave(records: [CKRecord], completed: @escaping (Result<[CKRecord], Error>) -> Void) {
        // Create CKOperation to batch save our User and Profile records
        let operation = CKModifyRecordsOperation(recordsToSave: records)
        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success():
                completed(.success(records))
            case .failure(let error):
                completed(.failure(error))
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func save(_ to: DatabaseType = .privateDB, record: CKRecord) async throws -> CKRecord {
    
        let database = getDatabaseContainer(to)
    
        return try await database.save(record)
    }
    
    func save(record: CKRecord, completed: @escaping (Result<CKRecord, Error>) -> Void) {
        
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            
            completed(.success(record))
        }
    }
    
    func fetchRecord(from db: DatabaseType = .publicDB, with id: CKRecord.ID) async throws -> CKRecord {
        let database = getDatabaseContainer(db)
        
        return try await database.record(for: id)
    }
    
    func fetchRecord(with id: CKRecord.ID, completed: @escaping (Result<CKRecord, Error>) -> Void) {
        // Fetch data using ID
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            
            completed(.success(record))
        }
    }
    
    func fetchProfile() async throws -> CNProfile {
        do {
            let userRecordID = try await container.userRecordID()
            let userRecord = try await container.publicCloudDatabase.record(for: userRecordID)
            
            guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return CNProfile(record: .init(recordType: RecordType.profile)) }
            let profileRecordID = profileReference.recordID
            
            let database = getDatabaseContainer(.publicDB)
            let result = try await database.record(for: profileRecordID)
            
            let userProfile = result.convertToCNProfile()
            return userProfile
        } catch {
            print("Not found userRecordID")
            print(error.localizedDescription)
            return CNProfile(record: .init(recordType: RecordType.profile))
        }
    }
    
    func fetchBeveragesList() async throws -> [CNBeverage] {
        
        var beverages: [CNBeverage] = []
        // Initialize sorting
        let sortBase = NSSortDescriptor(key: CNBeverage.kBase, ascending: true)
        let sortName = NSSortDescriptor(key: CNBeverage.kName, ascending: true)
        // Initialize query
        let query = CKQuery(recordType: RecordType.beverage, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortBase, sortName]
        
        // Fetching from public database
        let database = getDatabaseContainer(.publicDB)
        
        var result = try await database.records(matching: query)
        var records = result.matchResults.compactMap { try? $0.1.get() }
        
        for record in records {
            let beverage = CNBeverage(record: record)
            beverages.append(beverage)
        }
        
        // Fetching from private database
        let privateDatabase = getDatabaseContainer(.privateDB)
        
        result = try await privateDatabase.records(matching: query)
        records = result.matchResults.compactMap { try? $0.1.get() }
        
        for record in records {
            beverages.append(record.convertToCNBeverage())
        }
        
        return beverages
    }
    
    func deleteRecord(id: CKRecord.ID) async throws -> CKRecord.ID {
        
        let deletedRecord = try await container.privateCloudDatabase.deleteRecord(withID: id)
        
        return deletedRecord
    }
    
    func fetchVolumeCaffeineAmounts(_ from: DatabaseType = .privateDB, for beverage: CKRecord.ID) async throws -> [VolumeCaffeineAmount] {
        
        var volumeCaffeineAmounts: [VolumeCaffeineAmount] = []
        // Initialize sorting
        let sortVolume = NSSortDescriptor(key: VolumeCaffeineAmount.kVolume, ascending: true)
        // Initialize query
        let query = CKQuery(recordType: RecordType.volumeCaffeineAmount, predicate: NSPredicate(format: "beverage == %@", beverage))
        query.sortDescriptors = [sortVolume]
        
        // To get from which database container we should query our request
        let database = getDatabaseContainer(from)
        
        let result = try await database.records(matching: query)
        let records = result.0.compactMap { try? $0.1.get() }
        
        for record in records {
            volumeCaffeineAmounts.append(record.convertToVolumeCaffeineAmount())
        }
        
        return volumeCaffeineAmounts
    }
    
    func fetchLog(for date: Date) async throws -> [CNLog] {
        
        var logs: [CNLog] = []
        // Initialize sorting
        let sortVolume = NSSortDescriptor(key: CNLog.kDrinkTime, ascending: false)
        // Add predicate for fetching specific date record (drink time)
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let tomorrow = Calendar.current.startOfDay(for: tomorrowDate)
        let predicate = NSPredicate(format: "drinkTime >= %@ && drinkTime <= %@", date as CVarArg, tomorrow as CVarArg)
        // Initialize query
        let query = CKQuery(recordType: RecordType.log, predicate: predicate)
        query.sortDescriptors = [sortVolume]
        
        // To get from which database container we should query our request
        
        let result = try await container.privateCloudDatabase.records(matching: query)
        let records = result.0.compactMap { try? $0.1.get() }
        
        for record in records {
            logs.append(record.convertToCNLog())
        }
        
        return logs
    }
    
    func fetchRecipesList() async throws -> [CNRecipe] {
        var recipes: [CNRecipe] = []

        // Initialize query
        let query = CKQuery(recordType: RecordType.recipe, predicate: NSPredicate(value: true))
        
        // Fetching from public database
        let database = getDatabaseContainer(.publicDB)
        
        let result = try await database.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        print(records)
        
        for record in records {
            var recipe = record.convertToCNRecipe()
            print(CNRecipe(record: record))
            print(recipe)
            
            let author = try await fetchRecipeAuthor(recipe.authorReference)
            let ratings = try await fetchRecipeRatings(for: recipe.id)
            recipe.author = author
            recipe.ratings = ratings
            
            recipes.append(recipe)
        }
        
        return recipes
    }
    
    func fetchRecipeAuthor(_ authorReference: CKRecord.Reference) async throws -> CNProfile {
        print("Fetching author")
        let recordID = authorReference.recordID
        let record = try await fetchRecord(with: recordID)
        
        return record.convertToCNProfile()
    }
    
    func fetchRecipeRatings(for recipe: CKRecord.ID) async throws -> [CNRecipeRating] {
        print("Fetching ratings")
        var ratings = [CNRecipeRating]()
        
        // Initialize query
        let query = CKQuery(recordType: RecordType.recipeRating, predicate: NSPredicate(format: "recipe == %@", recipe))
        
        // To get from which database container we should query our request
        let database = getDatabaseContainer(.publicDB)
        
        let result = try await database.records(matching: query)
        let records = result.0.compactMap { try? $0.1.get() }
        
        for record in records {
            ratings.append(record.convertToCNRecipeRating())
        }
        
        return ratings
    }
    
    func fetchRecipeTools(for recipe: CKRecord.ID) async throws -> [CNRecipeTool] {
        print("Fetching tools")
        var tools = [CNRecipeTool]()
        
        // Initialize query
        let query = CKQuery(recordType: RecordType.recipeTool, predicate: NSPredicate(format: "recipe == %@", recipe))
        
        // To get from which database container we should query our request
        let database = getDatabaseContainer(.publicDB)
        
        let result = try await database.records(matching: query)
        let records = result.0.compactMap { try? $0.1.get() }
        
        for record in records {
            tools.append(record.convertToCNRecipeTool())
        }
        
        return tools
    }
    
    func fetchRecipeInstructions(for recipe: CKRecord.ID) async throws -> [CNRecipeInstruction] {
        print("Fetching instructions")
        var instructions = [CNRecipeInstruction]()
        
        // Initialize query
        let query = CKQuery(recordType: RecordType.recipeInstruction, predicate: NSPredicate(format: "recipe == %@", recipe))
        
        // To get from which database container we should query our request
        let database = getDatabaseContainer(.publicDB)
        
        let result = try await database.records(matching: query)
        let records = result.0.compactMap { try? $0.1.get() }
        
        for record in records {
            instructions.append(record.convertToCNRecipeInstruction())
        }
        
        return instructions
    }
    
    func fetchCurrentUserRatingRecord(forRecipe: CKRecord.ID, byUser: CKRecord.ID) async throws -> CKRecord? {
        print("Fetching user rating")
        
        // Initialize query
        let predicate = NSPredicate(format: "recipe == %@ && by == %@", forRecipe as CVarArg, byUser as CVarArg)
        let query = CKQuery(recordType: RecordType.recipeRating, predicate: predicate)
        
        // To get from which database container we should query our request
        let database = getDatabaseContainer(.publicDB)
        
        let result = try await database.records(matching: query)
        let records = result.0.compactMap { try? $0.1.get() }
        
        return records.first
    }
}
