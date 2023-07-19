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
    
    func save(record: CKRecord, completed: @escaping (Result<CKRecord, Error>) -> Void) {
        
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            
            completed(.success(record))
        }
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
            let beverage = CNBeverage(record: record)
            beverages.append(beverage)
        }
        
        return beverages
    }
}
