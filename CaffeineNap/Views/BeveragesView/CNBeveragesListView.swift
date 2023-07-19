//
//  CNBeveragesListView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct CNBeveragesListView: View {    
    
    @State private var selectedCategory: Category = .all
    @State private var selectedList: [CNBeverage] = [CNBeverage]()
    
    @StateObject private var vm: BeverageListViewModel = BeverageListViewModel()
    @EnvironmentObject private var beverageManager: CNBeverageManager
    
    var body: some View {
        VStack{
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        CategoryButtonView(category: category, selectedCategory: $selectedCategory)
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 1.0)) {
                                    vm.setSelectionList(with: category, from: beverageManager)
                                }
                            }
                    }
                }
            }.padding([.horizontal, .top])
            ZStack {
                if !vm.selectedList.isEmpty {
                    List(vm.selectedList, id: \.id) { item in
                        NavigationLink {
                            Text("Beverage Detail View")
                                .navigationTitle(item.name)
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            Image(item.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text(item.name)
                        }
                        .listRowBackground(Color.brandSecondary)
                        .swipeActions {
                            if item.isCustom {
                                Button(role: .destructive) {
                                    Task { await vm.deleteBeverage(item, on: beverageManager) }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                } else if vm.selectedList.isEmpty && selectedCategory == .custom {
                    EmptyCustomBeverageListView()
                } else if vm.isLoading {
                  LoadingView()
                } else {
                    Text("NETWORK ERROR")
                }
            }
        }
        .toolbar{
            NavigationLink(destination: Text("Add Custom Drink View")) {
                Image(systemName: "plus.circle")
            }
        }
        .onAppear {
            Task {
                vm.showLoadingView()
                if beverageManager.beverages.isEmpty {
                    do {
                        beverageManager.beverages = try await CloudKitManager.shared.fetchBeveragesList()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                vm.setSelectionList(with: selectedCategory, from: beverageManager)
                vm.hideLoadingView()
            }
        }
        .navigationTitle("Beverages")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CNBeveragesListView_Previews: PreviewProvider {
    static var previews: some View {
        CNBeveragesListView()
    }
}
