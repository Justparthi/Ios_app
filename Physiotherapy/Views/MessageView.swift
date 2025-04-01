//
//  MessageView.swift
//  Physiotherapy
//
//  Created by Yash Patil on 13/10/23.
//

import SwiftUI
import SwiftData
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


struct FirebaseImage : View {
    let path: String
    
    @State var messagePhoto: UIImage? = nil
    @State var showFullScreen: Bool = false
    
    func getMessagePhoto() {
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("\(self.path)")
        fileRef.getData(maxSize: 21 * 1024 * 1024) { data, error in
            if data != nil && error == nil {
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async { messagePhoto  = image }
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            if(self.messagePhoto != nil) {
                Image(uiImage: self.messagePhoto!)
                    .resizable()
                    .frame(width: 120, height: 120)
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundStyle(.white)
                    .frame(width: 120, height: 120)
                    .overlay {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Text("Unable to retrieve the image at this moment.")
                                    .font(.system(size: 15))
                                    .bold()
                                
                                Spacer()
                            }
                            
                            Spacer()
                        }
                    }
            }
        }.onTapGesture {
            self.showFullScreen = true
        }
        .onAppear {
            print("Getting message photo with path: \(self.path)")
            self.getMessagePhoto()
        }
    }
}

struct MessageView: View {
    //Custom Colors
    var brownColor : Color = Color("brownColor")
    var orangeColor: Color = Color("orangeColor")
    
    @StateObject var vm = MessageViewModel()
    
    @State private var isConnectedToTrainer = false
    @State private var showSheet: Bool = false
    @State private var isMessagePhoto: Bool = false
    @State private var isSelectingPhotos: Bool = false
    @State private var isSendPhotoDisabled: Bool = false
    
    @State private var selectedImage: UIImage? = nil
    @State private var messagePhoto: UIImage? = nil
    @State private var messagePhotoPath: String? = nil
    
    func messagePhotoStore(cb: @escaping (Bool) -> Void) {
        guard selectedImage != nil else {
            return
        }
        messagePhoto = selectedImage

        let storeRef = Storage.storage().reference()
        
        let imageData = selectedImage!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else {
            return
        }
        
        let uuid = UUID().uuidString

        messagePhotoPath = "/messageFiles/\(uuid).jpg"
        
        let fileRef = storeRef.child(messagePhotoPath!)
        fileRef.putData(imageData!, metadata: nil) { (metadata, error) in
            guard
                let error = error
            else {
                cb(true)
                print("cb is getting true")
                return
            }
            
            guard
                let metadata = metadata
            else {
                cb(false)
                print("cb is getting false")
                return
            }
            
            cb(true)
            print("cb is getting true")
            return
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader{ geo in
                VStack {
                    Text("Messages")
                        .foregroundStyle(Color("newOrange"))
                        .font(.custom("cabin", size: 40))
                    if isConnectedToTrainer {
                        ScrollView(.vertical, showsIndicators: false) {
                            ScrollViewReader { proxy in
                                ForEach(vm.chats) { chat in
                                    VStack(spacing: 0) {
                                        if (!chat.isImage) {
                                            if chat.person == .user {
                                                HStack {
                                                    Spacer()
                                                    Text(chat.text)
                                                        .foregroundStyle(.white)
                                                        .padding(15)
                                                        .background(.blue)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12), style: FillStyle(eoFill: true, antialiased: true))
                                                        .id(chat.id)
                                                }
                                            } else {
                                                HStack {
                                                    Text(chat.text)
                                                        .foregroundStyle(.black)
                                                        .padding(15)
                                                        .background(.thinMaterial)
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    Spacer()
                                                }
                                            }
                                        } else {
                                            if (chat.person == .user) {
                                                HStack {
                                                    Spacer()
                                                    FirebaseImage(path: chat.text)
                                                }
                                            } else {
                                                HStack {
                                                    FirebaseImage(path: chat.text)
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        HStack(spacing: 10) {
                            TextField("Type in", text: $vm.userText)
                                .font(.title3)
                                .padding(.leading)
                                .frame(width: 300, height: 40, alignment: .leading)
                                .background(RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(.thinMaterial))
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .overlay {
                                    HStack {
                                        Spacer()
                                        Menu {
                                            Button("Choose photo") {
                                                self.isSelectingPhotos = true
                                                self.showSheet = true
                                            }
                                        } label: {
                                            Image(systemName: "paperclip")
                                                .resizable()
                                                .frame(width: 21, height: 21)
                                        }
                                            
                                    }.padding(.trailing, 12)
                                }
                            
                            Button {
                                vm.userTexted()
                            } label: {
                                Image(systemName: "paperplane.fill")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.horizontal)
                    } else {
                        // Display the "Not connected to trainer yet" screen
                        VStack {
                            Text("Not connected to trainer yet")
                                .font(.title)
                                .foregroundColor(.orange)
                                .padding()
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                        
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }.background{
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
        }.sheet(isPresented: self.$showSheet) {
            if(self.isMessagePhoto) {
                if(self.selectedImage != nil) {
                    VStack {
                        VStack {
                            Image(uiImage: self.selectedImage!)
                                .resizable()
                                .frame(width: 210, height: 210)
                            
                            Button("Send") {
                                self.isSendPhotoDisabled = true
                                
                                self.messagePhotoStore { isUploaded in
                                    if(isUploaded) {
                                        if(self.messagePhotoPath != nil) {
                                            vm.sendPhotoImage(path: self.messagePhotoPath!)
                                        }
                                    }
                                    
                                    self.isMessagePhoto.toggle()
                                    self.selectedImage = nil
                                    
                                    self.isSendPhotoDisabled = false
                                    self.showSheet.toggle()
                                }
                                
                            }.disabled(self.isSendPhotoDisabled)

                        }.background {
                            Color.white
                                .ignoresSafeArea(edges: .all)
                        }
                    }
                } else {
                    VStack {
                        Text("Unable to preview the selected image at this moment.")
                            .font(.system(size: 27))
                            .bold()
                        
                        Button("Close") {
                            self.isMessagePhoto = false
                            self.showSheet = false
                        }
                    }.presentationDetents([.medium])
                }
            }
            
            else {
                ImagePicker(selectedImage: $selectedImage, isImagePickerPresented: self.$isSelectingPhotos)
                    .onChange(of: self.selectedImage) { oldValue, newValue in
                        if(newValue != nil) {
                            self.isMessagePhoto = true
                        }
                        
                        self.isSelectingPhotos = false
                    }
            }
        }.onAppear {
            isConnectedToTrainer = false
            vm.checkConnectionToTrainer { connected in
                isConnectedToTrainer = connected
            }
            withAnimation(.default) {
                vm.performFetching()

            }
            
        }
    }
}

#Preview {
    MessageView()
}
