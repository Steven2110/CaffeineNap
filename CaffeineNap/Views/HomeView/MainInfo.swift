//
//  MainInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct MainInfo: View {
    var body: some View {
        ZStack {
            base
            HStack {
                ZStack {
                    baseCircularProgress
                    CircularProgress()
                    VStack {
                        Image("coffee-beans")
                        Text("350/500 mg").foregroundColor(.brandPrimary)
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Good Morning, Steven! 🌅").font(.system(size: 18, weight: .bold))
                    VStack(alignment: .leading, spacing: 10){
                        HStack(spacing: 9) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Today Total").font(.system(size: 14, weight: .semibold))
                                Text("400/500 mg").font(.system(size: 14))
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Drinks").font(.system(size: 14, weight: .semibold))
                                Text("2 cups").font(.system(size: 14))
                            }
                        }
                        HStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Alertness").font(.system(size: 14, weight: .semibold))
                                Text("High").font(.system(size: 14))
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Predicted Sleep Time").font(.system(size: 14, weight: .semibold))
                                ZStack {
                                    Text("22:45").font(.system(size: 14))
                                    infoLabel
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CircularProgress: View {
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.35)
            .stroke(
                Color.brandPrimary,
                style: StrokeStyle(
                    lineWidth: 18,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(180))
            .frame(width: 120, height: 120)
            .padding(15)
    }
}

struct MainInfo_Previews: PreviewProvider {
    static var previews: some View {
        MainInfo()
    }
}

extension MainInfo {
    private var base: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(width: 410, height: 165)
            .foregroundColor(.brandBrown)
    }
    
    private var baseCircularProgress: some View {
        Circle()
            .trim(from: 0.5, to: 1)
            .stroke(
                Color.brandSecondary,
                style: StrokeStyle(
                    lineWidth: 18,
                    lineCap: .round
                )
            )
            .frame(width: 120, height: 120)
            .padding(15)
    }
    
    private var infoLabel: some View {
        Image(systemName: "info.circle")
            .resizable()
            .frame(width: 10, height: 10)
            .offset(x: 28, y: -5)
    }
}
