//
//  MainInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI

struct MainInfo: View {
    
    @EnvironmentObject var logManager: CNLogManager
    @State private var currentCaffeineLevel: Double = 0.0
    @StateObject private var vm: MainInfoViewModel = MainInfoViewModel()
    
    @State var timer = Timer.publish(every: 30 * 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            ZStack {
                baseCircularProgress
                CircularProgress(caffeineAmount: vm.currentCaffeineAmount, maxCaffeine: vm.maxCaffeineAmount)
                VStack {
                    Image("coffee-beans")
                    HStack(spacing: 0) {
                        Color.clear
                            .frame(minWidth: 30, maxWidth: 50, maxHeight: 10)
                            .animatingDoubleOverlay(alignment: .trailing,for: vm.currentCaffeineAmount, color: .brandPrimary)
                        Text(" / \(vm.maxCaffeineAmount, specifier: "%.0f") mg").foregroundColor(.brandPrimary)
                    }.offset(x: -15)
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Good Morning, Steven! 🌅")
                    .font(.title3.bold())
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                VStack(alignment: .leading, spacing: 10){
                    HStack(alignment: .firstTextBaseline, spacing: 9) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Today Total").font(.system(size: 14, weight: .semibold))
                            Color.clear
                                .frame(width: 70, height: 15)
                                .animatingDoubleOverlay(alignment: .leading, for: vm.totalTodayCaffeine, smallFont: true, measurementUnit: " mg")
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Drinks").font(.system(size: 14, weight: .semibold))
                            Color.clear
                                .frame(width: 70, height: 15)
                                .animatingDoubleOverlay(alignment: .leading, for: vm.beverageCupAmount, specifier: vm.cupAmountSpecifier,smallFont: true, measurementUnit: vm.beverageAmountMeasurementUnit)
                        }
                    }
                    HStack(alignment: .firstTextBaseline, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Alertness").font(.system(size: 14, weight: .semibold))
                            Text(String(describing: vm.alertness)).font(.system(size: 14))
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Predicted Sleep Time")
                                .font(.system(size: 14, weight: .semibold))
                            ZStack {
                                Text("22:45").font(.system(size: 14))
                                infoLabel
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 175, maxWidth: 500)
        }
        .padding(5)
        .frame(width: UIScreen.main.bounds.width - 20, height: 170)
        .background(Color.brandBrown)
        .cornerRadius(25)
        .onAppear {
            Task {
                if logManager.logs.isEmpty {
                    do {
                        logManager.logs = try await CloudKitManager.shared.fetchLog(for: logManager.getCurrentDateStart())
                        if !logManager.logs.isEmpty { timer = timer.upstream.autoconnect() }
                        vm.updateInfo(from: logManager.logs)
                    } catch {
                        print("Error fetching log: \(error.localizedDescription)")
                    }
                }
                vm.updateInfo(from: logManager.logs)
            }
        }
        .onChange(of: logManager.logs) { _ in
            vm.updateInfo(from: logManager.logs)
        }
        .onReceive(timer) { time in
            if logManager.logs.isEmpty {
                timer.upstream.connect().cancel()
            } else {
                print("Fires")
                vm.updateInfo(from: logManager.logs)
            }
        }
    }
}

struct CircularProgress: View {
    
    var caffeineAmount: Double
    var maxCaffeine: Double
    var percentage: Double {
        withAnimation {
            let result = caffeineAmount / (2 * maxCaffeine)
            return result <= 0.5 ? result : 0.5
        }
    }
    
    var body: some View {
        Circle()
            .trim(from: 0, to: percentage)
            .stroke(
                Color.brandPrimary,
                style: StrokeStyle(
                    lineWidth: 18,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(180))
            .frame(minWidth: 50, idealWidth: 100, maxWidth: 120, minHeight: 50 , idealHeight: 100, maxHeight: 120)
            .padding(15)
    }
}

struct MainInfo_Previews: PreviewProvider {
    static var previews: some View {
        MainInfo()
            .environmentObject(CNLogManager())
            .previewDevice("iPhone 14 Pro Max")
            .previewDisplayName("iPhone 14 Pro Max")
        
        MainInfo()
            .previewDevice("iPhone 14 Pro")
            .previewDisplayName("iPhone 14 Pro")
            .environmentObject(CNLogManager())
        
        MainInfo()
            .previewDevice("iPhone 14 Plus")
            .previewDisplayName("iPhone 14 Plus")
            .environmentObject(CNLogManager())
        
        MainInfo()
            .previewDevice("iPhone 14")
            .previewDisplayName("iPhone 14")
            .environmentObject(CNLogManager())

        MainInfo()
            .previewDevice("iPhone 13 mini")
            .previewDisplayName("iPhone 13 Mini")
            .environmentObject(CNLogManager())
    }
}

extension MainInfo {
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
            .frame(minWidth: 50, idealWidth: 100, maxWidth: 120, minHeight: 50 , idealHeight: 100, maxHeight: 120)
            .padding(15)
    }
    
    private var infoLabel: some View {
        Image(systemName: "info.circle")
            .resizable()
            .frame(width: 10, height: 10)
            .offset(x: 28, y: -5)
    }
}
