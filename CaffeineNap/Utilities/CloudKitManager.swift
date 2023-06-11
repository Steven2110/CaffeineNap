//
//  CloudKitManager.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 04.06.2023.
//

import CloudKit

final class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    private init() { }
    
    var userRecord: CKRecord?
    
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
//                print("Succesfully saved to DB")
                completed(.success(records))
            case .failure(let error):
//                print(error.localizedDescription)
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
}
