//
//  UISettingView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 19.04.2023.
//

import SwiftUI

struct UISettingView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @Environment(\.openURL) var openURL
    
    private var language: Language {
        let locale = (Locale.autoupdatingCurrent.language.languageCode?.identifier)!
        return Language(rawValue: locale)!
    }
    @State private var measurementUnit: String = "mililitres"
    var body: some View {
        List {
            Section("Theme") {
                CNThemeToggle(text: isDarkMode ? "Dark Mode" : "Light Mode", toggle: $isDarkMode)
            }
            Section("App Preferences") {
                languageSetting
                .onTapGesture {
                    openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
                measurementUnitSetting
            }
        }
        .navigationTitle("Interface")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UISettingView_Previews: PreviewProvider {
    static var previews: some View {
        UISettingView()
    }
}

extension UISettingView {
    private var languageSetting: some View {
        HStack {
            Text(getFlag(language))
            Text(language.description)
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.gray)
        }
    }
    
    private var measurementUnitSetting: some View {
        Picker("Measurement Units", selection: $measurementUnit) {
            Text("Mililitres")
            Text("US Fluid Oz.")
            Text("UK Fluid Oz.")
        }
    }
    
    private func getFlag(_ lang: Language) -> String {
        switch(lang) {
        case .en: return "🇬🇧"
        case .ru: return "🇷🇺"
        }
    }
}
