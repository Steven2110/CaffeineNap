//
//  CaffeineLevelInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI
import Charts

struct CaffeineLevelInfo: View {
    
    @EnvironmentObject var logManager: CNLogManager
    @State private var caffeineLevelOvertime: [ChartData] = []
    var size: Int {
        if caffeineLevelOvertime.count < 1 {
            return 1
        } else {
            return caffeineLevelOvertime.count
        }
    }
    
    @State private var selectedItem: ChartData?
    @State private var plotWidth: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Caffeine Level Overtime").font(.system(size: 14, weight: .bold))
            HStack(alignment: .bottom) {
                ScrollView(.horizontal) {
                    Chart {
                        ForEach(caffeineLevelOvertime) { data in
                            BarMark(
                                x: .value("Time", data.time),
                                y: .value("Caffeine Amount", data.caffeineAmount),
                                width: 10
                            )
                            .foregroundStyle(Color.brandDarkBrown)
                            .clipShape(Capsule())
                            RuleMark(y: .value("Sleep", 100.0))
                                .lineStyle(.init(lineWidth: 1, miterLimit: 2, dash: [2], dashPhase: 5))
                                .foregroundStyle(Color.brandPrimary)
                                .annotation(alignment: .leading) { sleepIndicator.offset(x: -20, y: -5) }
                                .annotation(alignment: .trailing) { sleepIndicator.offset(x: 20, y: -5) }
                            if let selectedItem, selectedItem.id == data.id {
                                RuleMark(x: .value("Hour", selectedItem.time))
                                    .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                                    .offset(x: (plotWidth / CGFloat(size)) / 2)
                                    .annotation(position: .leading) {
                                        VStack(alignment: .leading) {
                                            Text("Caffeine").bold()
                                            Text("\(getTime(from: selectedItem.time))")
                                            Text("\(selectedItem.caffeineAmount, specifier: "%.1f") mg")
                                        }
                                        .padding()
                                        .background {
                                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                                .fill(Color.brandSecondary.shadow(.drop(radius: 2)))
                                        }
                                        .offset(y: -10)
                                    }
                            }
                        }
                    }
                    .frame(width: 15 * CGFloat(size), height: 150)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                        AxisMarks(position: .trailing)
                    }
                    .chartOverlay { proxy in
                        GeometryReader { innerPrxoy in
                            Rectangle()
                                .fill(.clear)
                                .contentShape(Rectangle())
                                .simultaneousGesture(
                                    DragGesture(minimumDistance: 2)
                                        .onChanged { value in
                                            let location = value.location
                                            if let date: Date = proxy.value(atX: location.x), let amount: Double = proxy.value(atY: location.y) {
                                                let calendar = Calendar.current
                                                let hour = calendar.component(.hour, from: date)
                                                let minute = calendar.component(.minute, from: date)
                                                
                                                if let currentItem = caffeineLevelOvertime.first(where: { data in
                                                    calendar.component(.hour, from: data.time) == hour && calendar.component(.minute, from: data.time) == minute && amount <= data.caffeineAmount
                                                }) {
                                                    self.selectedItem = currentItem
                                                    self.plotWidth = proxy.plotAreaSize.width
                                                }
                                            }
                                        }
                                        .onEnded { _ in
                                            self.selectedItem = nil
                                        },
                                    including: .all
                                )
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 20, height: 200)
        .background(Color.brandSecondary.cornerRadius(25))
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
        .onChange(of: logManager.logs) { _ in
            emptyCharts()
            generateCharts()
        }
    }
}

struct CaffeineLevelInfo_Previews: PreviewProvider {
    static var previews: some View {
        CaffeineLevelInfo()
            .environmentObject(CNLogManager())
    }
}

extension CaffeineLevelInfo {
    private var sleepIndicator: some View {
        Text("Sleep")
            .font(.caption.bold())
            .foregroundColor(.brandPrimary)
            .padding(2)
            .background(Color.brandBrown.cornerRadius(5))
    }
    
    private func getTime(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm"
        
        return dateFormatter.string(from: date)
    }
    
    private func emptyCharts() {
        caffeineLevelOvertime.removeAll(keepingCapacity: true)
        for i in 0...23 {
            let todayHour = Calendar.current.date(bySettingHour: i, minute: 0, second: 0, of: logManager.date)!
            caffeineLevelOvertime.append(ChartData(time: todayHour, caffeineAmount: 0))
            let halfHour = Calendar.current.date(bySettingHour: i, minute: 30, second: 0, of: logManager.date)!
            caffeineLevelOvertime.append(ChartData(time: halfHour, caffeineAmount: 0))
        }
    }
    
    private func generateCharts() {
        guard !logManager.logs.isEmpty else { return }
        for log in logManager.logs.sorted(by: {$0.drinkTime < $1.drinkTime }) {
            let currentDrinkTime = log.drinkTime
            
            for i in 0..<caffeineLevelOvertime.count - 1 {
                if (currentDrinkTime >= caffeineLevelOvertime[i].time && currentDrinkTime < caffeineLevelOvertime[i + 1].time) {
                    caffeineLevelOvertime[i].caffeineAmount += log.caffeineAmount
                    print(log.caffeineAmount)
                }
            }
        }
        print("Added")
        print(caffeineLevelOvertime)
        
        for i in caffeineLevelOvertime.indices {
            if i == caffeineLevelOvertime.count - 1 { break }
            if caffeineLevelOvertime[i].caffeineAmount > 0 {
                let nextCaffeineLevel = predictNext30MinutesCaffeineLevel(currentCaffeineLevel: caffeineLevelOvertime[i].caffeineAmount)
                caffeineLevelOvertime[i + 1].caffeineAmount += nextCaffeineLevel
            }
        }
    }
}
