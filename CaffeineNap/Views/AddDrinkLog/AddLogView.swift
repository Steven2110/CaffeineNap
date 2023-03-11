//
//  AddLogView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 10.03.2023.
//

import SwiftUI

struct AddLogView: View {
    
    @Binding var showParentSheet: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedCategory: Category = .all
    @State private var selectedList: [Beverage] = [Beverage]()
    @State private var selectedDetents: PresentationDetent = .large
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(Category.allCases, id: \.rawValue) { category in
                            Text(category.rawValue)
                                .foregroundColor(category == selectedCategory ? Color.brandSecondary : Color.black)
                                .frame(minWidth: 75)
                                .padding()
                                .background(category == selectedCategory ? Color.brandPrimary : Color.brandSecondary)
                                .cornerRadius(50)
                                .onTapGesture {
                                    withAnimation(Animation.easeOut(duration: 1.0)) {
                                        selectedCategory = category
                                        selectedList = getSelectedList(selectedCategory: selectedCategory)
                                    }
                                }
                        }
                    }
                }.padding([.horizontal, .top])
                if selectedCategory == .custom && selectedList.isEmpty {
                    VStack {
                        Text("Uh oh your custom list is empty...")
                        Text("Let's add some items 😌")
                        NavigationLink {
                            Text("Page for adding new item")
                        } label: {
                            Text("Add Item")
                                .padding()
                                .foregroundColor(.white)
                                .frame(width: 130, height: 40)
                                .background(Color.brandPrimary)
                                .cornerRadius(10)
                        }
                    }.frame(maxHeight: .infinity)
                } else {
                    List(selectedList, id: \.id) { item in
                        NavigationLink {
                            DrinkAddLogView(showParentSheet: $showParentSheet, item: item)
                                .toolbar {
                                    Button {
                                        dismiss()
                                    } label: {
                                        XDismissButton()
                                    }

                                }
                                .onAppear {
                                    withAnimation {
                                        selectedDetents = .medium
                                    }
                                }
                        } label: {
                            Image(item.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            VStack(alignment: .leading) {
                                Text(item.name)
                                Text("\(getRangeCaffeine(item.volumeAndCaffeineAmount)) mg")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }.padding(.leading)
                        }
                        .listRowBackground(Color.brandSecondary)
                    }
                }
            }
            .navigationTitle("Add Log")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    XDismissButton()
                }
            }
        }.onAppear {
            selectedList = getSelectedList(selectedCategory: selectedCategory)
        }
        .presentationDetents([.large, .fraction(0.8)])
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogView(showParentSheet: .constant(true))
    }
}

extension AddLogView {
    private func getSelectedList(selectedCategory: Category) -> [Beverage] {
        switch(selectedCategory) {
        case .all:
            return MockData.customDrinks + MockData.coffee + MockData.tea + MockData.sodaED // + MockData.medicine
        case .custom:
            return MockData.customDrinks
        case .coffee:
            return MockData.coffee
        case .tea:
            return MockData.tea
        case .sodaED:
            return MockData.sodaED
//        case .medicine:
//            return MockData.medicine
        }
    }
    
    private func getRangeCaffeine(_ caffeineData: [VolumeCaffeineAmount]) -> String {
        var range: String = ""
        
        let minCaffeine = caffeineData.min{ $0.amount < $1.amount }
        let minCaffeineStr = String(format: "%.0f", minCaffeine!.amount)
        let maxCaffeine = caffeineData.max{ $0.amount < $1.amount }
        let maxCaffeineStr = String(format: "%.0f", maxCaffeine!.amount)
        
        if minCaffeine?.amount == maxCaffeine?.amount {
            range = "\(minCaffeineStr)"
        } else {
            range = "\(minCaffeineStr) - \(maxCaffeineStr)"
        }
        
        return range
    }
}
