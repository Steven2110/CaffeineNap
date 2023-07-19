//
//  CNCustomBeverageAddView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 06.07.2023.
//

import SwiftUI
import CloudKit

struct CNCustomBeverageAddView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var vm: CustomBeverageViewModel = CustomBeverageViewModel()
    @EnvironmentObject private var beverageManager: CNBeverageManager
    
    private let smallSelection : [VolumeType] = [.small, .single]
    private let mediumSelection : [VolumeType] = [.medium, .double]
    private let largeSelection : [VolumeType] = [.large, .triple]
    
    var body: some View {
        ZStack {
            if vm.isLoading { LoadingView(withColor: false) }
            Form {
                Section("Beverage General Information") {
                    CustomTextField("Beverages name", text: $vm.name)
                    CustomTextField("Icon", text: $vm.icon).autocapitalization(.none)
                    Picker("Beverage base", selection: $vm.base) {
                        ForEach(CNBeverage.Base.allCases, id: \.self) { option in
                            Text(String(describing: option))
                        }
                    }
                }
                Section("Beverage Type") {
                    ForEach(vm.types.indices, id: \.self) { index in
                        Picker("Beverage type \(index + 1)", selection: $vm.types[index]) {
                            ForEach(CNBeverage.DrinkType.allCases, id: \.self) { option in
                                Text(String(describing: option))
                            }
                        }
                        .swipeActions {
                            if index > 0 {
                                Button(role: .destructive) {
                                    vm.removeBeverageTypeField(at: index)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    Button("Add") {
                        vm.addBeverageTypeField()
                    }.disabled(vm.types.count > 1)
                }
                Section("Caffeine Per 100 ml") {
                    CustomTextField("Caffeine per 100 ml", text: $vm.caffeinePer100).keyboardType(.decimalPad)
                }
                // MARK: - Small or Single beverage volume types
                Section("Small Beverage") {
                    Picker("Beverage volume types", selection: $vm.smallVolumeType) {
                        ForEach(smallSelection, id: \.self) { option in
                            Text(String(describing: option))
                        }
                    }
                    CustomTextField("Beverage volume", text: $vm.smallVolume).keyboardType(.decimalPad)
                    CustomTextField("Caffeine amounts", text: $vm.smallCaffeine).keyboardType(.decimalPad)
                }
                // MARK: - Medium or Double beverage volume types
                Section("Medium Beverage"){
                    Picker("Beverage volume types", selection: $vm.mediumVolumeType) {
                        ForEach(mediumSelection, id: \.self) { option in
                            Text(String(describing: option))
                        }
                    }
                    CustomTextField("Beverage volume", text: $vm.mediumVolume).keyboardType(.decimalPad)
                    CustomTextField("Caffeine amounts", text: $vm.mediumCaffeine).keyboardType(.decimalPad)
                }
                // MARK: - Large or Triple beverage volume types
                Section("Large Beverage"){
                    Picker("Beverage volume types", selection: $vm.largeVolumeType) {
                        ForEach(largeSelection, id: \.self) { option in
                            Text(String(describing: option))
                        }
                    }
                    CustomTextField("Beverage volume", text: $vm.largeVolume).keyboardType(.decimalPad)
                    CustomTextField("Caffeine amounts", text: $vm.largeCaffeine).keyboardType(.decimalPad)
                }
            }
        }
        .navigationTitle("Add Custom Beverage")
        .alert(item: $vm.alert, content: { alert in
            Alert(title: alert.title, message: alert.message, dismissButton: .default(Text("Ok")) {
                dismiss()
            })
        })
        .toolbar {
            Button ("Save") {
                Task {
                    await vm.save(to: beverageManager)
                }
            }
        }
    }
}

struct AddCustomBeverageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CNCustomBeverageAddView()
        }
    }
}
