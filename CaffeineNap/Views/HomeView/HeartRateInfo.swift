//
//  HeartRateInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct HeartRateInfo: View {
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .top) {
                heartIcon
                    .frame(width: geo.size.width * 0.15)
                VStack(alignment: .leading) {
                    Text("Resting HR")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    HStack(alignment: .firstTextBaseline,spacing: 5) {
                        Text("100")
                            .font(.title)
                            .fontWeight(.heavy)
                            .minimumScaleFactor(0.7)
                        Text("BPM").font(.caption.bold())
                    }
                    Spacer()
                    Text("Peak Resting HR")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    HStack(alignment: .firstTextBaseline,spacing: 5) {
                        Text("90")
                            .font(.title)
                            .fontWeight(.heavy)
                            .minimumScaleFactor(0.7)
                        Text("BPM").font(.caption.bold())
                    }
                }
            }.padding(20)
        }
        .frame(width: UIScreen.main.bounds.width / 2 - 15, height: UIScreen.main.bounds.width / 2 - 20)
        .background(Color.brandSecondary.opacity(0.5).cornerRadius(25))
    }
}

struct HeartRateInfo_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateInfo()
            .previewDevice("iPhone 14 Pro Max")
            .previewDisplayName("iPhone 14 Pro Max")
        HeartRateInfo()
            .previewDevice("iPhone 13 Mini")
            .previewDisplayName("iPhone 13 Mini")
    }
}

extension HeartRateInfo {    
    private var heartIcon: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.red)
    }
}
