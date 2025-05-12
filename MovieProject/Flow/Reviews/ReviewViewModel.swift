//
//  ReviewViewModel.swift
//  MovieProject
//
//  Created by Aisha Suanbekova Bakytjankyzy on 11.05.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func fetchReviews(for movieId: String) {
        listener?.remove()
        listener = db.collection("reviews")
            .whereField("movieId", isEqualTo: movieId)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching reviews: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    self?.reviews = []
                    return
                }

                self?.reviews = documents.compactMap { doc in
                    try? doc.data(as: Review.self)
                }
            }
    }
    
    func fetchReviewsByUser(userId: String) {
        listener?.remove()
        listener = db.collection("reviews")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching user reviews: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    self?.reviews = []
                    return
                }

                self?.reviews = documents.compactMap { doc in
                    try? doc.data(as: Review.self)
                }
            }
    }


    func addReview(movieId: String, rating: Int, comment: String, userName: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let review = Review(
            id: nil,
            movieId: movieId,
            userId: userId,
            userName: userName,
            rating: rating,
            comment: comment,
            timestamp: nil // Firestore assign server timestamp
        )

        do {
            _ = try db.collection("reviews").addDocument(from: review)
        } catch {
            print("Failed to add review: \(error)")
        }
    }

    func deleteReview(_ review: Review) {
        guard let id = review.id else { return }
        db.collection("reviews").document(id).delete()
    }

    func updateReview(_ review: Review, newComment: String, newRating: Int) {
        guard let id = review.id else { return }
        db.collection("reviews").document(id).updateData([
            "comment": newComment,
            "rating": newRating,
            "timestamp": FieldValue.serverTimestamp()
        ])
    }

    deinit {
        listener?.remove()
    }
}
