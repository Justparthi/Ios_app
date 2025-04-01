//
//  Nutrition.swift
//  Physiotherapy
//
//  Created by Manish Jawale on 02/06/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct Nutrition: View {
    
    @StateObject var nutritionVM = BreakfastViewModel()
    @StateObject var lunchVM = LunchViewModel()
    @StateObject var dinnerVM = DinnerViewModel()
    @StateObject var snackVM = SnackViewModel()
    @State var from: Int = 0
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    @State private var isDatePickerVisible = false
    @State private var selectedDate = Date()
    @State private var gotoFoodList: Bool = false
    @State private var breakfastExpanded = false
    @State private var lunchExpanded = false
    @State private var snackExpanded = false
    @State private var dinnerExpanded = false
    
    @State private var fetchedCal = "0"
    @State private var fetchedProtein = "0"
    @State private var fetchedCarbs = "0"
    @State private var fetchedFat = "0"
    
    @State private var floatCal = 0.0
    @State private var floatProtein = 0.0
    @State private var floatCarbs = 0.0
    @State private var floatFat = 0.0
    
    @State private var selectedNutrientView: NutrientView = .calories
    
    
    var totalCalories: String {
        updateCalories()
    }
    
    var totalFats: String {
        updateFats()
    }
    
    var totalCarbs: String {
        updateCarbs()
    }
    
    var totalProteins: String {
        updateProtein()
    }
    
    
    @State private var isHomeScreenPresented = false
    
    
    init() {
        updateCalories()
    }
    
    var progress: CGFloat = 0.6
    
    var Minus = Image(systemName: "minus.circle.fill")
    var Plus = Image(systemName: "plus.circle.fill")
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        
        
        NavigationStack {
            VStack {
                Image(systemName: "xmark")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .padding(8)
                    .offset(x:-150)
                    .onTapGesture {
                        isHomeScreenPresented = true
                        print("Close button tapped")
                    }
                //                Text(selectedNutrientView.values ?? "Nutrition")
                //                    .font(.system(size: 40, weight: .bold))
                //                    .foregroundStyle(Color("newOrange"))
                ScrollView {
                    VStack {
                        VStack(spacing: 26) {
                            
                            CalenderViews
                            
                            caloriesView
                            HStack(spacing: 40) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Circle()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(Color.orange)
                                        Text("Calories \(totalCalories)")
                                            .foregroundColor(.white)
                                    }
                                    HStack {
                                        Circle()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(Color.pink)
                                        Text("Carbohydrate \(totalCarbs)")
                                            .foregroundColor(.white)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    HStack {
                                        Circle()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(Color.green)
                                        Text("Protein \(totalProteins)")
                                            .foregroundColor(.white)
                                    }
                                    HStack {
                                        Circle()
                                            .frame(width: 20, height: 20)
                                            .foregroundStyle(Color.mint)
                                        Text("Fats \(totalFats)")
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color(uiColor: UIColor(hex: "D9D9D9", alpha: 1.0)!))
                                    .frame(width: 125, height: 30)
                                HStack {
                                    Text("\(selectedNutrientView.total)")
                                        .font(.custom("Raleway", size: 24))
                                        .foregroundStyle(.black)
                                    
                                    Text("Total")
                                        .font(.system(size: 10))
                                        .foregroundStyle(.black)
                                }
                            }
                            VStack {
                                breakfastItems
                                
                                lunchItems
                                
                                snackItems
                                
                                dinnerItems
                            }
                            
                        }
                        .frame(width: 350)
                    }
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                .fullScreenCover(isPresented: $isHomeScreenPresented) {
                    Physiotherapy(selectedTab: 0)
                }
                //****************
                .navigationDestination(isPresented: $gotoFoodList) {
                    SearchFoodItemsView(nutritionVM: nutritionVM, LunchVM: lunchVM, snackVM: snackVM, DinnerVM: dinnerVM, from: from)
                    
                }                //            .navigationTitle("Nutrition")
            }
            .onAppear {
                getGoalNutrients()
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
            
            
        }
        
    }
    
}

struct OptionView: View {
    var imageName: String = "circle.fill"
    
    let title, weight, calories : String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.black)
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.black)
                HStack {
                    Text(weight)
                    Text(calories)
                }
                .font(.caption)
                .foregroundStyle(.white)
            }
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "plus")
                    .frame(width: 25, height: 25)
                    .background(.white)
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    Nutrition()
        .environmentObject(BreakfastViewModel())
}

extension Nutrition {
    
