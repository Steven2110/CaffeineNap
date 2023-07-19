//
//  CNBeverageDetailView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 13.06.2023.
//

import SwiftUI

struct CNBeverageDetailView: View {
    
    @State private var content: String = ""
    @State private var amount: String = ""
    
    @ObservedObject var vm: BeverageDetailViewModel
    
    @Environment(\.editMode) private var editMode
    
    var body: some View {
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
        .onAppear {
            content = String(vm.beverage.caffeinePer100 ?? 0.0)
        }
        .task {
            await vm.fetchVolumeCaffeine()
        }
        .toolbar {
            EditButton()
        }
        .padding()
    }
}

struct CNBeverageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CNBeverageDetailView(vm: BeverageDetailViewModel(beverage: MockData.coffee[0]))
        }
    }
}
