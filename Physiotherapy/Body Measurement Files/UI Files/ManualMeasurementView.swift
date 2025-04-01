//
//  ManualMeasurementView.swift
//  Physiotherapy
//
//  Created by Yash Patil on 26/10/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import FirebaseFirestore

struct Measurements {
    static let height = "height"
    static let shoulders = "shoulders"
    static let arms = "arms"
    static let waist = "waist"
    static let legs = "legs"
}

class ManualMeasurementViewModel: ObservableObject {
    @Published var height: Double = 0
    @Published var shoulders: Double = 0
    @Published var waist: Double = 0
    @Published var arms: Double = 0
    @Published var legs: Double = 0

    var userId: String?

    private let userdb = Firestore.firestore().collection("Users")

    init() {
        do {
            let user = try AuthenticationManager.shared.getAuthenticatedUser()
            self.userId = user.uid
            print("Worked")
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func save() async {
        guard height != 0,
              shoulders != 0,
              arms != 0,
              waist != 0,
              legs != 0,
              let userId = userId
        else {
            print("One of the parameters has a value of 0 or userId is nil")
            return
        }

        let document: [String: Any] = [
            "userId": userId,
            Measurements.height: height,
            Measurements.waist: waist,
            Measurements.arms: arms,
            Measurements.shoulders: shoulders,
            Measurements.legs: legs
        ]

        do {
            try await userdb.document(userId)
                .collection("Body Measurements")
                .document()
                .updateData(document)
        } catch {
            print("Error updating document: \(error.localizedDescription)")
            setDataToFirestore(doc: document, for: userId)
        }
    }

    func setDataToFirestore(doc document: [String: Any], for userId: String) {
        userdb.document(userId)
            .collection("Body Measurements")
            .document()
            .setData(document)
    }
}

struct ManualMeasurementView: View {
    @StateObject var firestoreVM = ManualMeasurementViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var isMeasureAgainPressed = false
    @State private var isDonePressed = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 15) {
                    HStack {
                                        Text("Height (cm)")
                                            .fontWeight(.medium)
                                        Spacer()
                                        
                                        Text("\(firestoreVM.height.upToTwoDecimal())")
                                            .frame(width: 60, height: 50)
                                            .background(RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.white))
                                    }
                                    
                                    Slider(value: $firestoreVM.height, in: 0...200)
                                }
                                
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("Shoulders (cm)")
                                            .fontWeight(.medium)
                                        Spacer()
                                        
                                        Text("\(firestoreVM.shoulders.upToTwoDecimal())")
                                            .frame(width: 60, height: 50)
                                            .background(RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.white))
                                    }
                                    Slider(value: $firestoreVM.shoulders, in: 0...150)
                                }
                                    VStack(spacing: 15) {
                                        HStack {
                                            Text("Waist (cm)")
                                                .fontWeight(.medium)
                                            Spacer()
                                            
                                            Text("\(firestoreVM.waist.upToTwoDecimal())")
                                                .frame(width: 60, height: 50)
                                                .background(RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(.white))
                                        }
                                        Slider(value: $firestoreVM.waist, in: 0...150)
                                    }
                                    
                                    VStack(spacing: 15) {
                                        HStack {
                                            Text("Arms (cm)")
                                                .fontWeight(.medium)
                                            Spacer()
                                            
                                            Text("\(firestoreVM.arms.upToTwoDecimal())")
                                                .frame(width: 60, height: 50)
                                                .background(RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(.white))
                                        }
                                        Slider(value: $firestoreVM.arms, in: 0...150)
                                    }
                                    
                                    VStack(spacing: 15) {
                                        HStack {
                                            Text("Legs (cm)")
                                                .fontWeight(.medium)
                                            Spacer()
                                            
                                            Text("\(firestoreVM.legs.upToTwoDecimal())")
                                                .frame(width: 60, height: 50)
                                                .background(RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(.white))
                                        }
                                        Slider(value: $firestoreVM.legs, in: 0...150)
                                    }
                
                HStack {
                                    Spacer()

                                    Button("Done") {
                                        // Set the flag to indicate "Done" is pressed
                                        isDonePressed = true
                                        print("DEBUG:",$isDonePressed)
                                        Task {
                                            // Save the measurements
                                            await firestoreVM.save()
//                                            // Dismiss the view
//                                            dismiss()
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)

                                    Spacer()

                                    Button("Measure Again") {
                                        isMeasureAgainPressed = true
                                    }
                                    .buttonStyle(.borderedProminent)

                                    Spacer()
                                }
                                .background(
                                        NavigationLink(
                                                destination: Physiotherapy(selectedTab: 4),
                                                isActive: $isDonePressed
                                                ) {
                                                                        EmptyView()
                                                                    }
                                                                    .hidden()
                                                                )
                                                                .background(
                                                                    NavigationLink(
                                                                        destination: BodyMeasurementView(),
                                                                        isActive: $isMeasureAgainPressed
                                                                    ) {
                                                                        EmptyView()
                                                                    }
                                                                    .hidden()
                                                                )
                                                            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("orangeColor"))
                                                            .navigationBarTitle("Body Measurements", displayMode: .inline)
                }
        }
}



extension Double {
    func upToTwoDecimal() -> String {
        let string = String(format: "%.2f", self)
        return string
    }
}

#if DEBUG
struct ManualMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        ManualMeasurementView()
    }
}
#endif
