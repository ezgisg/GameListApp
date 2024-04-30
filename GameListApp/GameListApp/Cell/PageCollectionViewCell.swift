//
//  PageCollectionViewCell.swift
//  GameListApp
//
//  Created by Ezgi Sümer Günaydın on 30.04.2024.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        bannerImage.layer.cornerRadius = 20
        bannerImage.contentMode = .scaleAspectFill
    }
    
    func configureCell(model: GameModel, index: Int) {
        guard let game = model.results?[index] else {
            return
        }
        if let imageUrlString = game.background_image,
           let imageUrl = URL(string: imageUrlString) {
            bannerImage.sd_setImage(with: imageUrl)
        } else {
            self.bannerImage.image = UIImage(named: "game_placeholder")
        }
    }
    

}
