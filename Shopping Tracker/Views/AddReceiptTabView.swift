//
//  AddReceiptTabView.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/14/25.
//

import SwiftUI

struct AddReceiptTabView: View {
    @EnvironmentObject var session: AppSession
    @StateObject var viewModel:ReceiptViewModel
    @Binding var isCameraOpen:Bool
    
    init(session: AppSession,isCameraOpen:Binding<Bool>) {
            _viewModel = StateObject(wrappedValue: ReceiptViewModel(session: session))
        _isCameraOpen=isCameraOpen
        }
        
    var body: some View {
        VStack{
            if viewModel.images.isEmpty {
                OpenCameraButton(isCameraOpen: $isCameraOpen)
            }else {
                UserValReceiptView(viewModel:viewModel)
            }
        }.padding(8).fullScreenCover(isPresented: $isCameraOpen) {
            DocumentCameraView(images:$viewModel.images).ignoresSafeArea()
         }
    }
}


struct OpenCameraButton:View{
    @Binding var isCameraOpen:Bool
    
    var body: some View{
        Button(action: {isCameraOpen.toggle()}) {
            Label("Scan receipt", systemImage: "document.viewfinder")
        }
    }
}

struct UserValReceiptView: View {
    @ObservedObject var viewModel:ReceiptViewModel
    
    var body: some View {
        VStack {
            HStack{
                Text("Cancel")
                Spacer()
                Text("Approve all")
            }
            TabView{
                ForEach(Array(viewModel.images.enumerated()), id: \.offset) { index,image in
                    VStack{
                        if let receipt = viewModel.receipts[safe: index] {
                            ReceiptView(receipt: receipt)
                            //Image(uiImage: image).resizable().scaledToFit().frame(height:300)
                        }
                    }.onAppear{
                        Task{
                            if viewModel.receipts[safe: index] == nil {
                                let ocrResult = await viewModel.performOCRonReceipt(image: image)
                                if !ocrResult.isEmpty{
                                    do {
                                        let parsedReceipt = try await viewModel.getParsedReceipt(ocrResult)
                                        viewModel.receipts.append(parsedReceipt)
                                    }catch{
                                        print(error)
                                    }
                                }
                            }}
                    }
                }
            }
        }.tabViewStyle(.page)}
}


