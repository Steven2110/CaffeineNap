//
//  CNProfile.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 22.04.2023.
//

import CloudKit

struct CNProfile {
    
    static let kUsername: String = "username"
    static let kFirstName: String = "firstName"
    static let kLastName: String = "lastName"
    static let kAvatar: String = "avatar"
    
    let id: CKRecord.ID
    
    let username: String
    let firstName: String
    let lastName: String
    let avatar: CKAsset!
    
    init(record: CKRecord) {
        id = record.recordID
        username = record["username"] as? String ?? "username"
        firstName = record["firstName"] as? String ?? "first name"
        lastName = record["lastName"] as? String ?? "last name"
        avatar = record["avatar"] as? CKAsset
    }
}