    enum NutrientView {
        case calories
        case protein
        case carbohydrates
        case fats
        var values: String?{
            switch self {
            case .calories:
                return "Calories"
            case .protein:
                return "Protein"
            case .carbohydrates:
                return "Carbohydrate"
            case .fats:
                return "Fats"
            }
        }
        var total: String{
            switch self {
            case .calories:
                return Nutrition().updateCalories()
            case .protein:
                return Nutrition().updateProtein()
            case .carbohydrates:
                return Nutrition().updateCarbs()
            case .fats:
                return Nutrition().updateFats()
            }
        }
        
    }
    
    
    
    var CalenderViews: some View {
        HStack(spacing: 60) {
            //            VStack {
            //                Button {
            //                    isDatePickerVisible = true
            //                } label: {
            //                    Image(systemName: "calendar")
            //                        .font(.system(size: 24))
            //                        .foregroundColor(Color("CustomColor"))
            //                        .background(RoundedRectangle(cornerRadius: 13)
            //                            .frame(width: 44, height: 44)
            //                            .foregroundColor(Color(red: 0.62, green: 0.525, blue: 1))
            //                            .opacity(0.2))
            //                }
            //            }
            
            Spacer()
            
            Text("\(selectedDate, formatter: dateFormatter)")
                .fontWeight(.medium)
                .foregroundStyle(.white)
            
            Spacer()
        }
    }
    
