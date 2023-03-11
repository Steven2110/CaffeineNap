//
//  DrinkAddLogView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 10.03.2023.
//

import SwiftUI

struct DrinkAddLogView: View {
    
    @Binding var showParentSheet: Bool
    
    var item: Beverage
    
    @State private var selectedVolume: VolumeCaffeineAmount?
    @State private var amount: Int = 1
    @State private var timeDrink: Date = Date.now
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Choose your drink's volume")
                .font(.title)
                .bold()
                .padding()
            HStack(alignment: .lastTextBaseline) {
                Spacer()
                ForEach(Array(item.volumeAndCaffeineAmount)) { volumeCaffeine in
                    VStack {
                        Image(item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: getImageSize(for: volumeCaffeine.type), height: getImageSize(for: volumeCaffeine.type))
                        HStack {
                            Image(systemName: "drop.fill").foregroundColor(.cyan)
                            Text("\(volumeCaffeine.volume, specifier: "%.1f") ml")
                        }
                    }
                    .frame(height: 150,alignment: .bottom)
                    .padding()
                    .onTapGesture {
                        selectedVolume = volumeCaffeine
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected(selectedVolume: selectedVolume, compare: volumeCaffeine) ? .blue : .white)
                    )
                }
                Spacer()
            }
            HStack {
                DatePicker("", selection: $timeDrink, displayedComponents: .hourAndMinute).frame(width: 100)
                    .labelsHidden()
                Stepper("Amount: \(amount)x") {
                    amount += 1
                } onDecrement: {
                    amount -= 1
                }
                .font(.title2)
            }.padding(.horizontal, 30)
            Divider()
            HStack(spacing: 5) {
                Spacer()
                Image("home-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.brandPrimary)
                Text("\(selectedVolume?.amount ?? 0.0, specifier: "%.2f") mg").font(.title)
                Spacer()
            }.padding()
            HStack {
                Spacer()
                Button {
                    if isValid(selectedVolume: selectedVolume) {
                        showParentSheet = false
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
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text("Please select your drink's volume, then add again."),
                dismissButton: .default(Text("Ok"))
            )
        }
        .navigationTitle(item.name)
        .frame(maxHeight: .infinity)
    }
}

struct DrinkAddLogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DrinkAddLogView(showParentSheet: .constant(true), item: MockData.coffee[0])
        }
    }
}

extension DrinkAddLogView {
    private func getImageSize(for size: VolumeType) -> Double {
        switch size {
        case .single:
            return 30.0
        case .double:
            return 45.0
        case .triple:
            return 60.0
        case .small:
            return 30.0
        case .medium:
            return 45.0
        case .large:
            return 60.0
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
