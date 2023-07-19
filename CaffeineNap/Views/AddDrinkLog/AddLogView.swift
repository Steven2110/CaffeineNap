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
    @State private var selectedList: [CNBeverage] = [CNBeverage]()
    
    @EnvironmentObject private var beverageManager: CNBeverageManager
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Category.allCases, id: \.rawValue) { category in
                                CategoryButtonView(category: category, selectedCategory: $selectedCategory)
                                    .onTapGesture {
                                        withAnimation(Animation.easeOut(duration: 1.0)) {
                                            selectedCategory = category
//                                            selectedList = getSelectedList(selectedCategory: selectedCategory)
                                        }
                                    }
                            }
                        }
                    }.padding([.horizontal, .top])
                    if selectedCategory == .custom && selectedList.isEmpty {
                        EmptyCustomBeverageListView()
                    } else {
                        List(selectedList, id: \.id) { item in
                            NavigationLink {
                                DrinkAddLogView(showParentSheet: $showParentSheet, vm: BeverageDetailViewModel(beverage: item))
                                    .toolbar {
                                        Button { dismiss() } label: {
                                            XDismissButton()
                                        }
                                    }
                            } label: {
                                ListRowView(item: item)
                            }
                            .listRowBackground(Color.brandSecondary)
                        }
                    }
                }
                NavigationLink(destination: CNCustomBeverageAddView()) {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .clipShape(Circle())
                }.padding()
            }
            .navigationTitle("Add Log")
            .toolbar {
                Button { dismiss() } label: {
                    XDismissButton()
                }
            }
            .onAppear {
                selectedList = beverageManager.beverages
            }
        }
        .presentationDetents([.large, .fraction(0.8)])
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogView(showParentSheet: .constant(true))
    }
}

struct CategoryButtonView: View {
    
    var category: Category
    @Binding var selectedCategory: Category
    
    var body: some View {
        Text(category.rawValue)
            .foregroundColor(category == selectedCategory ? Color.brandSecondary : Color.black)
            .frame(minWidth: 75)
            .padding()
            .background(category == selectedCategory ? Color.brandPrimary : Color.brandSecondary)
            .cornerRadius(50)
    }
}

struct ListRowView: View {
    
    var item: CNBeverage
    
    var body: some View {
        Image(item.icon)
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 25)
        VStack(alignment: .leading) {
            Text(item.name)
            Text("\(getCaffeineRange()) mg")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }.padding(.leading)
    }
    
    private func getCaffeineRange() -> String {
        "\(item.minCaffeine) - \(item.maxCaffeine)"
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

extension AddLogView {
    private func getSelectedList(selectedCategory: Category) -> [CNBeverage] {
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
}
