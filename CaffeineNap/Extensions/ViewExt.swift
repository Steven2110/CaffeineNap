//
//  ViewExt.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 09.03.2023.
//

import SwiftUI

extension View {
    func profileNameStyle() -> some View {
        self.modifier(ProfileNameText())
    }
    
    func usernameStyle() -> some View {
        self.modifier(UsernameText())
    }
}
