//
//  FavoriteGamesViewController.swift
//  GameListApp
//
//  Created by Ezgi Sümer Günaydın on 2.05.2024.
//

import UIKit

class FavoriteGamesViewController: UIViewController {

    var wholeGames: [GameResult] = []
    var favoriteGames: [GameResult] = []
    var emptyView = UIView()
    
    var favoritesIDArray: [String]?

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "gamesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "gamesCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filterData()

    }
    
    func filterData() {
        var array: [String]?
        favoritesIDArray = (UserDefaults.standard.array(forKey: "favorites")) as? [String]
        favoriteGames = wholeGames.filter { gameResult in
            guard let gameID = gameResult.id else {return false}
            array = favoritesIDArray?.filter { favoriteID in
                return String(gameID) == (favoriteID)
            }
            return !(array?.isEmpty ?? true)
        }
        collectionView.reloadData()
        setupViewLayout()
    }
    
    
    
    func setupEmptyView() {
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        let messageLabel = UILabel()
        messageLabel.text = "No Favorites"
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.sizeToFit()
        messageLabel.center = emptyView.center
        emptyView.addSubview(messageLabel)
        collectionView.backgroundView = emptyView
       
    }

    
    func setupViewLayout() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    
        if favoriteGames.count == 0 {
            setupEmptyView()
        } else {
            collectionView.backgroundView = nil
        }
    }

}


extension FavoriteGamesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gamesCollectionViewCell", for: indexPath) as? gamesCollectionViewCell ?? UICollectionViewCell()
        (cell as? gamesCollectionViewCell)?.configureCellWithResults(model: favoriteGames, index: indexPath.item)
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
                let id = String(favoriteGames[indexPath.row].id ?? 0)
                loadDetailView(withId: id)
        
        }
        
    func loadDetailView(withId id: String) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.gameId = id
        navigationController?.pushViewController(detailVC, animated: true)
    }

    }
    

    

