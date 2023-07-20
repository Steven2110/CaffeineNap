//
//  AddLogBeverageListView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 10.03.2023.
//

import SwiftUI

struct AddLogBeverageListView: View {
    
    @Binding var showParentSheet: Bool
    @Environment(\.dismiss) var dismiss
    
    
    @StateObject private var vm: AddLogBeverageListViewModel = AddLogBeverageListViewModel()
    
    @EnvironmentObject private var beverageManager: CNBeverageManager
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Category.allCases, id: \.rawValue) { category in
                                CategoryButtonView(category: category, selectedCategory: $vm.selectedCategory)
                                    .onTapGesture {
                                        withAnimation(Animation.easeOut(duration: 1.0)) {
                                            vm.selectedCategory = category
                                            vm.setSelectionList(from: beverageManager)
                                        }
                                    }
                            }
                        }
                    }.padding([.horizontal, .top])
                    if vm.selectedCategory == .custom && vm.selectedList.isEmpty {
                        EmptyCustomBeverageListView()
                    } else if vm.isLoading {
                        LoadingView()
                    } else {
                        List(vm.selectedList, id: \.id) { item in
                            NavigationLink {
                                AddLogBeverageDetailView(showParentSheet: $showParentSheet, vm: AddLogBeverageDetailViewModel(beverage: item))
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
        }
        .presentationDetents([.large, .fraction(0.8)])
    }
}

struct AddLogBeverageListView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogBeverageListView(showParentSheet: .constant(true))
            .environmentObject(CNBeverageManager())
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
}
