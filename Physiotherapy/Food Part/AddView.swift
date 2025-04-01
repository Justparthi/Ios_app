//
//  AddView.swift
//  Physiotherapy
//
//  Created by Yash Patil on 23/10/23.
//

import SwiftUI


struct AddView: View {
    //**************************
    @ObservedObject var vm: BreakfastViewModel
    @ObservedObject var vm1: LunchViewModel
    @ObservedObject var vm2: SnackViewModel
    @ObservedObject var vm3: DinnerViewModel
    @Environment(\.dismiss) var dismiss
    @State var from: Int
    @State var measurementMode: String = "quantity"  // Default to "quantity"
    
    
    let nutrients: [Nutrient]
    let item: Item?
    let text: String
    
    var quantities: [Int] = Array(1...20)
    var gramsQuantities: [Int] = Array(0...1000)
    
    var body: some View {
        GeometryReader{ geo in
            VStack(alignment: .leading, spacing: 30) {
                Text(text)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("newOrange"))
                
                VStack(alignment: .leading) {
                    Text("Nutrients breakdown")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("newOrange"))
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 20) {
                            ForEach(nutrients, id: \.name) { nutrient in
                                VStack(spacing: 12) {
                                    Text("🔥")
                                    if nutrient.name.contains("Total lipid") {
                                        Text("Fats")
                                            .fontWeight(.semibold)
                                    }else if nutrient.name.contains("Carbohydrate") {
                                        Text("Carbohydrates")
                                            .fontWeight(.semibold)
                                    }else {
                                        Text(nutrient.name)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    let double = nutrient.per_100g * Double(vm.quantity)
                                    
                                    let doubleStr = String(format: "%.2f", double)
                                    
                                    Text("\(calculateValue(for: nutrient))\(nutrient.measurement_unit.lowercased())")
                                        .fontWeight(.medium)
                                        .font(.system(size: 15))
                                }
                                .padding(7)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.thinMaterial))
                                
                            }
                        }
                    }
                }
                
                Picker("Measurement", selection: $measurementMode) {
                    Text("Grams").tag("grams")
                    Text("Quantity").tag("quantity")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                VStack(alignment: .leading) {
                                    Text(measurementMode == "grams" ? "Enter grams" : "Pick the quantity")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color("newOrange"))

                                    if measurementMode == "grams" {
                                        TextField("Grams", text: $vm.gramsString)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .keyboardType(.numberPad)
                                    } else {
                                        Picker("Quantity", selection: $vm.quantity) {
                                            ForEach(quantities, id: \.self) { quantity in
                                                Text("\(quantity)")
                                                    .foregroundStyle(Color("newOrange"))
                                            }
                                        }
                                    }
                                }
                .frame(width: 250, alignment: .trailing)
                .pickerStyle(.wheel)
                
                
                Button("Add") { Add() }
                    .frame(width: 145, height: 40)
                    .foregroundStyle(Color.white)
                    .background {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                    }
                    .padding(.leading, 110)
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background{
                ZStack {
                    Color(red: 0.13, green: 0.13, blue: 0.13)
                        .ignoresSafeArea(.all)
                    
                    Ellipse()
                        .foregroundColor(.clear)
                        .frame(width: 523, height: 563)
                        .background(Color(red: 1, green: 0.74, blue: 0.51).opacity(0.39))
                        .blur(radius: 700)
                }
            }
            .padding(.leading)
        }
        
    }
    func calculateValue(for nutrient: Nutrient) -> String {
        let value: Double

        if measurementMode == "grams" {
            value = nutrient.per_100g * 0.2 * Double(vm.grams)
        } else {
            value = nutrient.per_100g * Double(vm.quantity)
        }

        return String(format: "%.2f", value)
    }
}

//#Preview {
//    AddView(addVM: .init(), nutrients: [Nutrient(name: "Energy", measurement_unit: "G", per_100g: 12.5, rank: 0),
//                                        Nutrient(name: "Protein", measurement_unit: "G", per_100g: 12.5, rank: 0),
//                                        Nutrient(name: "Carbohydrates", measurement_unit: "G", per_100g: 12.5, rank: 0),
//                                        Nutrient(name: "Fats", measurement_unit: "G", per_100g: 12.5, rank: 0)], item: nil, text: "Pizza")
//    .environmentObject(AddAppetiteViewModel())
//}



extension AddView {
    
    func Add() {
        if let item = self.item {
            switch from {
            case 0:
                vm.add(item: item, grams: vm.grams)
            case 1:
                vm1.add(item: item, grams: vm.grams)
            case 2:
                vm2.add(item: item, grams: vm.grams)
            case 3:
                vm3.add(item: item, grams: vm.grams)
            default:
                return
            }

        } else {
            print("Item is nil")
        }
        vm.gotoNutrition = true

        dismiss()
    }
    
}
