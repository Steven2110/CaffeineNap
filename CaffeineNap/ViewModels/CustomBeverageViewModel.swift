//
//  CustomBeverageViewModel.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 12.07.2023.
//

import CloudKit

class CustomBeverageViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var types: [CNBeverage.DrinkType] = [.hot]
    @Published var icon: String = "espresso-cup"
    @Published var base: CNBeverage.Base = .coffee
    @Published var caffeinePer100: String = ""
    
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
    
    @Published var alert: AlertItem?
    @Published var isLoading: Bool = false
    
    init() { }
    
    func addBeverageTypeField() {
        types.append(.iced)
    }
    
    func removeBeverageTypeField(at index: Int) {
        types.remove(at: index)
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
    
    func save(to beverageManager: CNBeverageManager) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        guard checkValidity() else {
            DispatchQueue.main.async { [self] in
                alert = AlertContext.errorBeverageField
                isLoading = false
            }
            return
        }
        
        let drinkTypes = types.map { $0.rawValue }
        
        var recordsToSave: [CKRecord] = []
        let beverage: CKRecord = CKRecord(recordType: RecordType.beverage)
        let (minimumCaffeine, maximumCaffeine) = getMinimumMaximumCaffeine()
        
        beverage[CNBeverage.kName] = name
        beverage[CNBeverage.kType] = drinkTypes
        beverage[CNBeverage.kIcon] = icon
        beverage[CNBeverage.kBase] = base.rawValue
        beverage[CNBeverage.kCaffeinePer100] = Double(caffeinePer100)
        beverage[CNBeverage.kMinCaffeine] = minimumCaffeine
        beverage[CNBeverage.kMaxCaffeine] = maximumCaffeine
        beverage[CNBeverage.kIsCustom] = 1
        recordsToSave.append(beverage)
        
        if smallVolume != "" && smallCaffeine != "" {
            let smallVolumeCaffeine = CKRecord(recordType: RecordType.volumeCaffeineAmount)
            smallVolumeCaffeine[VolumeCaffeineAmount.kType] = smallVolumeType.rawValue
            smallVolumeCaffeine[VolumeCaffeineAmount.kAmount] = Double(smallCaffeine)
            smallVolumeCaffeine[VolumeCaffeineAmount.kVolume] = Double(smallVolume)
            smallVolumeCaffeine[VolumeCaffeineAmount.kBeverage] = CKRecord.Reference(recordID: beverage.recordID, action: .deleteSelf)
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
            mediumVolumeCaffeine[VolumeCaffeineAmount.kBeverage] = CKRecord.Reference(recordID: beverage.recordID, action: .deleteSelf)
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
            largeVolumeCaffeine[VolumeCaffeineAmount.kBeverage] = CKRecord.Reference(recordID: beverage.recordID, action: .deleteSelf)
            recordsToSave.append(largeVolumeCaffeine)
        } else if checkVolumeCaffeineValidity(volume: largeVolume, amount: largeCaffeine) {
            DispatchQueue.main.async { [self] in
                alert = AlertContext.errorCaffeineVolumeField
                isLoading = false
            }
            return
        }
        
        do {
            print(recordsToSave)
            let records = try await CloudKitManager.shared.batchSave(.privateDB, records: recordsToSave)
            print("RECORD")
            print(records)
            print("Done save")
            beverageManager.add(CNBeverage(record: beverage))
            DispatchQueue.main.async { [self] in
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
    }
    
    func checkVolumeCaffeineValidity(volume: String, amount: String) -> Bool {
        (volume != "" && amount == "") || (volume == "" && amount != "")
    }
    
    func checkValidity() -> Bool {
        guard !name.isEmpty,
              !icon.isEmpty else {
            return false
        }
        
        if caffeinePer100 == "" && base != .energyDrink {
            return false
        }
        
        return true
    }
}