    var caloriesView: some View {
        HStack(spacing: 50) {
            //            Button {
            //                switch selectedNutrientView {
            //                case .calories:
            //                    selectedNutrientView = .fats
            //                case .protein:
            //                    selectedNutrientView = .calories
            //                case .carbohydrates:
            //                    selectedNutrientView = .protein
            //                case .fats:
            //                    selectedNutrientView = .carbohydrates
            //                }
            //            } label: {
            //                Image(systemName: "chevron.left.circle.fill")
            //                    .fontWeight(.thin)
            //                    .font(.system(size: 25))
            //                    .foregroundColor(Color("newOrange"))
            //            }
            
            ZStack(alignment: .center) {
                //                VStack {
                //                    Text("\(selectedNutrientView.total)")
                //
                //                        .font(.title)
                //                        .fontWeight(.semibold)
                //                        .foregroundStyle(.white)
                //
                //                    Text(selectedNutrientView.values ?? "Nutrition")
                //                        .font(.system(size: 16))
                //                        .fontWeight(.semibold)
                //                        .foregroundStyle(.white)
                //                }
      
                Circle()
                    .trim(from: 0.0, to: floatCal == 0 ? 0.85 : floatCal)
                    .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round))
                    .frame(width: 218, height: 218)
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(Color("newOrange"))
                    
                Circle()
                    .trim(from: 0.0, to: floatProtein == 0 ? 0.90 : floatProtein)
                    .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round))
                    .frame(width: 164, height: 164)
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(Color.green)

                Circle()
                    .trim(from: 0.0, to: floatCarbs == 0 ? 0.80 : floatCarbs)
                    .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round))
                    .frame(width: 112, height: 112)
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(Color.pink)
                
                
                Circle()
                    .trim(from: 0.0, to: floatFat == 0 ? 0.70 : floatFat)
                    .stroke(style: StrokeStyle(lineWidth: 24, lineCap: .round))
                    .frame(width: 58, height: 58)
                    .rotationEffect(.degrees(-90))
                    .foregroundStyle(Color.mint)

                VStack(spacing: 16) {
                    Spacer()
                    Text("\(selectedNutrientView.total)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity,maxHeight: 6)
                        
                    Text("\(selectedNutrientView.total)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity,maxHeight: 12)
                        
                    Text("\(selectedNutrientView.total)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity,maxHeight: 12)
                        
                    Text("\(selectedNutrientView.total)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity,maxHeight: 12)
                        
                    
                }
                .frame(width: 218, height: 230)
               
 
            }
            
            //            Button {
            //                switch selectedNutrientView {
            //                case .calories:
            //                    selectedNutrientView = .protein
            //                case .protein:
            //                    selectedNutrientView = .carbohydrates
            //                case .carbohydrates:
            //                    selectedNutrientView = .fats
            //                case .fats:
            //                    selectedNutrientView = .calories
            //                }
            //            } label: {
            //                Image(systemName: "chevron.right.circle.fill")
            //                    .fontWeight(.thin)
            //                    .font(.system(size: 25))
            //                    .foregroundColor(Color("newOrange"))
            //            }
        }
    }
    
    var breakfastItems: some View {
        VStack(spacing: 10) {
            HStack {
                Button {
                    withAnimation(.spring()) {
                        breakfastExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text("Breakfast")
                            .font(.title)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
                
                Button {
                    gotoFoodList = true
                    from = 0
                } label: {
                    Text(Plus)
                        .font(.title)
                        .foregroundColor(.white)
                }
                
            }.padding()
                .background{ RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(uiColor: UIColor(hex: "A0A0A0", alpha: 0.3)!)) }
            
            if breakfastExpanded {
                
                VStack {
                    if nutritionVM.items.isEmpty {
                        Text("Add items for Breakfast")
                            .foregroundStyle(.black)
                            .font(.headline)
                            .fontWeight(.medium)
                            .frame(width: 250, height: 35)
                            .padding(.horizontal, 10)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.thinMaterial))
                    }else {
                        ForEach(nutritionVM.items, id: \.name) { item in
                            
                            let size = item.serving.size ?? 1 * nutritionVM.quantity
                            let weight = "\(size) \(item.serving.measurement_unit)"
                            
                            let calories = calculateCalories(for: item)
                            OptionView(title: item.brand, weight: weight, calories: calories)
                                .frame(width: 320, height: 65)
                                .padding(.horizontal, 10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.gray.opacity(0.3)))
                        }
                    }
                }
            }
            
        }
    }
    
    var lunchItems: some View {
        VStack(spacing: 10) {
            HStack {
                Button {
                    withAnimation(.spring()) {
                        lunchExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text("Lunch")
                            .font(.title)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
                
                Button {
                    gotoFoodList = true
                    from = 1
                } label: {
                    Text(Plus)
                        .font(.title)
                        .foregroundColor(.white)
                }
                
            }
            .padding()
            .background{ RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(uiColor: UIColor(hex: "A0A0A0", alpha: 0.3)!)) }
            
            
            if lunchExpanded {
                
                VStack {
                    if lunchVM.items.isEmpty {
                        Text("Add items for Lunch")
                            .foregroundStyle(.black)
                            .font(.headline)
                            .fontWeight(.medium)
                            .frame(width: 250, height: 35)
                            .padding(.horizontal, 10)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.thinMaterial))
                    }else {
                        ForEach(lunchVM.items, id: \.name) { item in
                            
                            let size = item.serving.size ?? 1 * lunchVM.quantity
                            let weight = "\(size) \(item.serving.measurement_unit)"
                            
                            let calories = calculateCalories(for: item)
                            
                            OptionView(title: item.brand, weight: weight, calories: calories)
                                .frame(width: 320, height: 65)
                                .padding(.horizontal, 10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.gray.opacity(0.3)))
                        }
                    }
                }
            }
            
        }
    }
    
    
    var snackItems: some View {
        VStack(spacing: 10) {
            HStack {
                Button {
                    withAnimation(.spring()) {
                        snackExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text("Snack")
                            .font(.title)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
                
                Button {
                    gotoFoodList = true
                    from = 2
                } label: {
                    Text(Plus)
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background{ RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color(uiColor: UIColor(hex: "A0A0A0", alpha: 0.3)!)) }
            
            
            if snackExpanded {
                
                VStack {
                    //*****************
                    //MARK: After adding snacks DataModel change lunchVM to snackVM
                    
                    if snackVM.items.isEmpty {
                        Text("Add items for Snack")
                            .foregroundStyle(.black)
                            .font(.headline)
                            .fontWeight(.medium)
                            .frame(width: 250, height: 35)
                            .padding(.horizontal, 10)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.thinMaterial))
                    }else {
                        
                        ForEach(snackVM.items, id: \.name) { item in
                            
                            let size = item.serving.size ?? 1 * snackVM.quantity
                            let weight = "\(size) \(item.serving.measurement_unit)"
                            
                            let calories = calculateCalories(for: item)
                            
                            OptionView(title: item.brand, weight: weight, calories: calories)
                                .frame(width: 320, height: 65)
                                .padding(.horizontal, 10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.gray.opacity(0.3)))
                        }
                        
                    }
                }
            }
            
        }
    }
    
    var dinnerItems: some View {
        VStack(spacing: 10) {
            HStack {
                Button {
                    withAnimation(.spring()) {
                        dinnerExpanded.toggle()
                    }
                } label: {
                    HStack {
                        Text("Dinner")
                            .font(.title)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
                
                Button {
                    gotoFoodList = true
                    from = 3
                } label: {
                    Text(Plus)
                        .font(.title)
                        .foregroundColor(.white)
                }
                
            }.padding()
                .background{ RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(uiColor: UIColor(hex: "A0A0A0", alpha: 0.3)!)) }
            
            
            if dinnerExpanded {
                
                VStack {
                    if dinnerVM.items.isEmpty {
                        Text("Add items for Dinner")
                            .foregroundStyle(.black)
                            .font(.headline)
                            .fontWeight(.medium)
                            .frame(width: 250, height: 35)
                            .padding(.horizontal, 10)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(.thinMaterial))
                        
                    }else {
                        ForEach(dinnerVM.items, id: \.name) { item in
                            
                            let size = item.serving.size ?? 1 * dinnerVM.quantity
                            let weight = "\(size) \(item.serving.measurement_unit)"
                            
                            let calories = calculateCalories(for: item)
                            
                            OptionView(title: item.brand, weight: weight, calories: calories)
                                .frame(width: 320, height: 65)
                                .padding(.horizontal, 10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(.gray.opacity(0.3)))
                        }
                    }
                }
            }
        }
    }
}


