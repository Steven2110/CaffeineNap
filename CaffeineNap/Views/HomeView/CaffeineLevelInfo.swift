//
//  CaffeineLevelInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct CaffeineLevelInfo: View {
    var body: some View {
        ZStack {
            base
            VStack(alignment: .leading) {
                Text("Caffeine Level Overtime").font(.system(size: 14, weight: .bold))
                // For now we put placeholder for charts, soon we will add SwiftCharts
                Image("chart-placeholder")
                    .resizable()
                    .frame(width: 375, height: 140)
                    .cornerRadius(10)
            }
        }
    }
}

struct CaffeineLevelInfo_Previews: PreviewProvider {
    static var previews: some View {
        CaffeineLevelInfo()
    }
}

extension CaffeineLevelInfo {
    private var base: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(width: 410, height: 190)
            .foregroundColor(.brandSecondary)
    }
}
