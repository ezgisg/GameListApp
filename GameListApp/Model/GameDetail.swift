//
//  GameDetail.swift
//  GameListApp
//
//  Created by Ezgi Sümer Günaydın on 29.04.2024.
//

import Foundation

struct GameDetail: Codable {
    let id: Int?
    let name, description: String?
    let metacritic: Int?
    let released: String?
    let background_image_additional : String?
    let rating: Double?
    let ratingTop: Int?
   
}
