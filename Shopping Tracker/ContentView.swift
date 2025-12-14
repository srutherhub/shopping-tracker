//
//  ContentView.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/13/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var images:[UIImage] = []
    @State var isCameraOpen:Bool = false
    var body: some View {
        VStack{
            if !images.isEmpty {
                Image(uiImage: images[0]).resizable().scaledToFit().frame(height: 300).onAppear {
                    performOCR(on: images[0])
                }
            }
            Button("Open Camera") {
                isCameraOpen.toggle()
            }
            Button("Get token") {
                Task {
                    do {
                        try await ClientModel.getAccesToken()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }.sheet(isPresented: $isCameraOpen) {
            DocumentCameraView(images:$images)
         }
    }
    }


#Preview {
    ContentView()
}
