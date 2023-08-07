//
//  NotificationsSettingView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 10.03.2023.
//

import SwiftUI

struct NotificationsSettingView: View {
    
    @State private var allowNotifications: Bool = false
    @State private var logReminder: Bool = false
    @State private var dailyReport: Bool = false
    
    @State private var selectedDaysLog: [DayNotification] = [DayNotification]()
    @State private var selectedTimeLog: Date = Date()
    
    @State private var selectedDaysDaily: [DayNotification] = [DayNotification]()
    @State private var selectedTimeDaily: Date = Date()
    
    var body: some View {
        List {
            Toggle("Allow Notifications", isOn: $allowNotifications)
            Section {
                if allowNotifications {
                    VStack(alignment: .leading) {
                        Toggle("Log Reminder", isOn: $logReminder)
                        Text("We will remind you to record your caffeine intake on that day at that particular time.")
                    }
                }
                if logReminder {
                    VStack(alignment: .leading) {
                        Text("Day of The Week")
                        HStack(spacing: 20) {
                            ForEach(NotificationsDay.days) { day in
                                dayCircle
                                    .foregroundColor((selectedDaysLog.contains { $0 == day }) ? .brandPrimary : .brandSecondary)
                                    .overlay(Text(day.letter).foregroundColor(.white))
                                    .onTapGesture {
                                        if selectedDaysLog.contains(where: { $0 == day }) {
                                            selectedDaysLog.removeAll(where: { $0 == day })
                                        } else {
                                            selectedDaysLog.append(day)
                                        }
                                    }
                            }
                        }
                    }
                    DatePicker("Time", selection: $selectedTimeLog, displayedComponents: .hourAndMinute)
                }
            }
            Section {
                if allowNotifications {
                    VStack(alignment: .leading) {
                        Toggle("Daily Report", isOn: $dailyReport)
                        Text("We will send you a daily report on your caffeine intake, current caffeine level, alertness level and bedtime caffeine level on that day at that particular time.")
                    }
                }
                if dailyReport {
                    VStack(alignment: .leading) {
                        Text("Day of The Week")
                        HStack(spacing: 20) {
                            ForEach(NotificationsDay.days) { day in
                                dayCircle
                                    .foregroundColor((selectedDaysDaily.contains { $0 == day }) ? .brandPrimary : .brandSecondary)
                                    .overlay(Text(day.letter).foregroundColor(.white))
                                    .onTapGesture {
                                        if selectedDaysDaily.contains(where: { $0 == day }) {
                                            selectedDaysDaily.removeAll(where: { $0 == day })
                                        } else {
                                            selectedDaysDaily.append(day)
                                        }
                                    }
                            }
                        }
                    }
                    DatePicker("Time", selection: $selectedTimeDaily, displayedComponents: .hourAndMinute)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingView()
    }
}

extension NotificationsSettingView {
    private var dayCircle: some View {
        Circle()
            .frame(width: 30, height: 30)
    }
}
