//
//  HeartRateInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI
import HealthKit

struct HeartRateInfo: View {
    
    @StateObject private var vm: HeartRateInfoViewModel = HeartRateInfoViewModel()
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .top) {
                heartIcon
                    .frame(width: geo.size.width * 0.15)
                VStack(alignment: .leading) {
                    Text("Heart Rate")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Color.clear
                        .animatingOverlay(alignment: .leading, for: vm.heartRate, font: .title, fontWeight: .heavy, measurementUnit: "BPM", mUnitFont: .caption.bold())
                    Spacer()
                    Text("Peak Heart Rate")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Color.clear
                        .animatingOverlay(alignment: .leading, for: vm.peakHR, font: .title, fontWeight: .heavy, measurementUnit: "BPM", mUnitFont: .caption.bold())
                }
            }.padding(20)
        }
        .frame(width: UIScreen.main.bounds.width / 2 - 15, height: UIScreen.main.bounds.width / 2 - 20)
        .background(Color.brandSecondary.opacity(0.5).cornerRadius(25))
        .onAppear {
            vm.start()
        }
    }
}

class HeartRateInfoViewModel: ObservableObject {
    
    @Published var heartRate: Int = 0
    @Published var peakHR: Int = 0
    @Published var isAuthorized: Bool = false
    
    func changeAuthorizationStatus() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        let status = HKHealthStore().authorizationStatus(for: heartRateType)
        
        DispatchQueue.main.async { [self] in
            switch status {
                case .notDetermined:
                    isAuthorized = false
                case .sharingDenied:
                    isAuthorized = false
                case .sharingAuthorized:
                    isAuthorized = true
                @unknown default:
                    isAuthorized = false
            }
        }
    }
    
    func start() {
        HealthKitManager.shared.autorizeHealthKit {
            self.changeAuthorizationStatus()
            HealthKitManager.shared.readHeartRate(forToday: Date()) { value in
                DispatchQueue.main.async {
                    self.heartRate = value
                    if value > self.peakHR {
                        self.peakHR = value
                    }
                }
            }
        }
        
    }
}

struct HeartRateInfo_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateInfo()
            .previewDevice("iPhone 14 Pro Max")
            .previewDisplayName("iPhone 14 Pro Max")
        HeartRateInfo()
            .previewDevice("iPhone 13 Mini")
            .previewDisplayName("iPhone 13 Mini")
    }
}

extension HeartRateInfo {    
    private var heartIcon: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.red)
    }
}
