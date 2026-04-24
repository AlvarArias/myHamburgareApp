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
    @StateObject private var recipeStore = RecipeStore(repository: JSONRecipeRepository(bundle: .main))

    var body: some Scene {
        WindowGroup {
            AnimatedTabView(recipeStore: recipeStore)
                .environmentObject(tabSelection)
        }
    }
}

@MainActor
class TabSelection: ObservableObject {
    @Published var selectedTab: Int = 0
}

struct AnimatedTabView: View {
    @EnvironmentObject private var tabSelection: TabSelection
    let recipeStore: RecipeStore

    @StateObject private var homeViewModel: HomeViewModel
    @StateObject private var browseViewModel: BrowseViewModel
    @StateObject private var scanViewModel: ScanViewModel
    @StateObject private var profileViewModel: ProfileViewModel

    init(recipeStore: RecipeStore) {
        self.recipeStore = recipeStore
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(recipeStore: recipeStore))
        _browseViewModel = StateObject(wrappedValue: BrowseViewModel(recipeStore: recipeStore))
        _scanViewModel = StateObject(wrappedValue: ScanViewModel(recipeStore: recipeStore))
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(recipeStore: recipeStore))
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                if tabSelection.selectedTab == 0 {
                    HomeView(viewModel: homeViewModel)
                        .transition(.slide)
                }
                if tabSelection.selectedTab == 1 {
                    BrowseView(viewModel: browseViewModel)
                        .transition(.slide)
                }
                if tabSelection.selectedTab == 2 {
                    ScanView(viewModel: scanViewModel)
                        .transition(.slide)
                }
                if tabSelection.selectedTab == 3 {
                    ProfileView(viewModel: profileViewModel)
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
            .tint(.accentColor)
        }
        .environmentObject(tabSelection)
    }
}
