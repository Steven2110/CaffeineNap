//
//  CNProfileViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 04.06.2023.
//

import CloudKit
import UIKit

enum ProfileContext { case create, update }

final class CNProfileViewModel: ObservableObject {
    
    @Published var avatar: UIImage = ImagePlaceHolder.avatar
    @Published var username: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    
    @Published var isLoading: Bool = false
    @Published var alertItem: AlertItem?
    
    private var currentProfileRecord: CKRecord? {
        didSet { profileContext = .update }
    }
    var profileContext: ProfileContext = .create
        
    func createProfile() {
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        
        // Create CKRecord from ProfileView
        let profileRecord = createProfileRecord()
        
        // Fetching UserRecord from public db
        guard let userRecord = CloudKitManager.shared.userRecord else {
            // Show an alert that network call not finished fetching UserRecordID
            alertItem = AlertContext.noUserRecord
            return
        }
        
        // Create reference on UserRecord to the DDGProfile we created
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        
        showLoadingView()
        CloudKitManager.shared.batchSave(records: [userRecord, profileRecord]) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                
                switch result {
                case .success(let records):
                    print("Succesfully saved to DB")
                    // Show alert of success creating profile
                    alertItem = AlertContext.createProfileSuccess
                    // Saving saved record to currentProfileRecord
                    for record in records where record.recordType == RecordType.profile {
                        currentProfileRecord = record
                    }
                case .failure(let error):
                    print("Error saving to DB: \(error.localizedDescription)")
                    // Show alert of failure in saving data
                    alertItem = AlertContext.createProfileFailure
                    
                }
            }
        }
    }
    
    func getProfile() {
        
        // Fetching UserRecord from public db
        guard let userRecord = CloudKitManager.shared.userRecord else {
            // Show an alert that network call not finished fetching UserRecordID
            alertItem = AlertContext.noUserRecord
            return
        }
        
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
        let profileRecordID = profileReference.recordID
        
        // Fetch profile record and populate all variable to be shown in CNProfileView
        showLoadingView()
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch result {
                case .success(let record):
                    // Saving fetched record to currentProfileRecord
                    currentProfileRecord = record
                    
                    let profile = CNProfile(record: record)
                    
                    firstName = profile.firstName
                    lastName = profile.lastName
                    username = profile.username
                    avatar = profile.createAvatarImage()
                case .failure(let error):
                    print("Error fetching profile record: \(error.localizedDescription)")
                    // Show alert error fetching profile record
                    alertItem = AlertContext.unableToGetProfile
                }
            }
        }
    }
    
    func updateProfile() {
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
        print("Till here")
        
        guard let profileRecord = currentProfileRecord else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        print("Then here")
        // CloudKit will update only the fields that are being updated, although we send all the data.
        profileRecord[CNProfile.kFirstName] = firstName
        profileRecord[CNProfile.kLastName] = lastName
        profileRecord[CNProfile.kUsername] = username
        profileRecord[CNProfile.kAvatar] = avatar.convertToCKAsset()
        
        print("then here")
        CloudKitManager.shared.save(record: profileRecord) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(_):
                    alertItem = AlertContext.updateProfileSuccess
                case .failure(let error):
                    alertItem = AlertContext.updateProfileFail
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // - MARK: Private helper function
    private func showLoadingView() { isLoading = true }
    
    private func hideLoadingView() { isLoading = false }
    
    private func isValidProfile() -> Bool {
        
        guard !firstName.isEmpty,
              firstName.count <= 100,
              !lastName.isEmpty,
              lastName.count <= 100,
              !username.isEmpty,
              username.count <= 20 else { return false }
        
        return true
    }
    
    private func createProfileRecord() -> CKRecord {
        let profileRecord = CKRecord(recordType: RecordType.profile)
        
        profileRecord[CNProfile.kFirstName] = firstName
        profileRecord[CNProfile.kLastName] = lastName
        profileRecord[CNProfile.kUsername] = username
        profileRecord[CNProfile.kAvatar] = avatar.convertToCKAsset()
        
        return profileRecord
    }
}
