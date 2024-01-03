//
//  MetabolicParameterView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 10.03.2023.
//

import SwiftUI

struct MetabolicParameterView: View {
    
    @Environment (\.dismiss) private var dismiss
    
    @State private var caffeineLimit: Double = 400.0
    @State private var bedtimeCaffeineTreshold: Double = 100.0
    @State private var caffeineHalfLife: Double = 4.0
    @State private var sleepTime: Date = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        List {
            Section {
                DatePicker(selection: $sleepTime, displayedComponents: .hourAndMinute) {
                    HStack {
                        Image(systemName: "moon.zzz.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45)
                            .foregroundColor(.indigo)
                        VStack(alignment: .leading) {
                            Text("Desired Bedtime")
                                .font(.title3)
                                .bold()
                            Text("Desired sleep time / the time you usually go to bed.")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        }.padding(.leading)
                    }
                }
            }
            Section {
                HStack {
                    Image("coffee-beans")
                    VStack(alignment: .leading) {
                        Text("Caffeine Limit")
                            .font(.title3)
                            .bold()
                        Text("Maximum daily caffeine intake without negative health effects to your body.")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        VStack(alignment: .leading, spacing: 5) {
                            if caffeineLimit > 400.0 {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
                                    Text("FDA recommended limit is 400 mg.")
                                        .foregroundColor(.red)
                                        .font(.subheadline)
                                }.padding(.top, 2)
                            }
                            if caffeineLimit == 600.0 {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
                                    Text("Be careful wth your caffeine intake. Lethal dose is 10 grams.")
                                        .foregroundColor(.red)
                                        .font(.subheadline)
                                }
                            }
                        }
                    }.padding(.leading)
                }
                VStack {
                    Slider(
                        value: $caffeineLimit,
                        in: 0...600,
                        step: 1
                    ) {
                        Text("Caffeine Limit")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("600")
                    }
                    HStack {
                        Spacer()
                        TextField("", value: $caffeineLimit, formatter: NumberFormatter())
                            .font(.title)
                            .frame(width: 70)
                        Text("mg").font(.subheadline)
                        Stepper("") {
                            caffeineLimit += 1
                        } onDecrement: {
                            caffeineLimit -= 1
                        }.frame(width: 100)
                    }
                }
            }
            Section {
                HStack {
                    Image(systemName: "moon.zzz.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45)
                        .foregroundColor(.indigo)
                    VStack(alignment: .leading) {
                        Text("Bedtime Caffeine Levels")
                            .font(.title3)
                            .bold()
                        Text("Caffeine treshold level at bedtime that do not interfere with your sleep.")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }.padding(.leading)
                }
                VStack {
                    Slider(
                        value: $bedtimeCaffeineTreshold,
                        in: 0...600,
                        step: 1
                    ) {
                        Text("Caffeine Limit")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("300")
                    }
                    HStack {
                        Spacer()
                        TextField("", value: $bedtimeCaffeineTreshold, formatter: NumberFormatter())
                            .font(.title)
                            .frame(width: 70)
                        Text("mg").font(.subheadline)
                        Stepper("") {
                            bedtimeCaffeineTreshold += 1
                        } onDecrement: {
                            bedtimeCaffeineTreshold -= 1
                        }.frame(width: 100)
                    }
                }
            }
            Section {
                HStack {
                    Image(systemName: "hourglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35)
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Caffeine's Biological Half-Life")
                            .font(.title3)
                            .bold()
                        Text("Time required for your body to eliminate/cleanse one half of a dose")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }.padding(.leading)
                }
                HStack {
                    Spacer()
                    TextField("", value: $caffeineHalfLife, formatter: formatter)
                        .font(.title)
                        .frame(width: 70)
                        .keyboardType(.decimalPad)
                    Text("hours").font(.subheadline)
                    Stepper("", value: $caffeineHalfLife, in: 0.5...10, step: 0.5)
                        .frame(width: 100)
                }
            } footer: {
                if caffeineHalfLife < 3.0 || caffeineHalfLife > 7.0 {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow)
                        Text("In healthy adults, caffeine's biological half-life is usually between 3 and 7 hours.")
                            .foregroundColor(.red)
                    }.padding(.top, 2)
                }
            }
        }
        .navigationTitle("Metabolic Parameters")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left").fontWeight(.semibold)
                    Text("Profile & Settings")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismissKeyboard()
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
}

struct MetabolicParameterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MetabolicParameterView()
        }
    }
}
