//
//  BeverageDetailViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 14.07.2023.
//

import Foundation
import CloudKit

final class BeverageDetailViewModel: ObservableObject {
    
    var beverage: CNBeverage
    @Published var volumeCaffeineAmounts: [VolumeCaffeineAmount] = []
    @Published var isLoading: Bool = false
    @Published var alert: AlertItem?
    
    @Published var name: String
    @Published var types: [CNBeverage.DrinkType]
    @Published var icon: String
    @Published var base: CNBeverage.Base
    @Published var caffeinePer100: String
    
    // For CaffeineAmounts and Volumes
    @Published var smallVolumeType: VolumeType = .small
    @Published var smallVolume: String = ""
    @Published var smallCaffeine: String = ""
    
    @Published var mediumVolumeType: VolumeType = .medium
    @Published var mediumVolume: String = ""
    @Published var mediumCaffeine: String = ""
    
    @Published var largeVolumeType: VolumeType = .large
    @Published var largeVolume: String = ""
    @Published var largeCaffeine: String = ""
    
init(beverage: CNBeverage) {
    self.beverage = beverage
    self.name = beverage.name
    self.types = beverage.type
    self.icon = beverage.icon
    self.base = beverage.base
    self.caffeinePer100 = beverage.caffeinePer100 != nil ? String(beverage.caffeinePer100!) : ""
}
    
