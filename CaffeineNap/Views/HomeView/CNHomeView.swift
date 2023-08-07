//
//  CNHomeView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 06.03.2023.
//

import SwiftUI

struct CNHomeView: View {
    
    @EnvironmentObject var logManager: CNLogManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    MainInfo()
                    CaffeineLevelInfo()
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            HeartRateInfo()
                            BloodOxygenInfo()
                        }
                        DrinksOfTheDayInfo()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Button {
                            logManager.previousDay()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        Text(getFullDate())
                            .gesture(TapGesture(count: 2).onEnded {
                                logManager.date = Date()
                            })
                        Button {
                            logManager.nextDay()
                        } label: {
                            Image(systemName: "chevron.right")
                                .opacity(isToday() ? 0 : 1)
                        }.disabled(isToday())
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "calendar")
                              .font(.title3)
                              .overlay{
                                 DatePicker(
                                     "",
                                     selection: $logManager.date,
                                     displayedComponents: [.date]
                                 )
                                 .blendMode(.destinationOver)
                                 .accentColor(.brandPrimary)
                              }
                }
            }.accentColor(.black)
        }
        .onAppear {
            Task {
                if logManager.logs.isEmpty {
                    do {
                        logManager.logs = try await CloudKitManager.shared.fetchLog(for: logManager.getCurrentDateStart())
                    } catch {
                        print("Error fetching log: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

struct CNHomeView_Previews: PreviewProvider {
    static var previews: some View {
        CNHomeView()
            .environmentObject(CNLogManager())
    }
}

extension CNHomeView {
    private func isToday() -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDateInToday(logManager.date)
    }
    
    private func getDay() -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(logManager.date) {
            return "Today"
        } else if calendar.isDateInYesterday(logManager.date) {
            return "Yesterday"
        } else if calendar.isDateInTomorrow(logManager.date) {
            return "Tomorrow"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: logManager.date)
        
        return dayOfTheWeekString
    }
    
    private func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let dateString = dateFormatter.string(from: logManager.date)
        
        return dateString
    }
    
    private func getFullDate() -> String {
        "\(getDay()), \(getDate())"
    }
}
