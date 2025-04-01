//
//  description.swift
//  Physiotherapy
//
//  Created by Shagun on 17/05/23.
//

import SwiftUI

struct description: View {
    
    //Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    @State private var isFormCheckToolShown = false
    @Binding var showScreen: Bool
    @State private var selectedOption = 0
    var time: String
    var reps: String
    var calories: Int
    var exerciseName: String
    var muscleInvolved = ["Abdomins", "Hip Flexors", "Obliques"]
    let options = ["Weekly", "Option 2", "Option 3"]
    var goalsAchieved: String
    var desc: String
    let percentage = ["88%", "88%", "88%", "88%"]
    let days = ["Sunday", "Saturday", "Friday", "Thurday"]
    let caloriesBurnt = ["109", "109", "109", "109"]
    var selectedWorkout: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        
        ScrollView(showsIndicators: false){
            ZStack{
                VStack(alignment: .leading){
                    
                    Text("Muscles Involved")
                        .font(.custom("cabin", size: 21)).bold()
                        .foregroundColor(brownColor)
                        .padding(.bottom,8)
                    
                    
                    HStack(spacing: 12){
                        ForEach(0..<muscleInvolved.count, id: \.self){index in
                            ZStack{
                                RoundedRectangle(cornerRadius: 20).frame(width: 102,height: 35)
                                    .foregroundColor(.white).shadow(radius: 5)
                                Text(muscleInvolved[index])
                                    .font(.custom("cabin", size: 17.5))
                                    .foregroundColor(brownColor)
                            }
                        }
                    }.padding(.bottom,8)
                    
                    
                    Text("About").font(.custom("cabin", size: 21)).bold().foregroundColor(brownColor)
                        .padding(.bottom,8)
                    HStack(spacing: 20){
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).frame(width: 94,height: 94)
                                .foregroundColor(.white).shadow(radius: 5)
                            VStack{
                                Image(systemName: "clock").resizable().frame(width: 30,height: 30)
                                Text(time).font(.custom("cabin", size: 15)).foregroundColor(brownColor)
                                Text("Minutes").font(.custom("cabin", size: 15)).foregroundColor(brownColor)
                                
                            }
                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).frame(width: 94,height: 94)
                                .foregroundColor(.white).shadow(radius: 5)
                            VStack{
                                Image(systemName: "repeat").resizable().frame(width: 30,height: 30).foregroundColor(.green)
                                Text(reps).font(.custom("cabin", size: 15)).foregroundColor(brownColor)
                                Text("Reps").font(.custom("cabin", size: 15)).foregroundColor(brownColor)
                                
                            }
                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 20).frame(width: 94,height: 94)
                                .foregroundColor(.white).shadow(radius: 5)
                            VStack{
                                Image("flame").resizable().frame(width: 30,height: 40)
                                Text("\(calories)").font(.custom("cabin", size: 15)).foregroundColor(brownColor)
                                Text("Calories").font(.custom("cabin", size: 15)).foregroundColor(brownColor)
                                
                            }
                        }
                        
                    }.padding(.bottom,8)
                    
                    Text(exerciseName).font(.custom("cabin", size: 21)).bold().foregroundColor(brownColor)
                        .padding(.bottom,8)
                    
                    Text(desc).font(.custom("cabin", size: 14)).frame(width: 320).foregroundColor(brownColor)
                        .padding(.bottom,8)
                    Text("Goal Achieved").font(.custom("cabin", size: 15)).bold().foregroundColor(brownColor)
                        .padding(.bottom,1)
                    Text("48.6%").font(.custom("cabin", size: 15)).bold().foregroundColor(brownColor)
                        .padding(.bottom,8)
                    
                    Spacer()
                    
