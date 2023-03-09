//
//  CNBeveragesListView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct CNBeveragesListView: View {    
    enum Category: String, CaseIterable {
        case all = "All"
        case custom = "Custom Drink"
        case coffee = "Coffee"
        case tea = "Tea"
        case sodaED = "Soda & Energy drink"
//        case medicine = "Medicine"
    }
    
    @State private var selectedCategory: Category = .all
    @State private var selectedList: [Beverage] = [Beverage]()
    
    var body: some View {
        NavigationView {
            VStack{
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
                if selectedList.isEmpty && selectedCategory == .custom {
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
                } else if selectedList.isEmpty && selectedCategory != .custom {
                    VStack {
                        Text("Network call error!")
                    }
                } else {
                    List(selectedList, id: \.id) { item in
                        NavigationLink {
                            Text("Pages for editing: \(item.name)")
                        } label: {
                            Image(item.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text(item.name)
                        }
                        .listRowBackground(Color.brandSecondary)
                    }
                }
            }
            .toolbar{
                NavigationLink {
                    Text("Page for adding new item")
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .navigationTitle("Beverages")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            selectedList = getSelectedList(selectedCategory: selectedCategory)
        }
    }
}

struct CNBeveragesListView_Previews: PreviewProvider {
    static var previews: some View {
        CNBeveragesListView()
    }
}

extension CNBeveragesListView {
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
}
