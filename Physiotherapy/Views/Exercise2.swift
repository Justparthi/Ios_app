//
//  Exercise2.swift
//  Physiotherapy
//
//  Created by Shagun on 17/05/23.
//

import SwiftUI
import AVKit
import Firebase
import FirebaseStorage

struct Exercise2: View {
    
    //Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")


    @State private var showScreen = true
    @State private var isPresented = false
    @State private var descriptionWidth: CGFloat = 0
    @State private var goalsAchieved = "48.6"
    @State private var reps = "5"
    @State private var calories = 100
    @State private var time = "2"
    @State private var exerciseDescription = "Lorem ipsum dolor sit amet consectetur. Tellus consequat dui semper turpis justo egestas. Blandit sit egestas egestas enim amet viverra interdum. Cursus sodales tincidunt diam tortor sem quisque."
    @State private var video : URL? = URL(string: "https://firebasestorage.googleapis.com:443/v0/b/physiotherapy-eb4bb.appspot.com/o/exercises%2F1701025834136sit-ups.mp4?alt=media&token=6b38895c-501b-43f1-860b-71bdc7b03773")
    var exercise: String
    var selectedName: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        //Screen ZStack
        ZStack{
            GeometryReader{geo in
                VStack(alignment: .leading){
                    Button(action: {
                        print("==========selectedName", selectedName)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color("newOrange"))
                            .bold()
                    }
                    .padding(.top,20)
                    .padding(.leading,-120)
                    
                    ScrollView{
                        VideoPlayer(player: AVPlayer(url: video!))
                            .frame(width:400,height: 500)
                            .padding(.top,-125)
                        description(showScreen: $showScreen, time: time, reps: reps, calories: calories, exerciseName: exercise, goalsAchieved: goalsAchieved, desc: exerciseDescription, selectedWorkout: selectedName)
                    }
                    .frame(width: 100, height: 750)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
            }
            
        }
        .onAppear{
            playVideoFromStorage()
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
    
    func  playVideoFromStorage() {
        let StorageRef = Storage.storage().reference().child("exercises/1701025834136sit-ups.mp4")
        StorageRef.downloadURL { (url,error) in
            guard let videoURL = url, error == nil else {
                print("Error getting download URL: \(error?.localizedDescription ?? "")")
                return
            }
            print(videoURL)
            video = videoURL
           
        }
    }
}


struct Exercise2_Previews: PreviewProvider {
    static var previews: some View {
        Exercise2(exercise: "crunches", selectedName: "ExcerciseDemo")
    }
}

//extension HorizontalAlignment {
//    private enum CustomAlignment: AlignmentID {
//        static func defaultValue(in context: ViewDimensions) -> CGFloat {
//            context[HorizontalAlignment.center]
//        }
//    }
//
//    static let customAlignment = HorizontalAlignment(CustomAlignment.self)
//}


/*

struct Exercise2: View {
    @State private var isPresented = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Image("yellow")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundColor(Color(red: 0.983, green: 0.979, blue: 0.87))
                .frame(width: 450,height: 350)
                .padding(.bottom,560)
                .rotationEffect(Angle(degrees: 3))
                .opacity(5)
            Image("crunches")
                .resizable()
                .scaledToFill()
                .frame(width: 400,height: 500).frame(height: 750,alignment: .top)
            Rectangle().foregroundColor(Color("CustomColor").opacity(0.3))
            VStack{
                HStack(spacing: 300){
                    //chevron.backward
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "chevron.backward")
                                        .foregroundColor(.black)
                                        .bold()
                                }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 30).foregroundColor(Color("MyColor2")).frame(width:30,height: 30)
                            .shadow(radius: 2)
                        Image(systemName: "heart")
                    }
                }
                .padding(.bottom,200)
                
                Button(action: {
                                isPresented = true
                            }) {
                                Image(systemName: "play.circle").resizable().foregroundColor(.white).frame(width: 50,height: 50)
                                    .padding(.bottom,400)
                            }
                            .sheet(isPresented: $isPresented) {
                                description()
                                    .presentationDetents([.medium,.large])
                                    .presentationDetents([.fraction(0.35),.large])
                            }
            }
        }
    }
}

struct Exercise2_Previews: PreviewProvider {
    static var previews: some View {
        Exercise2()
    }
}
*/
