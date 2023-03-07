//
//  BloodOxygenInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct BloodOxygenInfo: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25).foregroundColor(.brandSecondary.opacity(0.5))
            HStack(alignment: .top) {
                lungsIcon
                VStack(alignment: .leading, spacing: 7) {
                    Text("Blood Oxygen").font(.system(size: 12, weight: .semibold))
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        Text("98").font(.system(size: 24, weight: .heavy))
                        Text("%").font(.system(size: 12, weight: .bold))
                    }
                    Text("Peak Resting HR").font(.system(size: 12, weight: .semibold))
                    HStack(alignment: .firstTextBaseline,spacing: 5) {
                        Text("99").font(.system(size: 24, weight: .heavy))
                        Text("%").font(.system(size: 12, weight: .bold))
                    }
                }
                
            }
        }.frame(width: 160, height: 160)
    }
}

struct BloodOxygenInfo_Previews: PreviewProvider {
    static var previews: some View {
        BloodOxygenInfo()
    }
}

extension BloodOxygenInfo {   
    private var lungsIcon: some View {
        Image(systemName: "lungs.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 24)
            .foregroundColor(.lungBlue)
    }
}
