//
//  myHamburgareAppApp.swift
//  myHamburgareApp
//
//  Created by Alvar Arias on 2025-08-13.
//

import SwiftUI

@main

struct myHamburgareAppApp: App {
    
    @StateObject private var tabSelection = TabSelection()
    
    var body: some Scene {
        WindowGroup {
            AnimatedTabView()
            .environmentObject(tabSelection)
            }
        }
       
}



class TabSelection: ObservableObject {
    @Published var selectedTab: Int = 0
}

struct AnimatedTabView: View {
    @StateObject private var tabSelection = TabSelection()

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if tabSelection.selectedTab == 0 {
                    HomeView()
                        .transition(.slide)
                }
                if tabSelection.selectedTab == 1 {
                    BrowseView()
                        .transition(.slide)
                }
                if tabSelection.selectedTab == 2 {
                    ScanView()
                        .transition(.slide)
                }
                if tabSelection.selectedTab == 3 {
                    ProfileView()
                        .transition(.slide)
                }
            }
            .animation(.easeInOut, value: tabSelection.selectedTab)

            HStack {
                Button(action: { tabSelection.selectedTab = 0 }) {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                            .font(.caption)
                    }
                }
                .foregroundColor(tabSelection.selectedTab == 0 ? .accentColor : .gray)
                Spacer()
                Button(action: { tabSelection.selectedTab = 1 }) {
                    VStack {
                        Image(systemName: "square.grid.2x2.fill")
                        Text("Browse")
                            .font(.caption)
                    }
                }
                .foregroundColor(tabSelection.selectedTab == 1 ? .accentColor : .gray)
                Spacer()
                Button(action: { tabSelection.selectedTab = 2 }) {
                    VStack {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                            .font(.caption)
                    }
                }
                .foregroundColor(tabSelection.selectedTab == 2 ? .accentColor : .gray)
                Spacer()
                Button(action: { tabSelection.selectedTab = 3 }) {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                            .font(.caption)
                    }
                }
                .foregroundColor(tabSelection.selectedTab == 3 ? .accentColor : .gray)
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .environmentObject(tabSelection)
    }
}
