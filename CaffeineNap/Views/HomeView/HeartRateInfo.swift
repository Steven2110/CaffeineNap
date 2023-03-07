//
//  HeartRateInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct HeartRateInfo: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.brandSecondary)
            HStack(alignment: .top) {
                heartIcon
                VStack(alignment: .leading, spacing: 7) {
                    Text("Resting HR").font(.system(size: 12, weight: .semibold))
                    HStack(alignment: .firstTextBaseline,spacing: 5) {
                        Text("90").font(.system(size: 24, weight: .heavy))
                        Text("BPM").font(.system(size: 12, weight: .bold))
                    }
                    Text("Peak Resting HR").font(.system(size: 12, weight: .semibold))
                    HStack(alignment: .firstTextBaseline,spacing: 5) {
                        Text("90").font(.system(size: 24, weight: .heavy))
                        Text("BPM").font(.system(size: 12, weight: .bold))
                    }
                }
                
            }
        }.frame(width: 160, height: 160)
    }
}

struct HeartRateInfo_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateInfo()
    }
}

extension HeartRateInfo {    
    private var heartIcon: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 24)
            .foregroundColor(.red)
    }
}
