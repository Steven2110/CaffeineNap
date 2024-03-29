//
//  ViewExt.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 09.03.2023.
//

import SwiftUI

extension View {
    func profileNameStyle() -> some View {
        self.modifier(ProfileNameText())
    }
    
    func usernameStyle() -> some View {
        self.modifier(UsernameText())
    }
    
    func drinkOfTheDayInfoStyle() -> some View {
        self.modifier(DrinkOfTheDayInfoText())
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func animatingDoubleOverlay(alignment: Alignment = .center, for number: Double, specifier: String = "%.0f", color: Color? = nil, smallFont: Bool = false, measurementUnit: String = "") -> some View {
        self.modifier(AnimatableDecimalNumberModifier(alignment: alignment, number: number, specifier: specifier, color: color, smallFont: smallFont, measurementUnit: measurementUnit))
    }
    
    func animatingOverlay(alignment: Alignment = .center, for number: Int, color: Color? = nil, font: Font = .body, fontWeight: Font.Weight, measurementUnit: String, mUnitFont: Font) -> some View {
        self.modifier(AnimatableNumberModifier(alignment: alignment, number: number, color: color, font: font, fontWeight: fontWeight, measurementUnit: measurementUnit, mUnitFont: mUnitFont))
    }
}
