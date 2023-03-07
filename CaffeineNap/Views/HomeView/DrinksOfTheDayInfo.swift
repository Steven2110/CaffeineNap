//
//  DrinksOfTheDayInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct DrinksOfTheDayInfo: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25).foregroundColor(.brandSecondary.opacity(0.5))
            VStack(alignment: .leading) {
                Text("Drinks of the Day")
                    .font(.system(size: 14, weight: .bold))
                    .underline()
                ScrollView {
                    ForEach(0..<10, id: \.self) { _ in
                        NavigationLink {
                            Text("Drink's information")
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.brandSecondary)
                                HStack(spacing: 5) {
                                    coffeeCupIcon
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Iced Macchiatto")
                                            .font(.system(size: 16))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.7)
                                        HStack(alignment: .bottom, spacing: 5) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 2)
                                                    .frame(width: 50, height: 20)
                                                    .foregroundColor(.baseGray)
                                                Text("Medium")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.brandDarkBrown)
                                            }
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 2)
                                                    .frame(width: 50, height: 20)
                                                    .foregroundColor(.baseGray)
                                                Text("07:44")
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.brandDarkBrown)
                                            }
                                        }
                                    }.frame(width: 100)
                                    Spacer()
                                    Text("110").font(.system(size: 16))
                                    Text("mg").font(.system(size: 10))
                                    Image(systemName: "chevron.right").padding(.trailing, 5)
                                }
                            }.frame(width: 215, height: 45)
                        }
                    }
                }.frame(height: 270)
            }
        }.frame(width: 240, height: 327)
    }
}

struct DrinksOfTheDayInfo_Previews: PreviewProvider {
    static var previews: some View {
        DrinksOfTheDayInfo()
    }
}

extension DrinksOfTheDayInfo {
    private var coffeeCupIcon: some View {
        Image("coffee-cup")
            .resizable()
            .scaledToFit()
            .frame(width: 25, height: 36)
    }
    
    
}
