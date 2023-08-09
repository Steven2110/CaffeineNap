//
//  AnimatableNumberModifier.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 01.08.2023.
//

import SwiftUI

struct AnimatableDecimalNumberModifier: AnimatableModifier {
    
    var alignment: Alignment
    var number: Double
    var specifier: String
    var color: Color?
    var smallFont: Bool
    var measurementUnit: String
    
    var animatableData: Double {
        get { number }
        set { number = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment, content: {
                Text("\(number, specifier: specifier)\(measurementUnit)")
                    .font(smallFont ? .system(size: 14) : .body )
                    .foregroundColor(color != nil ? color : .black)
            })
    }
}