//                    HStack(spacing: 150) {
//                        Text("Past Activity")
//                            .font(.custom("cabin", size: 17))
//                            .foregroundColor(brownColor)
//
//                        Picker(selection: $selectedOption,
//                               label: Text("Select an option")
//                            .foregroundColor(brownColor))
//                        {
//                            ForEach(0..<options.count, id: \.description) { i in
//                                Text(self.options[i])
//                                    .foregroundColor(.black)
//                            }
//                        }
//                        .pickerStyle(MenuPickerStyle())
//                    }
                    
                    VStack {
                        
//                        ForEach(0..<percentage.count, id: \.self){index in
//                            ZStack{
//                                RoundedRectangle(cornerRadius: 15).frame(width: 328,height: 49).foregroundStyle(Color(uiColor: UIColor(hex: "F59C4A", alpha: 1.0)!))
//                                HStack(spacing:113){
//                                    HStack{
//                                        Text(percentage[index]).font(.system(size: 16)).bold().foregroundColor(.white)
//                                        Text(days[index]).font(.system(size: 12)).bold().foregroundColor(.white)
//                                    }
//                                    HStack{
//                                        Image("flame")
//                                        Text("109 Colories").font(.system(size: 12)).bold().foregroundColor(.white)
//                                    }
//                                }
//                            }
//                        }
                        
                        ZStack{
                            if selectedWorkout == "Overhead squats" ||
                               selectedWorkout == "Back lunges" ||
                               selectedWorkout == "Glute bridges" ||
                               selectedWorkout == "Box jumps" {
                            RoundedRectangle(cornerRadius: 25)
                                .frame(width: 360, height: 82)
                                .foregroundColor(.white)
                                .shadow(radius: 5)

                            HStack(spacing: 35) {
                                Text("Start workout now!")
                                    .font(.system(size: 18))
                                    .bold()
                                    .foregroundColor(brownColor)

                                
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(width: 130, height: 51.18)
                                            .foregroundStyle(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                                        
                                        HStack {
                                            Button {
                                                isFormCheckToolShown = true
                                            } label: {
                                                Image(systemName: "play.circle.fill")
                                                    .foregroundColor(.white)
                                                Text("START")
                                                    .font(.system(size: 18))
                                                    .bold()
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }.padding(.leading,-15)
                    
                }.padding(.leading,22)
                    .padding(.top,20)
                    .padding()
                
            }.frame(width: 800, height: 800)
                .background(Color("newOrange"))
                .fullScreenCover(isPresented: $isFormCheckToolShown) {
                    FormCheckToolView()
                }
        }
    }
}

struct description_Previews: PreviewProvider {
    static var previews: some View {
        description(showScreen: .constant(false), time: "2", reps: "5", calories: 100, exerciseName: "Sit Ups", goalsAchieved: "48.6", desc: "Lorem ipsum dolor sit amet consectetur. Tellus consequat dui semper turpis justo egestas. Blandit sit egestas egestas enim amet viverra interdum. Cursus sodales tincidunt diam tortor sem quisque.", selectedWorkout: "WorkoutDemo")
    }
}

/*
struct description: View {
    @State private var selectedOption = 0
    let options = ["Weekly", "Option 2", "Option 3"]
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                Text("Muscles Involved").font(.system(size: 18)).bold().foregroundColor(Color("CustomColor"))
                    .padding(.bottom,8)
                HStack(spacing: 12){
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).frame(width: 92,height: 35)
                            .foregroundColor(.white).shadow(radius: 5)
                        Text("Abdominis")
                            .font(.system(size: 14))
                            .foregroundColor(Color("CustomColor"))
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).frame(width: 93,height: 35)
                            .foregroundColor(.white).shadow(radius: 5)
                        Text("Hip Flexors")
                            .font(.system(size: 14))
                            .foregroundColor(Color("CustomColor"))
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).frame(width: 92,height: 35)
                            .foregroundColor(.white).shadow(radius: 5)
                        Text("Obliques")
                            .font(.system(size: 14))
                            .foregroundColor(Color("CustomColor"))
                    }
                }.padding(.bottom,8)
                Text("About").font(.system(size: 18)).bold().foregroundColor(Color("CustomColor"))
                    .padding(.bottom,8)
                HStack(spacing: 20){
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).frame(width: 94,height: 94)
                            .foregroundColor(.white).shadow(radius: 5)
                        VStack{
                            Image(systemName: "clock").resizable().frame(width: 30,height: 30)
                            Text("2").font(.system(size: 14)).foregroundColor(Color("CustomColor"))
                            Text("Minutes").font(.system(size: 14)).foregroundColor(Color("CustomColor"))
                            
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).frame(width: 94,height: 94)
                            .foregroundColor(.white).shadow(radius: 5)
                        VStack{
                            Image(systemName: "repeat").resizable().frame(width: 30,height: 30).foregroundColor(.green)
                            Text("5").font(.system(size: 14)).foregroundColor(Color("CustomColor"))
                            Text("Reps").font(.system(size: 14)).foregroundColor(Color("CustomColor"))
                            
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 20).frame(width: 94,height: 94)
                            .foregroundColor(.white).shadow(radius: 5)
                        VStack{
                            Image("flame").resizable().frame(width: 30,height: 40)
                            Text("100").font(.system(size: 14)).foregroundColor(Color("CustomColor"))
                            Text("Calories").font(.system(size: 14)).foregroundColor(Color("CustomColor"))
                            
                        }
                    }
                    
                }.padding(.bottom,8)
                
                Text("Sit Ups").font(.system(size: 18)).bold().foregroundColor(Color("CustomColor"))
                    .padding(.bottom,8)
                Text("Lorem ipsum dolor sit amet consectetur. Tellus consequat dui semper turpis justo egestas. Blandit sit egestas egestas enim amet viverra interdum. Cursus sodales tincidunt diam tortor sem quisque.").font(.system(size: 12)).frame(width: 320).foregroundColor(Color("MyColor1"))
                    .padding(.bottom,8)
                Text("Goal Achieved").font(.system(size: 15)).bold().foregroundColor(Color("CustomColor"))
                    .padding(.bottom,1)
                Text("48.6%").font(.system(size: 22)).bold().foregroundColor(Color("MyColor1"))
                    .padding(.bottom,8)
                HStack(spacing: 150){
                    Text("Past Activity").font(.system(size: 15)).foregroundColor(Color("CustomColor"))
                    Picker(selection: $selectedOption, label: Text("Select an option").foregroundColor(Color("CustomColor"))) {
                        ForEach(0 ..< options.count) {
                            Text(self.options[$0])
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 15).frame(width: 328,height: 49).foregroundColor(Color("MyColor1")).opacity(0.7)
                        HStack(spacing:113){
                            HStack{
                                Text("88%").font(.system(size: 16)).bold().foregroundColor(.white)
                                Text("Sunday").font(.system(size: 12)).bold().foregroundColor(.white)
                            }
                            HStack{
                                Image("flame")
                                Text("109 Colories").font(.system(size: 12)).bold().foregroundColor(.white)
                            }
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 15).frame(width: 328,height: 49).foregroundColor(Color("MyColor1")).opacity(0.7)
                        HStack(spacing:100){
                            HStack{
                                Text("88%").font(.system(size: 16)).bold().foregroundColor(.white)
                                Text("Saturday").font(.system(size: 12)).bold().foregroundColor(.white)
                            }
                            HStack{
                                Image("flame")
                                Text("109 Colories").font(.system(size: 12)).bold().foregroundColor(.white)
                            }
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 15).frame(width: 328,height: 49).foregroundColor(Color("MyColor1")).opacity(0.7)
                        HStack(spacing:115){
                            HStack{
                                Text("88%").font(.system(size: 16)).bold().foregroundColor(.white)
                                Text("Friday").font(.system(size: 12)).bold().foregroundColor(.white)
                            }
                            HStack{
                                Image("flame")
                                Text("109 Colories").font(.system(size: 12)).bold().foregroundColor(.white)
                            }
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 15).frame(width: 328,height: 49).foregroundColor(Color("MyColor1")).opacity(0.7)
                        HStack(spacing:100){
                            HStack{
                                Text("88%").font(.system(size: 16)).bold().foregroundColor(.white)
                                Text("Thursday").font(.system(size: 12)).bold().foregroundColor(.white)
                            }
                            HStack{
                                Image("flame")
                                Text("109 Colories").font(.system(size: 12)).bold().foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.bottom,8)
                    ZStack{
                        RoundedRectangle(cornerRadius: 25).frame(width: 360,height: 82)
                            .foregroundColor(.white).shadow(radius: 5)
                        HStack(spacing: 35){
                            Text("Start workout now!").font(.system(size: 18)).bold().foregroundColor(Color("CustomColor"))
                            ZStack{
                                RoundedRectangle(cornerRadius: 20).frame(width: 130,height: 51.18)
                                    .foregroundColor(Color("CustomColor"))
                                HStack{
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(.white)
                                    Text("START")
                                        .font(.system(size: 18))
                                        .bold()
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }.padding(.leading,-15)
                
            }.padding(.leading,22)
                .padding(.top,20)
            
        }
    }
}

 */