extension Nutrition {
    func calculateCalories(for item: Item) -> String {
        let nutrient = item.nutrients.first { $0.name.contains("Energy") }
        let calories = "\(Int(nutrient?.per_100g ?? 20) * nutritionVM.quantity) KCAL"
        if calories.isEmpty {
            return "256 KCAL"
        }else {
            return calories
        }
    }
    
    func getGoalNutrients() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let userid = user.uid
        let db = Firestore.firestore()
        db.collection("Users").document(userid).collection("nutrition").getDocuments { snapshot, _ in
            if let snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    fetchedCal = data["calories"] as? String ?? ""
                    fetchedProtein = data["proteins"] as? String ?? ""
                    fetchedCarbs = data["carbohydrates"] as? String ?? ""
                    fetchedFat = data["fats"] as? String ?? ""
                }
            }
        }
        floatCal = (Double(fetchedCal) ?? 0.0 ) / 100.0
        floatProtein = (Double(fetchedProtein) ?? 0.0 ) / 100.0
        floatCarbs = (Double(fetchedCarbs) ?? 0.0 ) / 100.0
        floatFat = (Double(fetchedFat) ?? 0.0) / 100.0
        print("Fetched Goal Nutrient values \(fetchedCal) \(fetchedProtein) \(fetchedCarbs) \(fetchedFat)")
    }
    
    
    func updateCalories() -> String {
        let breakCal = nutritionVM.items.map { $0.serving.size ?? 1 }.reduce(0, +)
        let lunchCal = lunchVM.items.map { $0.serving.size ?? 1 }.reduce(0, +)
        let snackCal = snackVM.items.map { $0.serving.size ?? 1 }.reduce(0, +)
        let dinnerCal = dinnerVM.items.map { $0.serving.size ?? 1 }.reduce(0, +)
        let totalCalories = breakCal + lunchCal + snackCal + dinnerCal
        print("Breakfast Calories: \(breakCal)")
        print("Lunch Calories: \(lunchCal)")
        print("Snack Calories: \(snackCal)")
        print("Dinner Calories: \(dinnerCal)")
        print("Total Calories: \(totalCalories)")
        return String(totalCalories)
        
    }
    
    func updateCarbs() -> String {
        let breakCarbs = nutritionVM.items.map { Int(Double($0.serving.size ?? 1) * 0.9) }.reduce(0, +)
        let lunchCarbs = lunchVM.items.map { Int(Double($0.serving.size ?? 1) * 0.9) }.reduce(0, +)
        let snackCarbs = snackVM.items.map { Int(Double($0.serving.size ?? 1) * 0.9) }.reduce(0, +)
        let dinnerCarbs = dinnerVM.items.map { Int(Double($0.serving.size ?? 1) * 0.9) }.reduce(0, +)
        
        let totalCarbs = breakCarbs + lunchCarbs + snackCarbs + dinnerCarbs
        return String(totalCarbs)
    }
    
    func updateProtein() -> String {
        let breakProteins = nutritionVM.items.map { Int(Double($0.serving.size ?? 1) * 0.4) }.reduce(0, +)
        let lunchProteins = lunchVM.items.map { Int(Double($0.serving.size ?? 1) * 0.4) }.reduce(0, +)
        let snackProteins = snackVM.items.map { Int(Double($0.serving.size ?? 1) * 0.4) }.reduce(0, +)
        let dinnerProteins = dinnerVM.items.map { Int(Double($0.serving.size ?? 1) * 0.4) }.reduce(0, +)
        
        let totalProteins = breakProteins + lunchProteins + snackProteins + dinnerProteins
        return String(totalProteins)
    }
    
    func updateFats() -> String {
        let breakFats = nutritionVM.items.map { Int(Double($0.serving.size ?? 1) * 0.2) }.reduce(0, +)
        let lunchFats = lunchVM.items.map { Int(Double($0.serving.size ?? 1) * 0.2) }.reduce(0, +)
        let snackFats = snackVM.items.map { Int(Double($0.serving.size ?? 1) * 0.2) }.reduce(0, +)
        let dinnerFats = dinnerVM.items.map { Int(Double($0.serving.size ?? 1) * 0.2) }.reduce(0, +)
        
        let totalFats = breakFats + lunchFats + snackFats + dinnerFats
        return String(totalFats)
    }
    
}
