//
//  HealthKitManager.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 08.08.2023.
//

import HealthKit

final class HealthKitManager {
    
    static let shared: HealthKitManager = HealthKitManager()
    
    private var healthStore = HKHealthStore()
    
    private let heartRateUnit = HKUnit(from: "count/min")
    private let bloodOxygenUnit = HKUnit(from: "%")
    
    private init() { }
    
    func autorizeHealthKit(readData: @escaping () -> Void) {
        // Used to define the identifiers that create quantity type objects.
        let healthKitTypes: Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!]
        // Requests permission to save and read the specified data types.
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { success, error in
            if success {
                readData()
            } else if error != nil {
                
            }
        }
    }
    
    func readHeartRate(forToday: Date, completion: @escaping (Int) -> Void) {
        let startOfDay = Calendar.current.startOfDay(for: forToday)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        let hrType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
        let query = HKSampleQuery(sampleType: hrType, predicate: predicate, limit: 25, sortDescriptors: sortDescriptors) { _, results, error in
            guard error == nil else {
                completion(0)
                return
            }
            
            guard let latestHRData = results!.first as? HKQuantitySample else {
                completion(0)
                return
            }
            
            let latestHR = latestHRData.quantity.doubleValue(for: self.heartRateUnit)
            
            completion(Int(latestHR))
        }
        
        healthStore.execute(query)
    }
    
    func readBloodOxygen(forToday: Date, completion: @escaping (Int) -> Void) {
        let startOfDay = Calendar.current.startOfDay(for: forToday)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        let boType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!
        
        let query = HKSampleQuery(sampleType: boType, predicate: predicate, limit: 25, sortDescriptors: sortDescriptors) { _, results, error in
            guard error == nil else {
                completion(0)
                return
            }
            
            guard let latestBOData = results!.first as? HKQuantitySample else {
                completion(0)
                return
            }
            
            let latestBO = latestBOData.quantity.doubleValue(for: self.bloodOxygenUnit) * 100
            
            completion(Int(latestBO))
        }
        
        healthStore.execute(query)
    }
}
