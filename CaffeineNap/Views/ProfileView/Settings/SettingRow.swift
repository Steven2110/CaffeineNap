//
//  SettingRow.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 09.03.2023.
//

import SwiftUI

struct SettingRow<Content: View>: View {
    
    var imageName: String
    var color: Color
    var text: String
    @ViewBuilder var destination: Content
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
           Image(systemName: imageName)
                .foregroundColor(.white)
                .padding(7)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Text(text)
        }
    }
}
