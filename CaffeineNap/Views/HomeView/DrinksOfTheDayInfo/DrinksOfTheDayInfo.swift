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
        VStack(alignment: .leading) {
            Text("Drinks of the Day")
                .font(.system(size: 14, weight: .bold))
                .underline()
                .frame(maxWidth: .infinity, alignment: .leading)
            if !logManager.logs.isEmpty && !isLoading {
                ScrollView {
                    ForEach(logManager.logs) { log in
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
                                        .border(.red)
                                    Text("\(log.caffeineAmount, specifier: "%.0f")")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                        .bold()
                                        .border(.red)
                                    Text("mg").font(.caption2)
                                    Image(systemName: "chevron.right").padding(.trailing, 5)
                                }
                            }
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                        }
                    }
                }.frame(height: 270)
            } else if isLoading {
                LoadingView(withColor: false).frame(maxWidth: .infinity, maxHeight: .infinity)
            } else { Spacer() }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 20, height: 350)
        .background(Color.brandSecondary.opacity(0.5).cornerRadius(25))
        .onAppear {
            Task {
                do {
                    isLoading = true
                    logManager.logs = try await CloudKitManager.shared.fetchLog(for: logManager.getCurrentDateStart())
                    isLoading = false
                } catch {
                    // - TODO: Add alert if something went wrong
                    print("Error log: \(error.localizedDescription)")
                    isLoading = false
                }
            }
        }
        .onChange(of: logManager.date) { _ in
            Task {
                do {
                    isLoading = true
                    logManager.logs = try await CloudKitManager.shared.fetchLog(for: logManager.getCurrentDateStart())
                    isLoading = false
                } catch {
                    // - TODO: Add alert if something went wrong
                    print("Error fetching log: \(error.localizedDescription)")
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
