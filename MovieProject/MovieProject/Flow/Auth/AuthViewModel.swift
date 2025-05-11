//
//  AuthViewModel.swift
//  MovieProject
//
//  Created by Aisha Suanbekova Bakytjankyzy on 10.05.2025.
//

import Foundation
import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var name = ""
    @Published var isLoggedIn = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    init() {
        checkAuthState()
    }

    func checkAuthState() {
        if let user = Auth.auth().currentUser {
            self.isLoggedIn = true
            self.email = user.email ?? ""
            self.name = user.displayName ?? ""
        } else {
            self.isLoggedIn = false
        }
    }

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields required"
            showError = true
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = "Authentication failed: \(error.localizedDescription)"
                self?.showError = true
            } else {
                self?.isLoggedIn = true
                self?.email = result?.user.email ?? ""
                self?.name = result?.user.displayName ?? ""
            }
        }
    }

    func register(confirmPassword: String) {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "Please fill all fields"
            showError = true
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            showError = true
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = "Registration failed: \(error.localizedDescription)"
                self?.showError = true
            } else {
                self?.errorMessage = "Registered successfully! Please login."
                self?.showError = true
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.email = ""
            self.name = ""
        } catch {
            errorMessage = "Logout failed: \(error.localizedDescription)"
            showError = true
        }
    }

    func sendPasswordReset(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.errorMessage = "Reset failed: \(error.localizedDescription)"
            } else {
                self?.errorMessage = "Reset link sent to your email."
            }
            self?.showError = true
        }
    }
}
