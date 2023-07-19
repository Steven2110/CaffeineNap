//
//  CustomTextField.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 12.07.2023.
//

import SwiftUI

struct CustomTextField: View {
    
    var title: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField(title, text: $text)
                .overlay {
                    if !text.isEmpty {
                        HStack {
                            Spacer()
                            Button {
                                text = ""
                            } label: {
                                Image(systemName: "multiply.circle.fill")
                            }
                        }
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                    }
                }
        }
    }
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        self._text = text
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField("Beverage Volume (ml)", text: .constant("150"))
    }
}
