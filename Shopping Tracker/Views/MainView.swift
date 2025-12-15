//
//  MainView.swift
//  Shopping Tracker
//
//  Created by Samuel Rutherford on 12/14/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var session: AppSession
    @State private var selectedTab:Int = 0
    @State var isCameraOpen:Bool = false
    
    var body: some View {
        TabView(selection:$selectedTab) {
            HomeTabView().tabItem{
                Label("Home",systemImage: "photo")
            }.tag(0)
            AddReceiptTabView(session:session,isCameraOpen:$isCameraOpen).tabItem{
                 Label("Add",systemImage: "plus").background(Color.blue)
             }.tag(1)
            Text("Organize").tabItem{
                Label("Organize",systemImage: "folder")
            }.tag(2)
        }
    }
}

struct HomeTabView: View {
    var body: some View {
        VStack{
            Text("Home view")
        }
    }
}
