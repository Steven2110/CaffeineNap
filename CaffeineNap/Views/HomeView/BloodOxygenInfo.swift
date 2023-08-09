//
//  BloodOxygenInfo.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 07.03.2023.
//

import SwiftUI
import HealthKit

struct BloodOxygenInfo: View {
    
    @StateObject private var vm: BloodOxygenInfoViewModel = BloodOxygenInfoViewModel()
    
    var body: some View {
        GeometryReader { geo in
            HStack(alignment: .top) {
                lungsIcon
                    .frame(width: geo.size.width * 0.15)
                VStack(alignment: .leading) {
                    Text("Blood Oxygen")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Color.clear
                        .animatingOverlay(alignment: .leading, for: vm.bloodOxygen, font: .title, fontWeight: .heavy, measurementUnit: "%", mUnitFont: .title3.bold())
                    Spacer()
                    Text("Peak Blood Oxygen")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                    Color.clear
                        .animatingOverlay(alignment: .leading, for: vm.peakBO, font: .title, fontWeight: .heavy, measurementUnit: "%", mUnitFont: .title3.bold())
                }
            }.padding(20)
        }
        .frame(width: UIScreen.main.bounds.width / 2 - 15, height: UIScreen.main.bounds.width / 2 - 20)
        .background(Color.brandSecondary.opacity(0.5).cornerRadius(25))
        .onAppear {
            vm.start()
        }
        .onChange(of: vm.isAuthorized) { _ in
            vm.start()
        }
    }
}

class BloodOxygenInfoViewModel: ObservableObject {
    @Published var bloodOxygen: Int = 0
    @Published var peakBO: Int = 0
    @Published var isAuthorized: Bool = false
    
    init() {
        changeAuthorizationStatus()
    }
    
    func changeAuthorizationStatus() {
        guard let bloodOxygenType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation) else { return }
        let status = HKHealthStore().authorizationStatus(for: bloodOxygenType)
        
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
            HealthKitManager.shared.readBloodOxygen(forToday: Date()) { value in
                DispatchQueue.main.async {
                    self.bloodOxygen = value
                    if value > self.peakBO {
                        self.peakBO = value
                    }
                }
            }
        }
    }
}

struct BloodOxygenInfo_Previews: PreviewProvider {
    static var previews: some View {
        BloodOxygenInfo()
            .previewDevice("iPhone 14 Pro Max")
            .previewDisplayName("iPhone 14 Pro Max")
        BloodOxygenInfo()
            .previewDevice("iPhone 13 Mini")
            .previewDisplayName("iPhone 13 Mini")
    }
}

extension BloodOxygenInfo {   
    private var lungsIcon: some View {
        Image(systemName: "lungs.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.lungBlue)
    }
}
