//
//  CNBeveragesListView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct CNBeveragesListView: View {
    
    @StateObject private var vm: BeverageListViewModel = BeverageListViewModel()
    @EnvironmentObject private var beverageManager: CNBeverageManager
    
    var body: some View {
        VStack{
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        CategoryButtonView(category: category, selectedCategory: $vm.selectedCategory)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 1.0)) {
                                    vm.selectedCategory = category
                                    vm.setSelectionList(from: beverageManager)
                                }
                            }
                    }
                }
            }.padding([.horizontal, .top])
            ZStack {
                if !vm.selectedList.isEmpty {
                    List(vm.selectedList, id: \.id) { item in
                        NavigationLink {
                            CNBeverageDetailView(vm: BeverageDetailViewModel(beverage: item))
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
                } else if vm.selectedList.isEmpty && vm.selectedCategory == .custom {
                    EmptyCustomBeverageListView()
                } else if vm.isLoading {
                  LoadingView()
                } else {
                    EmptyView().frame(maxHeight: .infinity)
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
                if beverageManager.beverages.isEmpty {
                    vm.showLoadingView()
                    do {
                        beverageManager.beverages = try await CloudKitManager.shared.fetchBeveragesList()
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                    vm.hideLoadingView()
                }
                vm.setSelectionList(from: beverageManager, animation: false)
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
