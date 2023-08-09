//
//  AnimatableNumberModifier.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 09.08.2023.
//

import SwiftUI

struct AnimatableNumberModifier: AnimatableModifier {
    
    var alignment: Alignment
    var number: Int
    var color: Color?
    var font: Font
    var fontWeight: Font.Weight
    var measurementUnit: String
    var mUnitFont: Font
    
    var animatableData: Int {
        get { number }
        set { number = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment, content: {
                HStack(alignment: .firstTextBaseline, spacing: 5){
                    Text("\(number)")
                        .font(font)
                        .fontWeight(fontWeight)
                        .foregroundColor(color != nil ? color : .black)
                        .minimumScaleFactor(0.7)
                    Text(measurementUnit).font(mUnitFont)
                }
            })
    }
}
