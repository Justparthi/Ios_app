//
//  FoodDetail.swift
//  Physiotherapy
//
//  Created by Shagun on 20/05/23.
//

import SwiftUI

struct FoodDetail: View {
    
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            Image("yellow")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(Color(red: 0.983, green: 0.979, blue: 0.87))
                .frame(width: 450,height: 350)
                .padding(.bottom,560)
                .rotationEffect(Angle(degrees: 3))
                .opacity(5)
            
            VStack{
                HStack(spacing: 125){
                    Image(systemName: "chevron.backward")
                    Text("Nutrition").font(.system(size: 16))
                }.bold().padding(.trailing,140)
                
                Image("pancakes")
                    .resizable()
                    .frame(width: 354,height: 275).padding(.bottom,100)
                Button(action: {
                                isPresented = true
                            }) {
                                Image(systemName: "play.circle").resizable().foregroundColor(.black).frame(width: 50,height: 50)
                                    .padding(.bottom,340)
                            }
                            .sheet(isPresented: $isPresented) {
                                detail2()
                                    //.presentationDetents([.medium,.large])
                                    .presentationDetents([.fraction(0.35),.large])
                            }
            }.padding(.top,70)
        } .background(Color.orange)
    }
}

struct detail2: View{
    var body: some View{
        ZStack{
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Color("MyColor1").opacity(0.15))
            ScrollView{
                VStack(alignment:.leading){
                    HStack(spacing: 130){
                        VStack(alignment: .leading,spacing: 8){
                            Text("Blueberry Pancake")
                                .font(.system(size: 20,weight: .semibold))
                                .bold()
                            Text("by Ronald Richards")
                                .font(.system(size: 14))
                        }
                        Image(systemName: "heart.fill")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 20,height: 20)
                    }
                    
                    Text("Nutrition Breakdown").font(.system(size: 16,weight: .medium))
                        .padding(.top)
                        .padding(.bottom)
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack(spacing: 13){
                            ZStack{
                                RoundedRectangle(cornerRadius: 14).frame(width: 94,height: 38)
                                    .foregroundColor(Color("MyColor1").opacity(0.3))
                                HStack{
                                    Image(systemName: "flame.fill")
                                        .foregroundColor(.orange)
                                        .frame(width: 20,height: 20)
                                    Text("180 KCal")
                                        .font(.system(size: 12))
                                        .bold()
                                }
                                
                            }
                            ZStack{
                                RoundedRectangle(cornerRadius: 14).frame(width: 89,height: 38)
                                    .foregroundColor(Color("MyColor1").opacity(0.3))
                                HStack{
                                    Image("sunflowerOil")
                                        .frame(width: 20,height: 20)
                                    Text("30g Fats")
                                        .font(.system(size: 12))
                                        .bold()
                                }
                                
                            }
                            ZStack{
                                RoundedRectangle(cornerRadius: 14).frame(width: 119,height: 38)
                                    .foregroundColor(Color("MyColor1").opacity(0.3))
                                
                                HStack{
                                    Image(systemName: "fish.fill")
                                        .foregroundColor(.blue)
                                        .frame(width: 20,height: 20)
                                    Text("20g Proteins")
                                        .font(.system(size: 12))
                                        .bold()
                                }
                            }
                            ZStack{
                                RoundedRectangle(cornerRadius: 14).frame(width: 119,height: 38)
                                    .foregroundColor(Color("MyColor1").opacity(0.3))
                                
                                
                            }
                        }
                    }
                    Text("Description")
                        .font(.system(size: 21,weight: .medium))
                        .padding(.top)
                    Text("Pancakes are some people's favorite breakfast, who doesn't like pancakes? Especially with the real honey splash on top of the pancakes, of course everyone loves that! besides being read more.").font(.system(size: 12,weight: .regular))
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.top,10)
                        .frame(width: 319)
                    
                    VStack{
                        HStack(spacing: 20){
                            Text("Ingredients that will be needed to prepare the recipe").font(.system(size: 16))
                            Text("6 items").font(.system(size: 14,weight: .medium)).foregroundColor(.black.opacity(0.7))
                        } .frame(width:370)
                        .padding(.bottom)
                        .padding(.leading,-49)
                           
                        
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack(spacing:18){
                                VStack(alignment: .leading){
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.yellow.opacity(0.25))
                                            .frame(width: 80,height: 80)
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.black.opacity(0.05))
                                            .frame(width: 80,height: 80)
                                        
                                        Image("wheatFlour")
                                            
                                    }
                                    Text("Wheat Flour")
                                        .font(.system(size: 12))
                                    Text("100gr")
                                        .font(.system(size: 12))
                                        .foregroundColor(.black.opacity(0.7))
                                    
                                }
                                VStack(alignment: .leading){
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.yellow.opacity(0.25))
                                            .frame(width: 80,height: 80)
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.black.opacity(0.05))
                                            .frame(width: 80,height: 80)
                                        
                                        Image("sugar")
                                    }
                                    Text("Sugar")
                                        .font(.system(size: 12))
                                    Text("3 tbsp")
                                        .font(.system(size: 12))
                                        .foregroundColor(.black.opacity(0.7))
                                    
                                }
                                VStack(alignment: .leading){
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.yellow.opacity(0.25))
                                            .frame(width: 80,height: 80)
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.black.opacity(0.05))
                                            .frame(width: 80,height: 80)
                                        
                                        Image("bakingSoda")
                                    }
                                    Text("Baking Soda")
                                        .font(.system(size: 12))
                                    Text("3 tsp")
                                        .font(.system(size: 12))
                                        .foregroundColor(.black.opacity(0.7))
                                    
                                }
                                VStack(alignment: .leading){
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.yellow.opacity(0.25))
                                            .frame(width: 80,height: 80)
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(.black.opacity(0.05))
                                            .frame(width: 80,height: 80)
                                       Image("egg")
                                    }
                                    Text("Egg")
                                        .font(.system(size: 12))
                                    Text("2 items")
                                        .font(.system(size: 12))
                                        .foregroundColor(.black.opacity(0.7))
                                    
                                    
                                }
                            }

                        }
                        HStack{
                            Text("Steps for preparing").font(.system(size: 21,weight: .medium))
                        }.padding(.top)
                        
                    }.padding(.top)
                    
                }.padding(.leading,30)
                    .padding(.top,40)
            }
        }
       
    }
}

struct FoodDetail_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetail()
        detail2()
    }
}
