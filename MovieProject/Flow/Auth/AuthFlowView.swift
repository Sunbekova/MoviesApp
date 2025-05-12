//
//  MovieProjectApp.swift
//  MovieProject
//
//  Created by Polina Stelmakh on 09.05.2025.
//  Rewrited by Aisha Suanbekova on 10.05.2025

import SwiftUI
import FirebaseAuth

struct AuthFlowView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var showRegistration: Bool

    var body: some View {
        if viewModel.isLoggedIn {
            ProfileView(
                userEmail: viewModel.email,
                memberSince: "2024", // Replace with actual data if you have it
                userID: Auth.auth().currentUser?.uid ?? "",
                isLoggedIn: $viewModel.isLoggedIn
            )
            .environmentObject(viewModel) // inject AuthViewModel
        } else {
            if showRegistration {
                RegistrationView(viewModel: viewModel, showRegistration: $showRegistration)
            } else {
                LoginView(viewModel: viewModel, showRegistration: $showRegistration)
            }
        }
    }
}
