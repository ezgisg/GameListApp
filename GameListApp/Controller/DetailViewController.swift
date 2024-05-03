//
//  DetailViewController.swift
//  GameListApp
//
//  Created by Ezgi Sümer Günaydın on 2.05.2024.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButtonImage: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var infoOneLabel: UILabel!
    @IBOutlet weak var infoTwoLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    let gameRequest = DataService()
    var gameId = String()
    var gameDetail : GameDetail? = nil
    var favoriteGamesIDArray: [String] = []
    var favoriteGamesIDSet = Set<String>()
    let loadingVC = LoadingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        addChild(loadingVC)
        loadingVC.view.frame = view.bounds
        view.addSubview(loadingVC.view)
        loadingVC.didMove(toParent: self)
    
        navigationItem.title = "Detail of Game"
    
        self.viewLayoutSetup()
        self.favoriteButtonSetup()
        self.loadingVC.startLoading()
  
        gameRequest.getGameDetail(id: gameId) { result in
            switch result {
            case .success(let gameDetail):
                self.gameNameLabel.text = gameDetail.name
                self.infoOneLabel.text = "Released Date: \(gameDetail.released ?? "")"
                self.infoTwoLabel.text = "Rating: \(String(gameDetail.rating ?? 0)) "
                self.detailLabel.text = gameDetail.description?.convertHTMLToPlainText()
                DispatchQueue.main.async {
                    if let imageUrlString = gameDetail.background_image_additional,
                       let imageUrl = URL(string: imageUrlString) {
                        self.imageView.sd_setImage(with: imageUrl)
                    } else {
                        self.imageView.image = UIImage(named: "game_placeholder")
                    }
                    self.loadingVC.stopLoading()
                }
            case .failure(let error):
                print("Detay sayfada hata oldu", error.localizedDescription)
            }
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteGamesIDArray = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? []
        favoriteGamesIDSet = Set(favoriteGamesIDArray)
        favoriteButtonSetup()
    }
    
    
    func viewLayoutSetup() {
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(detailLabel)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleToFill
        favoriteButtonImage.image = nil
        gameNameLabel.text = ""
        infoOneLabel.text = ""
        infoTwoLabel.text = ""
        detailLabel.text = ""
    }

    func favoriteButtonSetup() {
        if favoriteGamesIDArray.contains(gameId) {
            favoriteButtonImage.image = UIImage(named: "star")
        } else {
            favoriteButtonImage.image = UIImage(named: "empty_star")
        }
        favoriteButtonImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonClicked))
        favoriteButtonImage.addGestureRecognizer(tapGesture)
    }
    
   @objc func favoriteButtonClicked() {
       let userDefaults = UserDefaults.standard
       

       
       UIView.animate(withDuration: 0.2) {
              self.favoriteButtonImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
          } completion: { (_) in
              UIView.animate(withDuration: 0.2) {
                  self.favoriteButtonImage.transform = .identity
              }
          }
    
       
       if favoriteButtonImage.image == UIImage(named: "empty_star") {
           favoriteGamesIDSet.insert(gameId)
           favoriteGamesIDArray = Array(favoriteGamesIDSet)
           userDefaults.set(favoriteGamesIDArray, forKey: "favorites")
           favoriteButtonImage.image = UIImage(named: "star")
       } else {
           favoriteButtonImage.image = UIImage(named: "empty_star")
           favoriteGamesIDSet.remove(gameId)
           favoriteGamesIDArray = Array(favoriteGamesIDSet)
           userDefaults.set(favoriteGamesIDArray, forKey: "favorites")
       }
      
  
    }

}


extension String {
    func convertHTMLToPlainText() -> String {
        guard let data = self.data(using: .utf8) else {
            return ""
        }
        
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributedString.string
        } catch {
            print("HTML dönüştürme hatası: \(error.localizedDescription)")
            return ""
        }
    }
}


class LoadingViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
            activityIndicator.stopAnimating()
            view.removeFromSuperview()
            removeFromParent()
    
    }
}
