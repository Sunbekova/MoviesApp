//
//  MovieProjectApp.swift
//  MovieProject
//
//  Created by Тулепберген Анель  on 09.05.2025.
//

import SwiftUI
import FirebaseAuth

struct MovieApp: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    @State private var showRegistration = false
    
    @State private var isLoggedIn = Auth.auth().currentUser != nil
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black // true black for dark mode

        // Highlight selected tab in red
        appearance.stackedLayoutAppearance.selected.iconColor = .systemRed
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemRed]

        // Unselected tabs
        appearance.stackedLayoutAppearance.normal.iconColor = .lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]

        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
            if authViewModel.isLoggedIn {
                TabView {
                    NavigationView {
                        HomeView()
                    }
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    NavigationView {
                        SearchView()
                    }
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    ProfileView(
                        userName: authViewModel.name,
                        userEmail: authViewModel.email,
                        memberSince: getMemberSinceDate(),
                        userID: getRandomUserID(),
                        isLoggedIn: $authViewModel.isLoggedIn
                    )
                    .tabItem {
                        Label("User", systemImage: "person.crop.circle")
                    }
                }
                .environmentObject(favoritesViewModel)
            } else {
                AuthFlowView(viewModel: authViewModel, showRegistration: $showRegistration)
            }
        }

    // Helper functions for memberSince and userID
    func getMemberSinceDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }

    func getRandomUserID() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map{ _ in letters.randomElement()! })
    }
}
