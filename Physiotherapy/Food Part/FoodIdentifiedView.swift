//
//  FoodIdentifiedView.swift
//  Physiotherapy
//
//  Created by Yash Patil on 20/10/23.
//

import SwiftUI


struct FoodIdentifiedView: View {
    
    let nutrients: [Nutrients] = [
        Nutrients(nutrient: "Carbohydrates", weightage: "25g"),
        Nutrients(nutrient: "Proteins", weightage: "40g"),
        Nutrients(nutrient: "Calories", weightage: "15g"),
        Nutrients(nutrient: "Fat", weightage: "25g")]
    
    var body: some View {
        VStack(spacing: 20) {
            Button {
                
            } label: {
                Image(systemName: "camera.fill")
                    .foregroundStyle(.black)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.green))
            }
            
            Text("Scan the food items to get the nutrient values")
                .frame(width: 190)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Food item: Blueberry Pancake")
                .font(.title2)
                .fontWeight(.semibold)
            
            Image("pancakes")
                .resizable()
                .scaledToFit()
            
            VStack(alignment: .leading) {
                ForEach(nutrients) { item in
                    HStack(spacing: 20) {
                        Text(item.nutrient)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color("CustomColor2"))
                            .clipShape(Capsule())
                        Spacer()
                        
                        Text(item.weightage)
                            .padding(10)
                            .background(.white)
                            .clipShape(Circle())
                    }
                    .frame(width: 250)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("orangeColor"))
    }
}

#Preview {
    FoodIdentifiedView()
}
