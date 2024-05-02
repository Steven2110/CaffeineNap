//
//  CNRecipeDetailView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 23.04.2024.
//

import SwiftUI
import CloudKit

struct CNRecipeDetailView: View {
    
    @StateObject var vm: CNRecipeDetailViewModel

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    
    @State var ratingAnimation: Animation = .easeIn
    
    @State private var showEditForm: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Image(uiImage: vm.recipe.createRecipeImage())
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .blur(radius: 5.0)
                Image(uiImage: vm.recipe.createRecipeImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 300)
            }
            Divider()
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Image(uiImage: vm.recipe.author.createAvatarImage())
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        Text("\(vm.recipe.author.firstName) \(vm.recipe.author.lastName)")
                    }
                    Group {
                        Divider()
                        HStack(alignment: .firstTextBaseline) {
                            Text("\(vm.recipe.calculateRating(), specifier: "%.1f")").font(.title2)
                            Image(systemName: "star.fill")
                                .resizable()
                                .foregroundColor(.yellow)
                                .scaledToFit()
                                .frame(width: 20)
                        }
                        Text(vm.recipe.type).bold()
                        Text("\(vm.recipe.caffeineAmount, specifier: "%.0f") mg caffeine (\(vm.recipe.waterVolume, specifier: "%.0f") ml)")
                        Text("\(vm.recipe.preparationTime, specifier: "%.1f") mins preparation time")
                    }
                    Group {
                        Divider()
                        Text(vm.recipe.description)
                    }
                    Group {
                        Divider()
                        Text("What you need?")
                            .font(.title2)
                            .bold()
                        ForEach(Array(vm.recipe.tools.enumerated()), id: \.1.id) { (index, tool) in
                            Text("\(index + 1). \(tool.name) \(tool.getAmountAndOptionalDesc())")
                        }
                    }
                    Group {
                        Divider()
                        Text("Instructions")
                            .font(.title2)
                            .bold()
                        ForEach(vm.recipe.instructions.sorted(by: { $0.step < $1.step })) { instruction in
                            Text("\(instruction.step). \(instruction.instruction)")
                        }
                    }
                    Group {
                        Divider()
                        HStack {
                            Spacer()
                            Group {
                                HStack {
                                    ForEach(1..<maximumRating + 1, id: \.self) { number in
                                        Button {
                                            if number > vm.currentUserRating.rating {
                                                ratingAnimation = .easeIn
                                            } else {
                                                ratingAnimation = .easeOut
                                            }
                                            withAnimation(ratingAnimation) {
                                                vm.currentUserRating.rating = number
                                            }
                                        } label: {
                                            image(for: number)
                                                .resizable()
                                                .foregroundStyle(number > vm.currentUserRating.rating ? offColor : onColor)
                                                .frame(minWidth: 15, maxWidth: 30, minHeight: 15, maxHeight: 30)
                                        }.padding(.trailing, 10)
                                    }
                                }.buttonStyle(.plain)
                            }
                            Button {
                                Task { await vm.saveRating() }
                            } label: {
                               Text("Send")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.brandPrimary)
                                    .cornerRadius(5)
                            }
                            Spacer()
                        }
                    }
                }.padding([.leading, .top], 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(vm.recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await vm.startUp()
            }
        }
        .toolbar {
            if vm.isOwnRecipe {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") { showEditForm.toggle() }
                }
            }
        }
        .sheet(isPresented: $showEditForm, onDismiss: { Task { await vm.startUp() }}) {
            CNRecipeFormView(
                vm: CNRecipeFormViewModel(recipe: vm.recipe),
                isEdit: true
            )
        }
    }
    
    func image(for number: Int) -> Image {
        if number > vm.rating {
            offImage ?? onImage
        } else {
            onImage
        }
    }
}

//#Preview {
//    CNRecipeDetailView()
//}
