//
//  LoadingView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 04.06.2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.brandSecondary
                .opacity(0.75)
                .ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.brandPrimary))
                .scaleEffect(2.0)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
