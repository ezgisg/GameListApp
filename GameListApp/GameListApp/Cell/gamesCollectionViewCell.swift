//
//  CollectionViewCell.swift
//  GameListApp
//
//  Created by Ezgi Sümer Günaydın on 29.04.2024.
//

import UIKit
import SDWebImage

class gamesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
    }
    
    
    func configureCell(model: GameModel, index: Int) {

        guard let game = model.results?[index] else {
            return
        }
        let ratingText = game.rating.map { "Rating: \($0)" } ?? "Rating: -"
        let releaseText = game.released ?? "-"
        self.gameNameLabel.text = game.name ?? "unknown"
        self.gameInfoLabel.text = "\(ratingText)  Released: \(releaseText)"

        
     
        if let imageUrlString = game.background_image,
           let imageUrl = URL(string: imageUrlString) {
            imageView.sd_setImage(with: imageUrl)
        } else {
            self.imageView.image = UIImage(named: "game_placeholder")
        }
        
    }
    
    func configureCellWithResults(model: [GameResult], index: Int) {
  
        let ratingText = model[index].rating.map { "Rating: \($0)" } ?? "Rating: -"
        let releaseText = model[index].released ?? "-"
        self.gameNameLabel.text = model[index].name ?? "unknown"
        self.gameInfoLabel.text = "\(ratingText)  Released: \(releaseText)"

        if let imageUrlString = model[index].background_image,
           let imageUrl = URL(string: imageUrlString) {
            imageView.sd_setImage(with: imageUrl)
        } else {
            self.imageView.image = UIImage(named: "game_placeholder")
        }
    }

}
