//
//  CustomModifiers.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 09.03.2023.
//

import SwiftUI

struct ProfileNameText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 25, weight: .bold))
            .foregroundColor(.brandPrimary)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
}

struct UsernameText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 90)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.brandPrimary)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    }
}

struct DrinkOfTheDayInfoText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12))
            .foregroundColor(.brandDarkBrown)
    }
}
