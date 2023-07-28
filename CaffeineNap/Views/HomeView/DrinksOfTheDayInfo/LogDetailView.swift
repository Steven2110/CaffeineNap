//
//  LogDetailView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 24.07.2023.
//

import SwiftUI

struct LogDetailView: View {
    
    @StateObject var vm: LogDetailViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    private let decimalFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    var body: some View {
        Form {
            LabeledContent {
                TextField("", text: $vm.log.beverageName)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.secondary)
            } label: {
                Text("Beverage's name")
            }
            DatePicker("Consumption", selection: $vm.log.drinkTime)
            
            Section {
                Picker("Size", selection: $vm.log.beverageSize) {
                    ForEach(VolumeType.allCases) { option in
                        Text(String(describing: option))
                    }
                }
                LabeledContent {
                    TextField("", value: $vm.log.caffeineAmount, formatter: decimalFormatter)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.secondary)
                    Text("mg")
                } label: {
                    Text("Caffeine Content")
                }
                LabeledContent {
                    TextField("", value: $vm.log.volume, formatter: decimalFormatter)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.secondary)
                    Text("mL")
                } label: {
                    Text("Water Content")
                }
            } header: {
                Label {
                    Text("Caffeine & Water Content")
                } icon: {
                    sectionHeaderIcon
                }
            }
            Section {
                Button(role: .destructive) {
                    Task {
                        await vm.deleteLog()
                        dismiss()
                    }
                } label: {
                    Text("Delete")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Edit Log")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    Task {
                        await vm.updateLog()
                        dismiss()
                    }
                } label: {
                    Label("Today", systemImage: "chevron.left").labelStyle(.titleAndIcon)
                }
            }
        }
    }
}

struct LogDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogDetailView(vm: LogDetailViewModel(log: CNLog(beverageIcon: "espresso-cup", beverageName: "Espresso", beverageAmount: 1, beverageSize: .single, caffeineAmount: 63.6, volume: 30.0, drinkTime: Date.now)))
        }
    }
}

extension LogDetailView {
    private var sectionHeaderIcon: some View {
        ZStack {
            Image("coffee-beans")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            Image(systemName: "drop.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 15)
                .foregroundColor(.cyan)
                .offset(x: 5, y: 10)
        }.padding(.bottom)
    }
}
