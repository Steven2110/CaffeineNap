//
//  CNLogManager.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 20.07.2023.
//

import CloudKit

final class CNLogManager: ObservableObject {
    @Published var date: Date = Date()
    @Published var logs: [CNLog] = []
    
    func getCurrentDateStart() -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    func previousDay() {
        date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
    }
    
    func nextDay() {
        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    }
    
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
