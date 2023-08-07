//
//  DrinksOfTheDayInfoRow.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.08.2023.
//

import SwiftUI

struct DrinksOfTheDayInfoRow: View {
    
    var log: CNLog
    
    var body: some View {
        NavigationLink {
            LogDetailView(vm: LogDetailViewModel(log: log))
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.brandSecondary)
                HStack(spacing: 5) {
                    Image(log.beverageIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.horizontal, 5)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(log.beverageName)
                            .font(.system(size: 16))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        HStack(alignment: .bottom, spacing: 10) {
                            DrinkOfTheDayInfoBox {
                                Text(String(describing: log.beverageSize))
                                    .drinkOfTheDayInfoStyle()
                            }
                            DrinkOfTheDayInfoBox {
                                Text(log.drinkTime, style: .time)
                                    .drinkOfTheDayInfoStyle()
                            }
                        }
                    }.frame(width: 175, alignment: .leading)
                    Text("\(log.caffeineAmount, specifier: "%.0f")")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .bold()
                    Text("mg").font(.caption2)
                    Image(systemName: "chevron.right").padding(.trailing, 5)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
        }
    }
}
