//
//  CKRecordExt.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 13.06.2023.
//

import CloudKit

extension CKRecord {
    func convertToCNBeverage() -> CNBeverage { CNBeverage(record: self) }
}
