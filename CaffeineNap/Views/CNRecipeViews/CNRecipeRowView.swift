//
//  CNRecipeRowView.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 23.04.2024.
//

import SwiftUI

struct CNRecipeRowView: View {
    
    var recipe: CNRecipe
    
    var body: some View {
        HStack {
            Image(uiImage: recipe.createRecipeImage())
                .resizable()
                .aspectRatio(1.0, contentMode: .fill)
                .frame(width: 150, height: 150)
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .bold()
                    .font(.title2)
                    .minimumScaleFactor(0.75)
                    .lineLimit(1)
                HStack(alignment: .firstTextBaseline) {
                    Text("\(recipe.calculateRating(), specifier: "%.1f")").font(.callout)
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundColor(.yellow)
                        .scaledToFit()
                        .frame(width: 15)
                    Text(recipe.getRatingAmount()).font(.caption)
                }
                Text("by \(recipe.author.firstName) \(recipe.author.lastName)")
                    .font(.callout)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Text(recipe.type).font(.footnote)
                Text("\(recipe.caffeineAmount, specifier: "%.0f") mg").font(.footnote)
                Text(recipe.description)
                    .font(.footnote)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .foregroundColor(.white)
        .background(Color.brandPrimary)
        .cornerRadius(10.0)
    }
}

//#Preview {
//    CNRecipeRowView()
//}
