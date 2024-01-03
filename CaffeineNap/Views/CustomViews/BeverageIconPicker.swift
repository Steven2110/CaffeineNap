//
//  BeverageIconPicker.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 17.08.2023.
//

import SwiftUI

struct BeverageIconPicker: View {
    
    @Binding var selectedIcon: String
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private let labelIcons: [String] = [
        "coffee-cup",
        "espresso-cup",
        "black-coffee-jar",
        "tea-cup",
        "takeaway-cup",
        "bottle",
        "plastic-bottle",
        "can-bottle",
        "can",
        "bubble-tea"
    ]
    
    var body: some View {
        NavigationView {
            LazyVGrid(columns: columns) {
                ForEach(labelIcons, id: \.self) { icon in
                    RoundedRectangle(cornerRadius: 10)
                        .fill((selectedIcon == icon ? Color.brandPrimary : Color.brandSecondary).opacity(0.7))
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image(icon)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 30, maxWidth: 50)
                                .padding()
                        }
                        .onTapGesture {
                            selectedIcon = icon
                            withAnimation {
                                dismiss()
                            }
                        }
                }
            }
            .navigationTitle("Select icon")
        }
    }
}

struct BeverageIconPicker_Previews: PreviewProvider {
    static var previews: some View {
        BeverageIconPicker(selectedIcon: .constant("coffee-cup"))
    }
}
