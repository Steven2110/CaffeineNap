//
//  DrinkOfTheDayInfoBox.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 28.07.2023.
//

import SwiftUI

struct DrinkOfTheDayInfoBox<Content: View>: View {
    
    @ViewBuilder var text: Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 55, height: 20)
                .foregroundColor(.baseGray)
            text
        }
    }
}
