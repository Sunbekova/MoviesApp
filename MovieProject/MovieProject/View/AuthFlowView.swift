//
//  MovieProjectApp.swift
//  MovieProject
//
//  Created by Polina Stelmakh on 09.05.2025.
//

import SwiftUI

struct AuthFlowView: View {
    @Binding var isLoggedIn: Bool
    @Binding var showRegistration: Bool
    @Binding var tempEmail: String
    @Binding var tempPassword: String
    @Binding var tempName: String
    
    var body: some View {
        if showRegistration {
            RegistrationView(isLoggedIn: $isLoggedIn, showRegistration: $showRegistration, tempEmail: $tempEmail, tempPassword: $tempPassword, tempName: $tempName)
        } else {
            LoginView(isLoggedIn: $isLoggedIn, showRegistration: $showRegistration, tempEmail: $tempEmail, tempPassword: $tempPassword)
        }
    }
} 
