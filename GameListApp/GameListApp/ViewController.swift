//
//  ViewController.swift
//  GameListApp
//
//  Created by Ezgi Sümer Günaydın on 29.04.2024.
//

import UIKit

class ViewController: UIViewController , UIScrollViewDelegate {

    let gameRequest = DataService()
    var games: GameModel?
    var results = [GameResult]()
    var filteredResults = [GameResult]()
    let bannerPageCount = 5
    var isFiltered = false
    var emptyView = UIView()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        gameRequest.getGameList { result in
            switch result {
            case .success(let gameModel):
                self.games = gameModel
                guard let results = self.games?.results else {return}
                self.results = results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.bannerCollectionView.reloadData()
                    self.pageControl.numberOfPages = self.bannerPageCount
                }
            case .failure(let error):
                print("Hata oldu", error.localizedDescription)
            }
            
        }

        
        setCollectionViewLayout()
        setupBannerCollectionView()
        self.collectionView.register(UINib(nibName: "gamesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "gamesCollectionViewCell")
        self.bannerCollectionView.register(UINib(nibName: "PageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PageCollectionViewCell")

    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionView {
            let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
            pageControl.currentPage = pageIndex
        }
    }
    
    func setupBannerCollectionView()  {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(bannerCollectionView.frame.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        bannerCollectionView.setCollectionViewLayout(layout, animated: false)
        bannerCollectionView.isPagingEnabled = true
        bannerCollectionView.showsHorizontalScrollIndicator = false
        
        layout.configuration = config
    
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .black
        pageControl.backgroundColor = .gray
        pageControl.alpha = 0.2
        pageControl.layer.cornerRadius = 5
        
    }
    

    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 100)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout

    }
    
    
    func setupEmptyView() {
        emptyView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        let messageLabel = UILabel()
        messageLabel.text = "No Result"
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.sizeToFit()
        messageLabel.frame = CGRect(x: 100, y: 600, width: 200, height: 30)
//        messageLabel.center = emptyView.center

        emptyView.addSubview(messageLabel)
        collectionView.backgroundView = emptyView
       
    }
    
    func removeEmptyView() {
        collectionView.backgroundView = nil
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            if !isFiltered {
                return results.count
            } else {
                return filteredResults.count
            }
       
        } else {
            return bannerPageCount
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        if collectionView == self.collectionView {
             cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gamesCollectionViewCell", for: indexPath) as? gamesCollectionViewCell ?? UICollectionViewCell()
         } else {
             cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCollectionViewCell", for: indexPath) as? PageCollectionViewCell ?? UICollectionViewCell()
         }
        if let games = games {
            if !isFiltered {
                (cell as? gamesCollectionViewCell)?.configureCell(model: games, index: indexPath.item)
                (cell as? PageCollectionViewCell)?.configureCell(model: games, index: indexPath.item)
            } else if isFiltered {
                (cell as? gamesCollectionViewCell)?.configureCellWithResults(model: filteredResults, index: indexPath.item)
            }
            
        }
         return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            filteredResults = results.filter({ gameResult in
                guard let bool = gameResult.name?.lowercased().contains(searchText.lowercased()) else {return false}
                return bool
            })
            isFiltered = true
            bannerCollectionView.isHidden = true
            pageControl.isHidden = true
            let constraint = collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
            constraint.priority = UILayoutPriority(1000.0)
            constraint.isActive = true
            if filteredResults.count == 0 {
                setupEmptyView()
            } else {
                removeEmptyView()
            }
            collectionView.reloadData()
        } else {
            isFiltered = false
            removeEmptyView()
            collectionView.reloadData()
            bannerCollectionView.isHidden = false
            pageControl.isHidden = false
            let constraint = collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
            constraint.priority = .defaultLow

        }
    }
    
}

