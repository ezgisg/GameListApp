//
//  DataRequest.swift
//  GameListApp
//
//  Created by Ezgi Sümer Günaydın on 29.04.2024.
//

import Foundation

enum ServiceError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct DataService {
    
    let resourceURL: URL
    let key = "10463de78dba4a7bb908bac394297ed1"
    
    init() {

        let startDate = "2005-09-01"
        let finishDate = "2024-04-01"
        
        let resourceString = "https://api.rawg.io/api/games?key=\(key)&dates=\(startDate),\(finishDate)&platforms=18,1,7"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError("Error")
        }
        self.resourceURL = resourceURL
    }
    
    
    func getGameList(completion: @escaping(Result<GameModel, ServiceError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let games = try decoder.decode(GameModel.self, from: jsonData)
                completion(.success(games))
            } catch {
                completion(.failure(.canNotProcessData))
//                let errorMessage = "\(error.localizedDescription)"
    
            }
            
            
        }
        dataTask.resume()
    }
    
    func getGameDetail(id:String, completion: @escaping(Result<GameDetail, ServiceError>) -> Void)  {
        guard let url = URL(string: "https://api.rawg.io/api/games/\(id)?key=\(key)") else {
            return
        }
        _ = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let gameDetail = try decoder.decode(GameDetail.self, from: jsonData)
                completion(.success(gameDetail))
            } catch {
                completion(.failure(.canNotProcessData))
                let errorMessage = "\(error.localizedDescription)"
                print("Detay veride hata oluştu", errorMessage)
            }
        }
        
    }
    
}
