//
//  CNHomeView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 06.03.2023.
//

import SwiftUI

struct CNHomeView: View {
    
    @State private var isToday: Bool = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                MainInfo()
                CaffeineLevelInfo()
                HStack(spacing: 10) {
                    VStack(spacing: 10) {
                        HeartRateInfo()
                        BloodOxygenInfo()
                    }
                    DrinksOfTheDayInfo()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        Text("Today, 12 February 2023")
                        Button {
                            
                        } label: {
                            Image(systemName: "chevron.right")
                                .opacity(isToday ? 0 : 1)
                        }.disabled(isToday)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }.accentColor(.black)
        }
    }
}

struct CNHomeView_Previews: PreviewProvider {
    static var previews: some View {
        CNHomeView()
    }
}
