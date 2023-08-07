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
                .font(.title2.bold())
                .underline()
                .frame(maxWidth: .infinity, alignment: .leading)
            if !logManager.logs.isEmpty && !isLoading {
                ScrollView {
                    ForEach(logManager.logs) { log in
                        DrinksOfTheDayInfoRow(log: log)
                    }
                }.frame(height: 270)
            } else if isLoading {
                LoadingView(withColor: false).frame(maxWidth: .infinity, maxHeight: .infinity)
            } else { EmptyDrinksOfTheDayInfo().frame(maxWidth: .infinity, maxHeight: .infinity) }
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
