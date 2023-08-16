//
//  CNBeverageDetailView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 13.06.2023.
//

import SwiftUI

struct CNBeverageDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var beverageManager: CNBeverageManager
    @State private var content: String = ""
    @State private var amount: String = ""
    @State private var showingSheet: Bool = false
    
    @ObservedObject var vm: BeverageDetailViewModel
    
    @State private var editMode: EditMode = .inactive
    
    private let smallSelection : [VolumeType] = [.small, .single]
    private let mediumSelection : [VolumeType] = [.medium, .double]
    private let largeSelection : [VolumeType] = [.large, .triple]
    
    var body: some View {
        if editMode == .active {
            Form {
                Section("Beverage General Information") {
                    CustomTextField("Beverages name", text: $vm.name)
                    iconPicker.onTapGesture{ withAnimation { showingSheet = true } }
                    CustomTextField("Icon", text: $vm.icon).autocapitalization(.none)
                    Picker("Beverage base", selection: $vm.base) {
                        ForEach(CNBeverage.Base.allCases, id: \.self) { Text(String(describing: $0)) }
                    }
                }
                Section("Beverage Type") {
                    ForEach(vm.types.indices, id: \.self) { index in
                        Picker("Beverage type \(index + 1)", selection: $vm.types[index]) {
                            ForEach(CNBeverage.DrinkType.allCases, id: \.self) { Text(String(describing: $0)) }
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
                if vm.beverage.isCustom {
                    Section {
                        Button("Delete", role: .destructive) {
                            Task {
                                if await vm.deleteBeverage() {
                                    editMode = .inactive
                                    dismiss()
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                Button("Done", role: .cancel) {
                    Task {
                        await vm.updateBeverage(to: beverageManager)
                        editMode = .inactive
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                BeverageIconPicker(selectedIcon: $vm.icon)
            }
        } else {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Caffeine content: ")
                        .bold()
                        .font(.title)
                    Text("\(vm.beverage.caffeinePer100 ?? 0.0, specifier: SPECIFIER) mg / 100 ml")
                }
                Text("Beverage base: ")
                    .bold()
                    .font(.title) + Text("\(vm.beverage.base.rawValue)").font(.title3)
                HStack {
                    Text("Beverage type:")
                        .bold()
                        .font(.title)
                    ForEach(vm.beverage.type, id: \.rawValue) { t in
                        Text(t.rawValue)
                    }
                }
                Text("Portions:")
                    .bold()
                    .font(.title)
                ZStack {
                    HStack(alignment: .lastTextBaseline) {
                        ForEach(vm.volumeCaffeineAmounts) { v in
                            VStack(spacing: 5) {
                                Image(vm.beverage.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: getImageSize(for: v.type), height: getImageSize(for: v.type))
                                HStack {
                                    Image("coffee-beans")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                    Text("\(v.amount, specifier: "%.2f") mg")
                                }
                                HStack {
                                    Image(systemName: "drop.fill").foregroundColor(.cyan)
                                    Text("\(v.volume, specifier: "%.2f") ml")
                                }
                                Text(v.type.rawValue.capitalized).font(.title3.bold())
                                
                            }.frame(maxWidth: .infinity)
                        }
                    }
                    if vm.isLoading { LoadingView(withColor: false).frame(maxWidth: .infinity, maxHeight: .infinity) }
                }
                Spacer()
            }
            .task {
                await vm.fetchVolumeCaffeine()
            }
            .toolbar {
                if vm.beverage.isCustom && !vm.isLoading {
                    Button("Edit") { editMode = .active }
                } else if vm.beverage.isCustom && vm.isLoading {
                    LoadingView()
                }
            }
            .padding()
        }
    }
}

struct CNBeverageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CNBeverageDetailView(vm: BeverageDetailViewModel(beverage: MockData.coffee[0]))
        }
    }
}

extension CNBeverageDetailView {
    private var iconPicker: some View {
        HStack {
            Text("Icon")
            Spacer()
            Image(vm.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            Image(systemName: showingSheet ? "chevron.right" : "chevron.down").foregroundColor(.secondary)
        }
    }
}
