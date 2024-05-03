//
//  GameModel.swift
//  GameListApp
//
//  Created by Ezgi Sümer Günaydın on 29.04.2024.
//

import Foundation

struct GameModel: Codable {
    let count: Int?
    let next: String?
    let results: [GameResult]?
}

struct GameResult: Codable {
        let slug, name: String?
        let released: String?
        let background_image: String?
        let rating: Double?
        let rating_top: Int?
        let metacritic, suggestions_count: Int?
        let updated: String?
        let id: Int?
        let score, clip: String?
        let reviews_count: Int?
}

