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
    
    let accentColor = Color.red
    
    var body: some View {
        NavigationView {
            ZStack {
                // Set the entire background to black
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 8) {
                    Spacer().frame(height: 8)
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(radius: 8)
                    Text(userName.isEmpty ? "Your Name" : userName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(userEmail.isEmpty ? "your@email.com" : userEmail)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                    HStack(spacing: 16) {
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
                    
                    // Use List to enable swipe-to-delete and set its background to black
                    List {
                        ForEach(favoritesViewModel.favoriteMovies) { movie in
                            ZStack {
                                // Black background for each movie poster
                                Color.black
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                
                                NavigationLink(destination: MovieDetailsView(movie: movie)) {
                                    MovieRow(movie: movie)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .listRowBackground(Color.black) // Set individual row background
                        }
                        .onDelete(perform: deleteFavorite)
                    }
                    .listStyle(PlainListStyle()) // This removes the default iOS list styling
                    .background(Color.black) // Set the entire list background
                    .padding(.horizontal, 8)
                    .onAppear {
                        // These UITableView appearance changes affect the entire app
                        // so you might want to set them elsewhere (like in AppDelegate)
                        UITableView.appearance().backgroundColor = .clear
                        UITableViewCell.appearance().backgroundColor = .clear
                    }                    .background(Color.black) // Set the List background to black
                    
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
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarHidden(true) // Hide navigation bar
        }
    }
    
    // Function to handle delete action
    func deleteFavorite(at offsets: IndexSet) {
        // Remove the movie at the specified index
        favoritesViewModel.favoriteMovies.remove(atOffsets: offsets)
    }
}
