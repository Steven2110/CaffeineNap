//
//  AddLogBeverageDetailView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 10.03.2023.
//

import SwiftUI

struct AddLogBeverageDetailView: View {
    
    @Binding var showParentSheet: Bool
    
    @State private var showAlert: Bool = false
    
    @StateObject var vm: AddLogBeverageViewModel
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                selectYourDrinkVolume
                HStack(alignment: .lastTextBaseline) {
                    ForEach(Array(vm.volumeCaffeineAmounts)) { volumeCaffeine in
                        VStack {
                            beverageIcon
                                .frame(width: getImageSize(for: volumeCaffeine.type), height: getImageSize(for: volumeCaffeine.type))
                            HStack {
                                Image(systemName: "drop.fill").foregroundColor(.cyan)
                                Text("\(volumeCaffeine.volume, specifier: "%.1f") ml")
                            }
                        }
                        .frame(height: 150, alignment: .bottom)
                        .padding()
                        .onTapGesture { vm.selectedVolume = volumeCaffeine }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isSelected(selectedVolume: vm.selectedVolume, compare: volumeCaffeine) ? .blue : .white)
                        )
                    }
                }.frame(maxWidth: .infinity)
                HStack {
                    DatePicker("", selection: $vm.timeDrink, displayedComponents: .hourAndMinute)
                        .frame(width: 100)
                        .labelsHidden()
                    Stepper("Amount: \(vm.amount, specifier: vm.specifier)x") { vm.incrementAmount() } onDecrement: { vm.decrementAmount() }.font(.title2)
                }.padding(.horizontal, 30)
                Divider()
                HStack(spacing: 5) {
                    waterIcon
                    Text("\((vm.selectedVolume?.volume ?? 0.0) * Double(vm.amount), specifier: "%.1f") ml").font(.title3)
                }
                .frame(maxWidth: .infinity)
                .padding(.top)
                HStack(spacing: 5) {
                    caffeineIcon
                    Text("\((vm.selectedVolume?.amount ?? 0.0) * Double(vm.amount), specifier: "%.2f") mg").font(.title)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)
                addLogButton
                Spacer()
            }
            if vm.isLoading { LoadingView(color: .gray) }
        }
        .frame(maxHeight: .infinity)
        .task {
            await vm.fetchVolumeCaffeine()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text("Please select your drink's volume, then add again."),
                dismissButton: .default(Text("Ok"))
            )
        }
        .navigationTitle(vm.beverage.name)
    }
}

struct AddLogBeverageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddLogBeverageDetailView(showParentSheet: .constant(true), vm: AddLogBeverageViewModel(beverage: MockData.coffee[0]))
        }
    }
}

extension AddLogBeverageDetailView {
    private var beverageIcon: some View {
        Image(vm.beverage.icon)
            .resizable()
            .scaledToFit()
    }
    
    private var selectYourDrinkVolume: some View {
        Text("Choose your drink's volume")
            .font(.title)
            .bold()
            .padding()
    }
    
    private var caffeineIcon: some View {
        Image("home-icon")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .foregroundColor(.brandPrimary)
    }
    
    private var waterIcon: some View {
        Image(systemName: "drop.fill")
            .foregroundColor(.cyan)
    }
    
    private var addLogButton: some View {
        HStack {
            Spacer()
            Button {
                if isValid(selectedVolume: vm.selectedVolume) {
                    Task {
                        await vm.addLog()
                        showParentSheet = false
                    }
                } else {
                    showAlert = true
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                Text("Add To Log")
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.brandDarkBrown)
            .clipShape(Capsule())
            Spacer()
        }
    }
    
    private func isSelected(selectedVolume: VolumeCaffeineAmount?, compare: VolumeCaffeineAmount) -> Bool {
        guard let selectedVolume = selectedVolume else { return false }
        return selectedVolume.id == compare.id
    }
    
    private func isValid(selectedVolume: VolumeCaffeineAmount?) -> Bool {
        guard selectedVolume != nil else { return false }
        return true
    }
}
