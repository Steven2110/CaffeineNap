//
//  CNThemeToggle.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 19.04.2023.
//

import SwiftUI

struct CNThemeToggle: View {
    var text: String
    @Binding var toggle: Bool
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            ZStack {
                Capsule()
                    .frame(width:80,height:44)
                    .foregroundColor(toggle ? Color(red: 0.486, green: 0.867, blue: 0.427) : Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.604))
                ZStack{
                    Circle()
                        .frame(width:40, height:40)
                        .foregroundColor(.white)
                    Image(systemName: toggle ? "moon.fill" : "sun.max.fill")
                        .foregroundColor(toggle ? .black : .orange)
                }
                .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
                .offset(x:toggle ? 18 : -18)
                .animation(.spring(response: 0.85, dampingFraction: 1.0), value: toggle)
            }
            .onTapGesture {
                self.toggle.toggle()
            }
        }
        
    }
}

struct CNToggle_Previews: PreviewProvider {
    static var previews: some View {
        CNThemeToggle(text: "Color scheme", toggle: .constant(false))
    }
}
