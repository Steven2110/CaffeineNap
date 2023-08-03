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
        ZStack {
            base
            HStack {
                ZStack {
                    baseCircularProgress
                    CircularProgress(caffeineAmount: vm.currentCaffeineAmount, maxCaffeine: vm.maxCaffeineAmount)
                    VStack {
                        Image("coffee-beans")
                        HStack(spacing: 0) {
                            Color.clear
                                .frame(minWidth: 30, maxWidth: 50, maxHeight: 10)
                                .animatingOverlay(alignment: .trailing,for: vm.currentCaffeineAmount, color: .brandPrimary)
                            Text(" / \(vm.maxCaffeineAmount, specifier: "%.0f") mg").foregroundColor(.brandPrimary)
                        }.offset(x: -3)
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Good Morning, Steven! 🌅").font(.system(size: 18, weight: .bold))
                    VStack(alignment: .leading, spacing: 10){
                        HStack(spacing: 9) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Today Total").font(.system(size: 14, weight: .semibold))
                                Color.clear
                                    .frame(width: 70, height: 15)
                                    .animatingOverlay(alignment: .leading, for: vm.totalTodayCaffeine, smallFont: true, measurementUnit: " mg")
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Drinks").font(.system(size: 14, weight: .semibold))
                                Color.clear
                                    .frame(width: 70, height: 15)
                                    .animatingOverlay(alignment: .leading, for: vm.beverageCupAmount, specifier: vm.cupAmountSpecifier,smallFont: true, measurementUnit: vm.beverageAmountMeasurementUnit)
                            }
                        }
                        HStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Alertness").font(.system(size: 14, weight: .semibold))
                                Text(String(describing: vm.alertness)).font(.system(size: 14))
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
            .frame(width: 120, height: 120)
            .padding(15)
    }
}

struct MainInfo_Previews: PreviewProvider {
    static var previews: some View {
        MainInfo()
            .environmentObject(CNLogManager())
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