    @MainActor
    func fetchVolumeCaffeine() async {
        showLoadingView()
        print("GETTING")
        do {
            let dbLocation: DatabaseType = beverage.isCustom ? .privateDB : .publicDB
            volumeCaffeineAmounts = try await CloudKitManager.shared.fetchVolumeCaffeineAmounts(dbLocation, for: beverage.id)
            for volumeCaffeineAmount in volumeCaffeineAmounts {
                switch volumeCaffeineAmount.type {
                case .single, .small:
                    smallVolume = String(volumeCaffeineAmount.volume)
                    smallCaffeine = String(volumeCaffeineAmount.amount)
                case .double, .medium:
                    mediumVolume = String(volumeCaffeineAmount.volume)
                    mediumCaffeine = String(volumeCaffeineAmount.amount)
                case .triple, .large:
                    largeVolume = String(volumeCaffeineAmount.volume)
                    largeCaffeine = String(volumeCaffeineAmount.amount)
                case .unknown:
                    break
                }
            }
            hideLoadingView()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func updateBeverage(to beverageManager: CNBeverageManager) async {
        guard checkValidity() else { return }
        
        guard changed() else { return }
        
        var recordsToSave: [CKRecord] = []
        
        do {
            let beverageRecord: CKRecord = try await CloudKitManager.shared.fetchRecord(from: .privateDB, with: beverage.id)
            let (minimumCaffeine, maximumCaffeine) = getMinimumMaximumCaffeine()
            let drinkTypes = types.map { $0.rawValue }
            
            beverageRecord[CNBeverage.kName] = name
            beverageRecord[CNBeverage.kType] = drinkTypes
            print(icon)
            beverageRecord[CNBeverage.kIcon] = icon
            beverageRecord[CNBeverage.kBase] = base.rawValue
            beverageRecord[CNBeverage.kCaffeinePer100] = Double(caffeinePer100)
            beverageRecord[CNBeverage.kMinCaffeine] = minimumCaffeine
            beverageRecord[CNBeverage.kMaxCaffeine] = maximumCaffeine
            beverageRecord[CNBeverage.kIsCustom] = 1
            recordsToSave.append(beverageRecord)
            
            for volumeCaffeineAmount in volumeCaffeineAmounts {
                let _ = try? await CloudKitManager.shared.deleteRecord(id: volumeCaffeineAmount.id)
            }
            
            if smallVolume != "" && smallCaffeine != "" {
                let smallVolumeCaffeine = CKRecord(recordType: RecordType.volumeCaffeineAmount)
                smallVolumeCaffeine[VolumeCaffeineAmount.kType] = smallVolumeType.rawValue
                smallVolumeCaffeine[VolumeCaffeineAmount.kAmount] = Double(smallCaffeine)
                smallVolumeCaffeine[VolumeCaffeineAmount.kVolume] = Double(smallVolume)
                smallVolumeCaffeine[VolumeCaffeineAmount.kBeverage] = CKRecord.Reference(recordID: beverage.id, action: .deleteSelf)
                recordsToSave.append(smallVolumeCaffeine)
            } else if checkVolumeCaffeineValidity(volume: smallVolume, amount: smallCaffeine) {
                DispatchQueue.main.async { [self] in
                    alert = AlertContext.errorCaffeineVolumeField
                    isLoading = false
                }
                return
            }
            
            if mediumVolume != "" && mediumCaffeine != "" {
                let mediumVolumeCaffeine = CKRecord(recordType: RecordType.volumeCaffeineAmount)
                mediumVolumeCaffeine[VolumeCaffeineAmount.kType] = mediumVolumeType.rawValue
                mediumVolumeCaffeine[VolumeCaffeineAmount.kAmount] = Double(mediumCaffeine)
                mediumVolumeCaffeine[VolumeCaffeineAmount.kVolume] = Double(mediumVolume)
                mediumVolumeCaffeine[VolumeCaffeineAmount.kBeverage] = CKRecord.Reference(recordID: beverage.id, action: .deleteSelf)
                recordsToSave.append(mediumVolumeCaffeine)
            } else if checkVolumeCaffeineValidity(volume: mediumVolume, amount: mediumCaffeine) {
                DispatchQueue.main.async { [self] in
                    alert = AlertContext.errorCaffeineVolumeField
                    isLoading = false
                }
                return
            }
            
            if largeVolume != "" && largeCaffeine != "" {
                let largeVolumeCaffeine = CKRecord(recordType: RecordType.volumeCaffeineAmount)
                largeVolumeCaffeine[VolumeCaffeineAmount.kType] = largeVolumeType.rawValue
                largeVolumeCaffeine[VolumeCaffeineAmount.kAmount] = Double(largeCaffeine)
                largeVolumeCaffeine[VolumeCaffeineAmount.kVolume] = Double(largeVolume)
                largeVolumeCaffeine[VolumeCaffeineAmount.kBeverage] = CKRecord.Reference(recordID: beverage.id, action: .deleteSelf)
                recordsToSave.append(largeVolumeCaffeine)
            } else if checkVolumeCaffeineValidity(volume: largeVolume, amount: largeCaffeine) {
                DispatchQueue.main.async { [self] in
                    alert = AlertContext.errorCaffeineVolumeField
                    isLoading = false
                }
                return
            }
            
            do {
                let records = try await CloudKitManager.shared.batchSave(.privateDB, records: recordsToSave)
                let savedBeverageRecord = records.first(where: { $0.recordType == RecordType.beverage} )!
                let savedVolumeCaffeineAmountRecords = records.filter({ $0.recordType == RecordType.volumeCaffeineAmount })
                beverageManager.update(beverage)
                DispatchQueue.main.async { [self] in
                    beverage = CNBeverage(record: savedBeverageRecord)
                    volumeCaffeineAmounts = savedVolumeCaffeineAmountRecords.map({ VolumeCaffeineAmount(record: $0) })
                    alert = AlertContext.successSavingBeverage
                    isLoading = false
                }
            } catch {
                print("Error saving records: \(error.localizedDescription)")
                DispatchQueue.main.async { [self] in
                    alert = AlertContext.failedSavingBeverage
                    isLoading = false
                }
            }
        } catch {
            print("Error fetching beverage record")
            return
        }
    }
    
    func deleteBeverage() async -> Bool {
        guard beverage.isCustom else { return false }
        
        do {
            let _ = try await CloudKitManager.shared.deleteRecord(id: beverage.id)
            return true
        } catch {
            return false
        }
    }
    
    func changed() -> Bool {
        guard beverage.name != name,
              beverage.icon != icon,
              beverage.base != base,
              beverage.type != types,
              beverage.caffeinePer100 != Double(caffeinePer100)! else { return false }
        
        for volumeCaffeineAmount in volumeCaffeineAmounts {
            switch volumeCaffeineAmount.type {
            case .single, .small:
                if volumeCaffeineAmount.type == smallVolumeType && volumeCaffeineAmount.amount == Double(smallCaffeine)! && volumeCaffeineAmount.volume == Double(smallVolume) { return false }
            case .double, .medium:
                if volumeCaffeineAmount.type == mediumVolumeType && volumeCaffeineAmount.amount == Double(mediumCaffeine)! && volumeCaffeineAmount.volume == Double(mediumVolume) { return false }
            case .triple, .large:
                if volumeCaffeineAmount.type == largeVolumeType && volumeCaffeineAmount.amount == Double(largeCaffeine)! && volumeCaffeineAmount.volume == Double(largeVolume) { return false }
            case .unknown:
                break
            }
        }
        
        return true
    }
    
    func addBeverageTypeField() {
        types.append(.iced)
    }
    
    func removeBeverageTypeField(at index: Int) {
        types.remove(at: index)
    }
    
    private func checkVolumeCaffeineValidity(volume: String, amount: String) -> Bool {
        (volume != "" && amount == "") || (volume == "" && amount != "")
    }
    
    private func getMinimumMaximumCaffeine() -> (Int, Int) {
        var minimumCaffeine: Int = 0
        var maximumCaffeine: Int = 0
        var caffeineAmountList: [Int] = []
        print(smallCaffeine)
        if smallCaffeine != "" { caffeineAmountList.append(Int(Double(smallCaffeine)!)) }
        if mediumCaffeine != "" { caffeineAmountList.append(Int(Double(mediumCaffeine)!)) }
        if largeCaffeine != "" { caffeineAmountList.append(Int(Double(largeCaffeine)!)) }
        
        minimumCaffeine = caffeineAmountList.min()!
        maximumCaffeine = caffeineAmountList.max()!
        
        return (minimumCaffeine, maximumCaffeine)
    }
    
    private func checkValidity() -> Bool {
        guard !name.isEmpty,
              !icon.isEmpty else {
            return false
        }
        
        if caffeinePer100 == "" && base != .energyDrink {
            return false
        }
        
        return true
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
