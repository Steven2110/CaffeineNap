//
//  CNRecipeFormView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 23.04.2024.
//

import SwiftUI
import CloudKit

struct CNRecipeFormView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm: CNRecipeFormViewModel = CNRecipeFormViewModel()
    
    @State private var isShowingPhotoPicker = false
    var isEdit: Bool = false
    
    var formTitle: String {
        isEdit ? "Edit Recipe" : "Add new recipe"
    }
    
    @State var uniqueID = UUID()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Recipe Details")) {
                    TextField("Name", text: $vm.recipeName)
                    Picker("Type", selection: $vm.type) {
                        ForEach(brewMethods, id: \.self) { method in
                            Text(method)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Caffeine Amount")
                        HStack {
                            Slider(value: $vm.caffeineAmount, in: 0...400)
                            HStack {
                                TextField("", value: $vm.caffeineAmount, formatter: caffeineNumberFormatter)
                                    .frame(width: 75)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Text("mg  ")
                            }.frame(width: 120)
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Water Volume")
                        HStack {
                            Slider(value: $vm.waterVolume, in: 0...1000)
                            HStack {
                                TextField("", value: $vm.waterVolume, formatter: waterNumberFormatter)
                                    .frame(width: 75)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Text("l   ")
                                    .font(.custom("Artifact", size: 24))
                            }.frame(width: 120)
                            
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Preparation time")
                        HStack {
                            Slider(value: $vm.preparationTime, in: prepTimeInterval, step: 0.5)
                            HStack {
                                TextField("", value: $vm.preparationTime, formatter: prepNumberFormatter)
                                    .frame(width: 75)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                Text(prepTimeUnit)
                            }.frame(width: 120)
                            
                        }
                    }
                    ZStack(alignment: .topLeading) {
                        if vm.recipeDescription.isEmpty {
                            Text("Enter recipe description...")
                                .foregroundColor(Color.gray)
                                .padding(EdgeInsets(top: 8, leading: 3, bottom: 0, trailing: 0))
                                .opacity(0.6)
                        }
                        TextEditor(text: $vm.recipeDescription)
                    }
                }
                Section(header: Text("What you need?")) {
                    ForEach(0..<vm.tempTools.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(romanNumeral(for: index+1)))")
                                Spacer()
                                if index > 0 {
                                    Button { vm.deleteTool(at: index) } label: {
                                        removeButton
                                    }.buttonStyle(PlainButtonStyle())
                                }
                            }
                            TextField("Item \(index + 1)", text: Binding<String>(
                                get: { vm.tempTools[index]["name"] as? String ?? "" },
                                set: { vm.tempTools[index]["name"] = $0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            HStack {
                                TextField("How many?",
                                    value: Binding<Double>(
                                        get: { vm.tempTools[index]["amount"] as? Double ?? 1 },
                                        set: { vm.tempTools[index]["amount"] = $0 }
                                    ),
                                    formatter: NumberFormatter.oneDecimalPlaces
                                )
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                Picker("", selection: Binding<String>(
                                    get: { vm.tempTools[index]["unit"] as? String ?? "" },
                                    set: { vm.tempTools[index]["unit"] = $0 }
                                )) {
                                    ForEach(recipeToolUnits, id: \.self) { Text($0) }
                                }
                            }
                            Toggle(isOn: Binding<Bool>(
                                get: { vm.tempTools[index]["isOptional"] as? Bool ?? false },
                                set: { vm.tempTools[index]["isOptional"] = $0 }
                            )) {
                                Text("Optional?")
                            }
                        }
                    }
                    Button("Add") { vm.addTool() }.foregroundColor(.brandPrimary)
                }
                Section(header: Text("Instructions")) {
                    ForEach(0..<vm.tempInstructions.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(romanNumeral(for: index + 1)))")
                                Spacer()
                                if index > 0 {
                                    Button { vm.deleteInstruction(at: index) } label: {
                                        removeButton
                                    }.buttonStyle(PlainButtonStyle())
                                }
                            }.padding(.top, 5)
                            ZStack(alignment: .topLeading) {
                                let instruction = vm.tempInstructions[index]["instruction"] as? String ?? ""
                                if instruction.isEmpty {
                                    Text("Step \(index + 1)...")
                                        .foregroundColor(Color.gray)
                                        .padding(EdgeInsets(top: 8, leading: 3, bottom: 0, trailing: 0))
                                        .opacity(0.6)
                                }
                                let instructionUniqueID = vm.tempInstructions[index]["id"] as? UUID ?? UUID()
                                TextEditor(text: Binding<String>(
                                    get: { vm.tempInstructions[index]["instruction"] as? String ?? "" },
                                    set: { vm.tempInstructions[index]["instruction"] = $0 }
                                ))
                                .id(instructionUniqueID)
                                .onAppear { generateNewUUID(&vm.tempInstructions[index]) }
                            }
                        }
                    }
                    Button("Add") { vm.addInstruction() }.foregroundColor(.brandPrimary)
                }
                Section(header: Text("Recipe Image")) {
                    Image(uiImage: vm.selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .overlay(
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue),
                            alignment: .topTrailing
                        )
                        .onTapGesture { isShowingPhotoPicker = true }
                }
                if isEdit {
                    Section() {
                        Button("Delete", role: .destructive) {
                            Task { await vm.deleteRecipe() }
                        }
                    }
                }
            }
            .navigationTitle(formTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            if isEdit {
                                await vm.updateRecipe()
                            } else {
                                await vm.saveRecipe()
                            }
                        }
                    }.foregroundColor(.brandPrimary)
                }
            }
            .alert(item: $vm.alert, content: { alert in
                Alert(title: alert.title, message: alert.message, dismissButton: .default(Text("Ok")) {
                    dismiss()
                })
            })
            .sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPicker(image: $vm.selectedImage)
            }
            .task {
                do {
                    vm.author = try await CloudKitManager.shared.fetchProfile()
                } catch {
                    print("Error fetching profile.")
                }
            }
        }
    }
}

#Preview {
    CNRecipeFormView()
}

extension CNRecipeFormView {
    private var caffeineNumberFormatter: NumberFormatter {
        if hasFractionalPart(vm.caffeineAmount) {
            NumberFormatter.oneDecimalPlaces
        } else {
            NumberFormatter.noDecimalPlaces
        }
    }
    
    private var waterNumberFormatter: NumberFormatter {
        if hasFractionalPart(vm.waterVolume) {
            NumberFormatter.oneDecimalPlaces
        } else {
            NumberFormatter.noDecimalPlaces
        }
    }
    
    private var prepNumberFormatter: NumberFormatter {
        if hasFractionalPart(vm.preparationTime) {
            NumberFormatter.oneDecimalPlaces
        } else {
            NumberFormatter.noDecimalPlaces
        }
    }
    
    private var prepTimeInterval: ClosedRange<Double> {
        if vm.type == "Cold Brew" {
            return 0...72
        } else {
            return 0...30
        }
    }
    
    private var prepTimeUnit: String {
        if vm.type == "Cold Brew" {
            return "hrs "
        } else {
            return "mins"
        }
    }
    
    private var removeButton: some View {
        Image(systemName: "x.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundColor(.red)
    }
    
    private func generateNewUUID(_ data: inout [String: Any]) {
        if data["id"] is UUID {
            data["id"] = UUID()
        } else if data["id"] is CKRecord.ID {
            let recordID = data["id"] as! CKRecord.ID
            data["id"] = recordID
        }
    }
}
