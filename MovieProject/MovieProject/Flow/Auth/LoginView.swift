//
//  MovieProjectApp.swift
//  MovieProject
//
//  Created by Polina Stelmakh on 09.05.2025.
//  Rewrited by Aisha Suanbekova on 10.05.2025

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var showRegistration: Bool
    
    let burgundyColor = Color(red: 37/255, green: 10/255, blue: 2/255)
    let accentColor = Color.red
    
    var body: some View {
        ZStack {
            burgundyColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 32) {
                Spacer()
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(radius: 8)
                    .padding(.bottom, 8)
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                            
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                            
                Button("Login") {
                    viewModel.login()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Forgot Password?") {
                    viewModel.sendPasswordReset(email: viewModel.email)
                }
                .foregroundColor(.blue)
                            
                Button("Don't have an account? Sign Up") {
                    showRegistration = true
                }
                .foregroundColor(.blue)
                Spacer()
            }
            .padding()
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text("Notice"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
} 
