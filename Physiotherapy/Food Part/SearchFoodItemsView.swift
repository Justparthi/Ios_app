//
//  SearchFoodItemsView.swift
//  Physiotherapy
//
//  Created by Yash Patil on 20/10/23.
//

import SwiftUI

struct SearchFoodItemsView: View {
    //*****************
    @Environment(\.dismiss) var dismiss
    @ObservedObject var nutritionVM: BreakfastViewModel
    @ObservedObject var LunchVM: LunchViewModel
    @ObservedObject var snackVM: SnackViewModel
    @ObservedObject var DinnerVM: DinnerViewModel
    @State var from: Int
    
    @State var searchText: String = ""
    @State var goToAdd: Bool = false
    @State var isLoading: Bool = false
    @State var filteredNutrients: [Nutrient] = []
    @State var filteredItem: Item?
    @State private var isFetchingData = false
    @State private var dataFetchSucceeded = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search..", text: $searchText)
                    .frame(width: 350, height: 40)
                    .padding(.leading)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.ultraThinMaterial))
                    .onSubmit { search(for: searchText) }
                
                // The loading View is NOW WORKING , FIXED !!.
                // while resolving this made changes in ViewModels(breakfast,lunch,dinner)
                // added delays and retrying mechanism in fetching API
                
                
                
                
                if isLoading {
                    
                        
                        
                        VStack {
                            
                            Spacer()
                            CirclesLoaderView()
                            Spacer()
                        
                        
                        
                    }
                    
                    
                    
                    
                } else if nutritionVM
                    .retreivedItems.isEmpty {
                    ScrollView {
                        Text("Search for any Food item")
                            .font(.title)
                            .fontWeight(.medium)
                            .frame(height: 600)
                            .foregroundStyle(Color("newOrange"))
                    }
                } else  {
                    List {
                        ForEach(nutritionVM.retreivedItems) { item in
                            Button {
                                tappedItem(for: item)
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "carrot.fill")
                                    VStack(alignment: .leading, spacing: 10) {
                                        let text = searchText
                                        Text("\(text) (\(item.brand))")
                                        HStack {
                                            Text("\(item.serving.size.map { "\($0)" } ?? "")\(item.serving.measurement_unit)")
                                                .font(.callout)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Nutrition")
        }
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
        .sheet(isPresented: $goToAdd) {
            if self.filteredNutrients.isEmpty {
                CirclesLoaderView()
            }else {
                //******************
                AddView(vm: nutritionVM, vm1: LunchVM, vm2: snackVM, vm3: DinnerVM, from: from, nutrients: self.filteredNutrients, item: self.filteredItem, text: searchText)
            }
        }
        
        .onChange(of: nutritionVM.gotoNutrition) { _, newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                dismiss()
            }
        }
        .listStyle(.plain)
    }
}

//#Preview {
//    SearchFoodItemsView(vm: .init())
//        .environmentObject(FoodAPIManager())
//        .environmentObject(AddAppetiteViewModel())
//}


extension SearchFoodItemsView {
    
    //    func search(for text: String) {
    //        guard !searchText.isEmpty else { return }
    //        nutritionVM.getFoodItemsby(name: searchText)
    //    }
    
    func search(for text: String) {
        isLoading = true  // Set loading state to true before starting the loading process
        guard !searchText.isEmpty else {
            isLoading = false  // Set loading state to false if there's nothing to search
            return
        }
        
        nutritionVM.fetchDataFromAPI(foodName: searchText) { data, error in
            if error != nil {
                // Handle the error if needed
                isFetchingData = false
                dataFetchSucceeded = false
                return
            }
            // Process the result of the data loading here
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isLoading = false  // Set loading state to false when loading is complete
                dataFetchSucceeded = true
            }
            
        }
    }
    
    
    
    func tappedItem(for item: Item) {
        
        var filtered = item.nutrients
        
        let nutrients = item.nutrients
            // Remove elements based on the condition
            filtered.removeAll { nutrient in
                return !(nutrient.name.contains("Energy") || nutrient.name.contains("Protein") || nutrient.name.contains("Carbohydrate") ||
                         nutrient.name.contains("Total lipid"))
            }
        
        
        self.filteredNutrients = filtered
        self.filteredItem = item
        
        goToAdd = !self.filteredNutrients.isEmpty
    }
}

