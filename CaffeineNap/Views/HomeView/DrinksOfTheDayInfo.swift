//
//  DrinksOfTheDayInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct DrinksOfTheDayInfo: View {
    
    @EnvironmentObject var logManager: CNLogManager
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25).foregroundColor(.brandSecondary.opacity(0.5))
            VStack(alignment: .leading) {
                Text("Drinks of the Day")
                    .font(.system(size: 14, weight: .bold))
                    .underline()
                    .frame(maxWidth: .infinity, alignment: .leading)
                ScrollView {
                    if !logManager.logs.isEmpty && !isLoading {
                        ForEach(logManager.logs) { log in
                            NavigationLink {
                                VStack {
                                    Text(log.beverageName)
                                    Text(log.drinkTime, style: .date)
                                    Text(log.drinkTime, style: .time)
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(.brandSecondary)
                                    HStack(spacing: 5) {
                                        Image(log.beverageIcon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 36)
                                        VStack(alignment: .leading, spacing: 1) {
                                            Text(log.beverageName)
                                                .font(.system(size: 16))
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.7)
                                            HStack(alignment: .bottom, spacing: 5) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .frame(width: 55, height: 20)
                                                        .foregroundColor(.baseGray)
                                                    Text(log.beverageSize.rawValue.capitalized)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.brandDarkBrown)
                                                }
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .frame(width: 50, height: 20)
                                                        .foregroundColor(.baseGray)
                                                    Text(log.drinkTime, style: .time)
                                                        .font(.system(size: 12))
                                                        .foregroundColor(.brandDarkBrown)
                                                }
                                            }
                                        }.frame(width: 100)
                                        Spacer()
                                        Text("\(log.caffeineAmount, specifier: "%.0f")").font(.system(size: 14).bold())
                                        Text("mg").font(.system(size: 10))
                                        Image(systemName: "chevron.right").padding(.trailing, 5)
                                    }
                                }.frame(width: 215, height: 45)
                            }
                        }
                    } else if isLoading { LoadingView().frame(maxWidth: .infinity, maxHeight: .infinity) }
                }.frame(height: 270)
            }.padding()
        }
        .frame(width: 240, height: 327)
        .onAppear {
            print("Appear")
            Task {
                do {
                    isLoading = true
                    logManager.logs = try await CloudKitManager.shared.fetchLog()
                    print(logManager.logs)
                    isLoading = false
                } catch {
                    print("Error log: \(error.localizedDescription)")
                    isLoading = false
                }
            }
        }
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
