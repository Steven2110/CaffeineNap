//
//  EmptyCustomBeverageListView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 14.07.2023.
//

import SwiftUI

struct EmptyCustomBeverageListView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Uh oh your custom list is empty...")
            Text("Let's add some items 😌")
            NavigationLink {
                CNCustomBeverageAddView()
            } label: {
                Text("Add Item")
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: 130, height: 40)
                    .background(Color.brandPrimary)
                    .cornerRadius(10)
            }
        }.frame(maxHeight: .infinity)
    }
}

struct EmptyCustomBeverageListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyCustomBeverageListView()
    }
}
