//
//  ReviewView.swift
//  MovieProject
//
//  Created by Aisha Suanbekova Bakytjankyzy on 11.05.2025.
//

import SwiftUI

struct ReviewView: View {
    @StateObject var viewModel = ReviewViewModel()
    let movieId: Int
    let userName: String
    
    @State private var rating = 3
    @State private var comment = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.reviews) { review in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(review.userName).bold()
                            Spacer()
                            Text("\(review.rating)★").foregroundColor(.orange)
                        }
                        Text(review.comment)
                            .font(.body)
                        Text(review.timestamp ?? Date(), style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)

                    }
                }
                .onDelete { indexSet in
                    indexSet.map { viewModel.reviews[$0] }.forEach(viewModel.deleteReview)
                }
            }

            Divider().padding(.vertical)

            VStack(spacing: 8) {
                Stepper("Rating: \(rating)", value: $rating, in: 1...5)
                TextField("Write your review", text: $comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Submit") {
                    viewModel.addReview(movieId: String(movieId), rating: rating, comment: comment, userName: userName)
                    comment = ""
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchReviews(for: String(movieId))
        }
        .navigationTitle("User Reviews")
        
        .onDisappear {
            viewModel.reviews.removeAll()
        }

    }
}
