//
//  MovieProjectApp.swift
//  MovieProject
//
//  Created by Polina Stelmakh on 09.05.2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    let userName: String
    let userEmail: String
    let memberSince: String
    let userID: String
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    let burgundyColor = Color(red: 37/255, green: 10/255, blue: 2/255)
    let accentColor = Color.red
    
    var body: some View {
        ZStack {
            burgundyColor.edgesIgnoringSafeArea(.all)
            VStack(spacing: 32) {
                Spacer().frame(height: 24)
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(radius: 10)
                Text(userName.isEmpty ? "Your Name" : userName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(userEmail.isEmpty ? "your@email.com" : userEmail)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                HStack(spacing: 24) {
                    VStack {
                        Text("User ID")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(userID)
                            .font(.footnote)
                            .foregroundColor(.white)
                            .bold()
                    }
                    VStack {
                        Text("Member since")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                        Text(memberSince)
                            .font(.footnote)
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                Divider().background(Color.white.opacity(0.3)).padding(.horizontal)
                Text("Favorites")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 24)
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(favoritesViewModel.favoriteMovies) { movie in
                            MovieRow(movie: movie)
                        }
                    }
                    .padding(.horizontal, 8)
                }
                // Logout Button
                Button(action: {
                    do {
                        try Auth.auth().signOut()
                        isLoggedIn = false
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 16)
                
                Spacer()
            }
        }
    }
} 
