//
//  MainTabView.swift
//  MovieProject
//
//  Created by Aisha Suanbekova Bakytjankyzy on 11.05.2025.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
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
    }

    func getMemberSinceDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }

    func getRandomUserID() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).compactMap { _ in letters.randomElement() })
    }
}
