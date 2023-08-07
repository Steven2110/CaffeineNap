//
//  EmptyDrinksOfTheDayInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.08.2023.
//

import SwiftUI

struct EmptyDrinksOfTheDayInfo: View {
    
    @State private var isPresentingAddSheet: Bool = false
    
    var body: some View {
        VStack {
            Text("😴").font(.system(size: 100))
            Text("No records of beverage found in the last 24 hours.\nYou haven't drunk any caffeinated beverages today.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            Button {
                isPresentingAddSheet.toggle()
            } label: {
                Text("Add now!")
                    .padding()
                    .foregroundColor(.brandSecondary)
                    .background(Color.brandPrimary.cornerRadius(10))
            }
        }.sheet(isPresented: $isPresentingAddSheet) {
            AddLogBeverageListView(showParentSheet: $isPresentingAddSheet)
        }
    }
}

struct EmptyDrinksOfTheDayInfo_Previews: PreviewProvider {
    static var previews: some View {
        EmptyDrinksOfTheDayInfo()
    }
}
