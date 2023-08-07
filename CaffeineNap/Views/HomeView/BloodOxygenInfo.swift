//
//  BloodOxygenInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct BloodOxygenInfo: View {
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .top) {
                lungsIcon
                    .frame(width: geo.size.width * 0.15)
                VStack(alignment: .leading) {
                    Text("Blood Oxygen")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        Text("100")
                            .font(.title)
                            .fontWeight(.heavy)
                            .minimumScaleFactor(0.7)
                        Text("%").font(.title3.bold())
                    }
                    Spacer()
                    Text("Peak Resting BO")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    HStack(alignment: .firstTextBaseline,spacing: 5) {
                        Text("99")
                            .font(.title)
                            .fontWeight(.heavy)
                            .minimumScaleFactor(0.7)
                        Text("%").font(.title3.bold())
                    }
                }
            }.padding(20)
        }
        .frame(width: UIScreen.main.bounds.width / 2 - 15, height: UIScreen.main.bounds.width / 2 - 20)
        .background(Color.brandSecondary.opacity(0.5).cornerRadius(25))        
    }
}

struct BloodOxygenInfo_Previews: PreviewProvider {
    static var previews: some View {
        BloodOxygenInfo()
            .previewDevice("iPhone 14 Pro Max")
            .previewDisplayName("iPhone 14 Pro Max")
        BloodOxygenInfo()
            .previewDevice("iPhone 13 Mini")
            .previewDisplayName("iPhone 13 Mini")
    }
}

extension BloodOxygenInfo {   
    private var lungsIcon: some View {
        Image(systemName: "lungs.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.lungBlue)
    }
}
