//
//  GameDetail.swift
//  GameListApp
//
//  Created by Ezgi Sümer Günaydın on 29.04.2024.
//

import Foundation

struct GameDetail: Codable {
    let id: Int?
    let slug, name, nameOriginal, description: String?
    let metacritic: Int?
    let released: String?
    let tba: Bool?
    let updated: String?
    let backgroundImage, backgroundImageAdditional: String?
    let website: String?
    let rating: Double?
    let ratingTop: Int?
    let reactions: [String: Int]?
    let added: Int?
    let playtime, screenshotsCount, moviesCount, creatorsCount: Int?
    let achievementsCount, parentAchievementsCount: Int?
    let redditURL: String?
    let redditName, redditDescription, redditLogo: String?
    let redditCount, twitchCount, youtubeCount, reviewsTextCount: Int?
    let ratingsCount, suggestionsCount: Int?
    let alternativeNames: [String]?
    let metacriticURL: String?
    let parentsCount, additionsCount, gameSeriesCount: Int?
    let reviewsCount: Int?
    let saturatedColor, dominantColor: String?
    let descriptionRaw: String?
}
