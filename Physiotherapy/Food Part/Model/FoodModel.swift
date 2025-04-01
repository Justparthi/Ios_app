//
//  FoodModel.swift
//  Physiotherapy
//
//  Created by Yash Patil on 22/10/23.
//

import Foundation

struct FoodItems: Decodable {
    let items: [Item]
}

struct Item: Codable, Identifiable {
    let id = UUID()
    let name, brand, ingredients: String
    var nutrients: [Nutrient]
    let serving: Serving
    var grams: Int?
}

struct Nutrient: Codable {
    let name, measurement_unit: String
    var per_100g: Double
    let rank: Int
}

struct Serving: Codable {
    let size: Int?
    let measurement_unit: String
}

struct Ingredients: Identifiable {
    let id = UUID()
    let item, weight: String
}

struct Nutrients: Identifiable {
    let id = UUID()
    let nutrient, weightage: String
}
