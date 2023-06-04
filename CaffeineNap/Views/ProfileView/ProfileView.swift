//
//  ProfileView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 09.03.2023.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var avatar: UIImage = ImagePlaceHolder.avatar
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    @State private var watchAppInstalled: Bool = true
    @State private var pressed: Bool = false
    
    @State private var isShowingPhotoPicker: Bool = false
    
    @State private var alertItem: AlertItem?
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        ZStack {
                            AvatarView(image: avatar, size: 100)
                            editProfilePicture
                        }.onTapGesture { isShowingPhotoPicker = true }
                        VStack {
                            HStack(alignment: .lastTextBaseline) {
                                TextField("Username", text: $username)
                                    .usernameStyle()
                                ForEach(0..<3, id: \.self) { _ in
                                    badge
                                }
                                Spacer()
                            }
                            TextField("First Name", text: $firstName)
                                .profileNameStyle()
                            TextField("Last Name", text: $lastName)
                                .profileNameStyle()
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding()
                    .listRowBackground(Color.brandSecondary)
                    ZStack {
                        Button {
                            pressed = true
                            createProfile()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                pressed = false
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("Save Profile").foregroundColor(.brandSecondary)
                            }
                        }.disabled(pressed)
                        if pressed {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.brandSecondary))
                        }
                    }.listRowBackground(Color.brandPrimary)
                }
                Section("Personalization") {
                    SettingRow(imageName: "dial.medium.fill", color: Color.red, text: "Metabolic Parameters") {
                        MetabolicParameterView()
                    }
                    SettingRow(imageName: "app.badge", color: Color.blue, text: "Notifications") {
                        NotificationsSettingView()
                    }
                    SettingRow(imageName: "rectangle.stack.badge.person.crop.fill", color: Color.green, text: "Interface") {
                        UISettingView()
                    }
                    SettingRow(imageName: "platter.2.filled.iphone", color: Color.orange, text: "Widget Style") {
                        Text("Widget Style")
                    }
                    SettingRow(imageName: "wand.and.stars.inverse", color: Color.purple, text: "App Icon") {
                        AppIconView()
                    }
                }
                Section("Data") {
                    SettingRow(imageName: "icloud.fill", color: Color.lungBlue, text: "iCloud") {
                        Text("iCloud")
                    }
                    SettingRow(imageName: "heart.fill", color: Color.pink, text: "Health Data") {
                        Text("Health Data")
                    }
                }
                Section("Watch App") {
                    if watchAppInstalled {
                        SettingRow(imageName: "arrow.triangle.2.circlepath.circle.fill", color: Color.green, text: "Watch Data Sync") {
                            Text("Watch Data Sync")
                        }
                        SettingRow(imageName: "applewatch.watchface", color: Color.black, text: "Apple Watch Faces") {
                            Text("Apple Watch Faces")
                        }
                    } else {
                        Link(destination: URL(string: "https://www.google.com")!) {
                            HStack {
                                watchAppIcon
                                watchAppInfo
                                Spacer()
                                Image(systemName: "link")
                            }.accentColor(.brandPrimary)
                        }
                    }
                }
                Section {
                    SettingRow(imageName: "questionmark.circle", color: Color.pink, text: "How to Use the App") {
                        Text("How To Use The App")
                    }
                    SettingRow(imageName: "star.fill", color: Color.yellow, text: "Rate on the App Store") {
                        Text("Rate on the App Store")
                    }
                    SettingRow(imageName: "envelope", color: Color.blue, text: "Send a Feedback") {
                        Text("Send a Feedback")
                    }
                    SettingRow(imageName: "person.crop.circle.badge.questionmark.fill", color: Color.brandPrimary, text: "About Developer") {
                        Text("About developer")
                    }
                } header: {
                    Text("Support and Resources")
                } footer: {
                    Text("v 1.0.0")
                }
            }
            .navigationTitle("Profile & Settings")
            .navigationBarHidden(true)
            .alert(item: $alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
            })
            .sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPicker(image: $avatar)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

extension ProfileView {
    private var editProfilePicture: some View {
        Image(systemName: "square.and.pencil")
            .resizable()
            .scaledToFit()
            .frame(width: 14, height: 14)
            .foregroundColor(.white)
            .offset(y: 33)
    }
    
    private var badge: some View {
        ZStack {
            Circle()
                .frame(width: 35, height: 35)
                .foregroundColor(.badgeGray)
            Image("badge-hand-grinder")
                .frame(width: 30, height: 30)
        }
    }
    
    private var watchAppIcon: some View {
        Image(systemName: "applewatch")
            .resizable()
            .scaledToFit()
            .frame(width: 50, height: 50)
    }
    
    private var watchAppInfo: some View {
        Text("CaffeineNap")
            .bold()
            .font(.title2)
    }
    
    func isValidProfile() -> Bool {
        
        guard !firstName.isEmpty,
              firstName.count <= 100,
              !lastName.isEmpty,
              lastName.count <= 100,
              !username.isEmpty,
              username.count <= 20,
              avatar != ImagePlaceHolder.avatar else { return false }
        
        return true
    }
    
    func createProfile() {
        guard isValidProfile() else {
            alertItem = AlertContext.invalidProfile
            return
        }
    }
}
