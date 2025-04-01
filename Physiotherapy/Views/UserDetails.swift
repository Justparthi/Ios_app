//
//  UserDetails.swift
//  Physiotherapy
//
//  Created by george kaimoottil on 05/12/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct UserDetailsView: View {
    @State private var newProfilePicture: UIImage?
    @Binding var newUsername: String
    @State private var newEmail: String = ""
    @State private var newPhoneNumber: String = ""
    @State private var newPassword: String = ""
    @State private var retrievedUserPhoto: UIImage?
    @State private var newProfilePhotoPath: String = ""
    @State private var isImagePickerPresented = false
    @Binding var selectedImage: UIImage?
    
    @ObservedObject private var signUpViewModel:SignUPViewModel=SignUPViewModel()
    
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    @State var Username: String="UserName"
    @State private var Email: String = "Email"
    @State private var PhoneNumber: String = "Phone Number"
    @State private var Password: String = "Password"
    
    // Pass the selectedImage to the Profile view
    //    @Binding var profileSelectedImage: UIImage?
    //@Environment(\.dismiss) var dismiss
    var body: some View {
        
            GeometryReader{geo in
                VStack{
                   
                    VStack {
                        Text("User Details")
                            .font(.custom("cabin", size: 36))
                            .foregroundStyle(
                                Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                      //  if let image = selectedImage {
                            Image(uiImage:selectedImage!)
                                .resizable()
                               // .scaledToFill()
                                .clipShape(Circle())
                                .frame(width:80, height: 80)
                                
                                
//                        } else {
//                            Image(systemName: "person.circle.fill")
//                                .resizable()
//                               // .scaledToFit()
//                                .scaledToFill()
//                                .clipShape(Circle())
//                                .frame(width:80, height: 80)
//                                .foregroundColor(.gray)
//                        }
                        
                        Button{
                            isImagePickerPresented.toggle()
                            signUpViewModel.profileImage = selectedImage
                            
                        } label: {
                            Text("Change Profile Picture")
                                .foregroundStyle(Color.white)
                                .font(.custom("cabin", size: 21))
                        }.buttonStyle(.plain)
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
                                .onDisappear{
                                    profilePhotoStore()
                                    updateDetails()
                                }
                        }
                    
                    }
                    VStack{
                        Form{
                            Section(header: Text("User Information")) {
                                TextField("UserName",text: $newUsername)
                                    .foregroundStyle(.white)
                                
                                
                                TextField("Email",text: $newEmail)
                                
                                    .foregroundStyle(.white)
                                
                                    .keyboardType(.emailAddress)
                                TextField("PhoneNumber",text: $newPhoneNumber)
                                    .foregroundStyle(.white)
                                
                                    .keyboardType(.phonePad)
                                TextField("Password",text: $newPassword)
                                
                                    .foregroundStyle(.white)
                                
                            }
                            
                            
                            .listRowBackground(Color(uiColor: UIColor(hex: "D9D9D9", alpha: 0.5)!))
                            
                            Section {
                                NavigationLink(destination: AccountDelete()) {
                                    Text("Delete my Account")
                                    // .foregroundStyle(.white)
                                }
                                .foregroundStyle(.white)
                            }
                            
                            .listRowBackground(Color(uiColor: UIColor(hex: "D9D9D9", alpha: 0.5)!))
                        }
                        .foregroundColor(.white)
                    }
                    //                Section {
                    Button{
                        profilePhotoStore()
                        updateDetails()
                        
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color(uiColor: UIColor(hex: "FF7D05", alpha: 1.0)!))
                                .frame(width: 350, height: 50)
                                .shadow(radius: 6)
                                .padding(.top, 15)
                            Text("Update Details")
                                .font(.system(size: 24))
                                .padding(.top)
                                .foregroundStyle(.white)
                        }
                        // Pass the selectedImage back to the Profile view
                        //                        newProfilePicture = Image(selectedImage)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom)
                    //                }
                }
                
                .frame(width:geo.size.width,height:geo.size.height)
              //  .padding(.bottom)
                
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
            .onAppear{
                getDetails()
                
            }
           .scrollContentBackground(.hidden)
           
//        .navigationBarTitle("User Details", displayMode: .inline)
        
        
        
        
        
        
        
        
        
    }
    private func updateDetails() {
        Task {
            do {
                try await signUpViewModel.updateUserInfo(
                    newUsername: self.newUsername,
                    newEmail: self.newEmail,
                    newPhoneNumber: self.newPhoneNumber,
                    newPassword: self.newPassword,
                    newProfilePhotoPath: self.newProfilePhotoPath
                    
                )
//                print(HomeVM().userName)
                print("details updated successfully")
            } catch {
                // Handle error if needed
                print("Error updating user details: \(error.localizedDescription)")
            }
        }
        
    }
    
    func profilePhotoStore() {
        guard selectedImage != nil else {
            return
        }
        newProfilePicture = selectedImage
        //upload the photo to storage
        let storeRef = Storage.storage().reference()
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        //set the path of the photo in firebase
        newProfilePhotoPath = "profile_images/\(UUID().uuidString).jpg"
        let fileRef = storeRef.child(newProfilePhotoPath)
        let uploadTask = fileRef.putData(imageData!, metadata: nil)
        
    }
    
    func getDetails() {
        let userid = Auth.auth().currentUser?.uid ?? ""
        let db = Firestore.firestore()
        db.collection("Users").whereField("userId", isEqualTo: userid).getDocuments() { snapshot, _ in
            if let snapshot {
                for doc in snapshot.documents {
                    let data = doc.data()
                    newUsername = data["userName"] as? String ?? "Username"
                    newEmail = data["userEmail"] as? String ?? "Email"
                    newPhoneNumber = data["userPhoneNumber"] as? String ?? "Phone Number"
                    newPassword = data["userPassword"] as? String ?? "Password"
                  
                    print("The details are: Username:\(newUsername),  Email:\(newEmail), Phone Number:\(newPhoneNumber), Password:\(newPassword)")
                }
            }
        }
    }
    
}
//struct UserDetails: View {
//    @State private var showUserDetails = false
//    // Sample User data
//    
//    var body: some View {
//        NavigationView{
//            VStack {
//                // User details button
//                Button(action: {
//                    // When the button is clicked, show user details
//                    showUserDetails.toggle()
//                }) {
//                    HStack {
//                        Image(systemName: "person.circle.fill")
//                            .foregroundColor(.gray)
//                            .scaledToFill()
//                            .frame(width: 50, height: 50) // Increase the size of the image here
//                            .clipShape(Circle())
//                        VStack{
//                            Text("Shelly Stan")
//                                .foregroundColor(Color.primary)
//                                .bold()
//                            Text("Personal Details")
//                                .foregroundColor(Color.gray)
//                        }
//                        .padding()
//                        
//                        Spacer()
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(Color.gray)
//                    }
//                    .padding()
//                }
//            }
//            .fullScreenCover(isPresented: $showUserDetails) {
//                // Pass the user details to UserDetailsView
//                UserDetailsView()
//            }
//            
//        }
//    }
//}
//
