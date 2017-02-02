//
//  BookViewController.swift
//  HackerBooks
//
//  Created by TalentoMobile on 2/2/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    @IBOutlet weak var bookCoverImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookAuthorsLabel: UILabel!
    @IBOutlet weak var bookTagsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    var model: Book
    static let kKeyFavoriteUserDefaults: String = "FavoriteBooks"
    
    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        syncViewWithModel()
    }
    
    // MARK: - Actions
    @IBAction func readBook(_ sender: Any) {
        print("Read book: \(model.urlPdf)")
        
        let pdfVC = WebViewController(model: model)
        navigationController?.pushViewController(pdfVC, animated: true)
    }
    
    @IBAction func markAsFavorite(_ sender: UIButton) {
        
        // 1. Comprobar si ya es favorito
        if (model.favorite) {
            deleteFromDefaults(book: model)
            syncModelWithView(addingFavorite: false)
            //favoriteButton.setImage(UIImage.init(named: "favEmpty.png"), for: .normal)
        } else {
            saveIntoDefaults(book: model)
            syncModelWithView(addingFavorite: true)
            //favoriteButton.setImage(UIImage.init(named: "favFull.png"), for: .normal)
        }
        
        syncViewWithModel()
        
    }
    
    
    // MARK: - Utils
    func syncViewWithModel() {
        //self.bookCoverImageView.image = UIImage(data: try! Data(contentsOf: model.urlImage))
        self.bookCoverImageView.image = UIImage(contentsOfFile: "defaultBookCover.png")
        self.bookTitleLabel.text = model.title
        self.bookAuthorsLabel.text = model.authors?.joined(separator: ", ")
        self.bookTagsLabel.text = model.tags?.joined(separator: ", ")
        
        if self.model.favorite {
            favoriteButton.setImage(UIImage.init(named: "favFull.png"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage.init(named: "favEmpty.png"), for: .normal)
        }
    }
    
    func syncModelWithView(addingFavorite fav: Bool) {
        
        let notificationName: String
        
        model.changeFavorite()
        
        if fav == true {
            notificationName = "kNotificationAddFavorite"
        } else {
            notificationName = "kNotificationRemoveFavorite"
        }
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue: notificationName),
                object: nil,
                userInfo: ["bookToUpdate" : model])
        
    }
    
    func saveIntoDefaults(book: Book) {
        
        let defaults = UserDefaults.standard
        var array = defaults.stringArray(forKey: BookViewController.kKeyFavoriteUserDefaults) ?? [String]()
        
        array.append(String(book.hashValue))
        defaults.set(array, forKey: BookViewController.kKeyFavoriteUserDefaults)
        
    }
    
    func deleteFromDefaults(book: Book) {
        
        let defaults = UserDefaults.standard
        var array = defaults.stringArray(forKey: BookViewController.kKeyFavoriteUserDefaults)
        
        array?.remove(at: (array?.index(of: String(book.hashValue)))!)
        defaults.set(array, forKey: BookViewController.kKeyFavoriteUserDefaults)
        
    }
    
    func isFavorite(book: Book) -> Bool {
        
        let defaults = UserDefaults.standard
        guard let array = defaults.stringArray(forKey: BookViewController.kKeyFavoriteUserDefaults) else {
            return false
        }
        
        return array.contains(String(book.hashValue))
        
    }

}
