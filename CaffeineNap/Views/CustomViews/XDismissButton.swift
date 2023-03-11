//
//  XDismissButton.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 10.03.2023.
//

import SwiftUI

struct XDismissButton: View {
    var body: some View {
        Image(systemName: "xmark.circle")
            .foregroundColor(.brandDarkBrown)
            .imageScale(.large)
            .frame(width: 50, height: 50)
    }
}

struct XDismissButton_Previews: PreviewProvider {
    static var previews: some View {
        XDismissButton()
    }
}
