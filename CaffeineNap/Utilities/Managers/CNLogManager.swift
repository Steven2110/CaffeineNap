//
//  CNLogManager.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 20.07.2023.
//

import CloudKit

final class CNLogManager: ObservableObject {
    @Published var logs: [CNLog] = []
    
    func sort() {
        logs.sort { $0.drinkTime > $1.drinkTime }
    }
    func addLog(record: CKRecord) {
        DispatchQueue.main.async { [self] in
            logs.append(CNLog(record: record))
            sort()
        }
    }
}
