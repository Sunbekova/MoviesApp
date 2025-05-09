//
//  MovieProjectApp.swift
//  MovieProject
//
//  Created by Polina Stelmakh on 09.05.2025.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var showRegistration: Bool
    @Binding var tempEmail: String
    @Binding var tempPassword: String
    
    let burgundyColor = Color(red: 37/255, green: 10/255, blue: 2/255)
    let accentColor = Color.red
    
    var body: some View {
        ZStack {
            burgundyColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 32) {
                Spacer()
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(radius: 8)
                    .padding(.bottom, 8)
                Text("Sign In")
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)
                VStack(spacing: 20) {
                    TextField("Email", text: $tempEmail)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(burgundyColor.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    SecureField("Password", text: $tempPassword)
                        .padding()
                        .background(burgundyColor.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                Button(action: {
                    // Fake login
                    isLoggedIn = true
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [accentColor, accentColor.opacity(0.7)]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(14)
                        .shadow(color: accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                Button(action: {
                    showRegistration = true
                }) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.white)
                        .underline()
                }
                Spacer()
            }
        }
    }
} 
