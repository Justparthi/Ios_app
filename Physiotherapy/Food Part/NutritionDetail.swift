//
//  NutritionDetail.swift
//  Physiotherapy
//
//  Created by Yash Patil on 21/10/23.
//

import SwiftUI

struct NutritionDetail: View {
    let ingredients: [Ingredients] = [
        Ingredients(item: "Wheat Flour", weight: "100g"),
        Ingredients(item: "Sugar", weight: "3tbsp"),
        Ingredients(item: "Baking soda", weight: "2 tbsp"),
        Ingredients(item: "Eggs", weight: "2 items")]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                Image("pancakes")
                    .resizable()
                    .scaledToFit()
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Blueberry Pancake")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("By Ronald Richards")
                        .foregroundStyle(Color.gradient)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Nutrition Breakdown")
                        .font(.title3)
                        .fontWeight(.medium)
                    HStack {
                        Text("🔥 180 kCal")
                            .padding(7)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.ultraThinMaterial))
                        Text("🧀 30g Fats")
                            .padding(7)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.ultraThinMaterial))
                        
                        Text("🐟 20g Proteins")
                            .frame(width: 130, height: 35)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.ultraThinMaterial))
                        
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Description")
                        .font(.title3)
                        .fontWeight(.medium)
                    Text("""
    Pancakes are some people's favourite breakfast, who doesn't like pancakes? Especially with the real honey spash on top of the pancakes, of course everyone loves that!.
    """)
                    .font(.callout)
                }
                
                VStack(alignment: .leading) {
                    Text("Ingredients that will be needed to prepare the recipe")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(ingredients) { ingredient in
                                VStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(.ultraThinMaterial)
                                    Text(ingredient.item)
                                        .fontWeight(.medium)
                                    Text(ingredient.weight)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .scrollIndicators(.hidden)
        .padding(.vertical)
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gradient)
        .ignoresSafeArea()
    }
}

#Preview {
    NutritionDetail()
}
