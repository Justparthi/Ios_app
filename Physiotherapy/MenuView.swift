//
//  MenuView.swift
//  Physiotherapy
//
//  Created by Yash Patil on 19/10/23.
//

import SwiftUI

enum MenuItems: String {
    case therapist = "Therapist"
    case exercises = "Exercises"
    case formCheckTool = "Form Check tool"
    case nutrition = "Nutrition"
    case bodyMeasurement = "Body measurement Tool"
    case pushNotifications = "Push Notifications"
    case profile = "Profile"
    case logOut = "Log Out"
}

struct MenuView: View {
    @State var recorder = Recorder()
    let items: [MenuItems] = [.therapist, .exercises ,.formCheckTool, .nutrition ,.bodyMeasurement ,.pushNotifications, .profile, .logOut]
    @State var selectedItem: MenuItems?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(items, id: \.rawValue) { item in
                        Button {
                            selectedItem = item
                        } label: {
                            HStack {
                                Image(systemName: "figure.run")
                                
                                Text(item.rawValue)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(Color(.customColor2))
                            )
                            .padding(.horizontal)
                        }.tint(.white)
                    }
                }
                .padding(.top)
                .navigationTitle("Menu")
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color(.orange), for: .navigationBar)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.orange))
            .navigationDestination(item: $selectedItem) { item in
                switch item {
                case .formCheckTool:
                    ContentView(recorder: recorder)
                case .nutrition:
                    Nutrition()
                case .bodyMeasurement:
                    BodyMeasurementView()
                        .toolbarRole(.browser)
                default: Text("NA")
                }
            }
        }
    }
}

#Preview {
    MenuView()
}
