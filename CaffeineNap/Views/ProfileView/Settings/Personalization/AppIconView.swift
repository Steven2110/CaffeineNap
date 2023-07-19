//
//  AppIconView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 10.03.2023.
//

import SwiftUI

struct AppIconView: View {
    
    private struct AppIcon: Identifiable, Equatable {
        var id: UUID = UUID()
        var name: String
    }
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    private var icons: [AppIcon] = [
        AppIcon(name: "Icon1"),
        AppIcon(name: "Icon2"),
        AppIcon(name: "Icon3"),
        AppIcon(name: "Icon4"),
        AppIcon(name: "Icon5")
    ]
    @State private var selectedIcon: [AppIcon] = [AppIcon]()
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(icons) { icon in
                Image(icon.name)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke((isSelected(icon: icon, from: selectedIcon)) ? .blue : .white)
                    )
                    .onTapGesture {
                        selectedIcon.removeAll()
                        selectedIcon.append(icon)
                    }
            }
        }
        .navigationTitle("App Icon")
        .onAppear{
            selectedIcon.append(icons[0])
        }
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AppIconView()
        }
    }
}

extension AppIconView {
    private func isSelected(icon: AppIcon, from selectedIcon: [AppIcon]) -> Bool {
        let selected: Bool = selectedIcon.contains { $0 == icon }
        return selected
    }
}
