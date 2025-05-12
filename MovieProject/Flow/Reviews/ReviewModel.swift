//
//  ReviewModel.swift
//  MovieProject
//
//  Created by Aisha Suanbekova Bakytjankyzy on 11.05.2025.
//

import Foundation
import FirebaseFirestore

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    let movieId: String
    let userId: String
    let userName: String
    let rating: Int
    let comment: String
    @ServerTimestamp var timestamp: Date?
}
