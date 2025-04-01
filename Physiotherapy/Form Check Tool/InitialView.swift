//
//  InitialView.swift
//  Physiotherapy
//
//  Created by Yash Patil on 29/10/23.
//

import SwiftUI

struct InitialView: View {
    @StateObject private var recorder = Recorder()

    @State var isPresented: Bool = false
    @State var isStarted: Bool = false
    @State var isStopped: Bool = false
    @State var initialOffset: CGFloat = UIScreen.main.bounds.height * 0.44
    @State var currentOffset: CGFloat = 0
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                CameraViewController(session: $recorder.session)
                    .frame(height: 300)
                    .environmentObject(recorder)
            }
        .sheet(isPresented: $isPresented) {
            DetailsView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(Color(.orange))
        }
    }
    }
}

#Preview {
    InitialView()
        .environmentObject(Recorder())
}


extension InitialView {
    
    @ViewBuilder
    func DetailsView() -> some View {
        VStack(spacing: 0) {
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: 70, height: 5, alignment: .top)
                    .foregroundStyle(.white)
            }
            .frame(height: 40, alignment: .top)
            
            VStack(spacing: 25) {
                VStack(alignment: .leading) {
                    Text("Muscles Involved")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    HStack {
                        ForEach(0..<3) { _ in
                            Text("Abdominis")
                                .font(.body)
                                .fontWeight(.medium)
                                .frame(width: 100, height: 50, alignment: .center)
                                .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(Color(.customColor2)))
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Stats")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    
                    HStack {
                        ForEach(0..<3) { _ in
                            VStack(spacing: 15) {
                                Image(systemName: "timer")
                                    .font(.largeTitle)
                                Text("1:25")
                                Text("Minutes")
                            }
                            .frame(width: 100, height: 135)
                            .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color(.customColor2)))
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        }
                    }
                }
                
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            isStarted.toggle()
                            currentOffset = 0
                        }
                    } label: {
                        if isStarted {
                            HStack(spacing: 15) {
                                Image(systemName: "play.circle")
                                    .font(.title)
                                Text("Start")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.white)
                            .frame(width: 150, height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(Color(.customColor2)))
                            
                        }else {
                            HStack {
                                Image(systemName: "pause.circle.fill")
                                    .font(.title)
                                Text("Pause")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(Color(.customColor2))
                            .frame(width: 150, height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .foregroundStyle(.white))
                        }
                    }
                    
                    Button {
                        isStopped = true
                    } label: {
                        HStack {
                            Image(systemName: "stop.circle")
                                .font(.title)
                            Text("Stop")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(width: 150, height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color(.customColor2)))

                    }
                }
            }
        }
        .frame(height: 380)
        .padding(.vertical)

    }
}
