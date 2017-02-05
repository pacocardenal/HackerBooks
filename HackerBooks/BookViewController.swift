//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Paco Cardenal on 2/2/17.
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
    
    // MARK: - Constants
    static let kKeyFavoriteUserDefaults: String = "FavoriteBooks"
    static let kKeyAddFavoriteNotification: String = "kNotificationAddFavorite"
    static let kKeyDelFavoriteNotification: String = "kNotificationRemoveFavorite"
    static let kKeyBookUserInfoNotification: String = "bookToUpdate"
    
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
        self.edgesForExtendedLayout = []
        syncViewWithModel()
    }
    
    // MARK: - Actions
    @IBAction func readBook(_ sender: Any) {
        
        let pdfVC = WebViewController(model: model)
        navigationController?.pushViewController(pdfVC, animated: true)
        
    }
    
    @IBAction func markAsFavorite(_ sender: UIButton) {
        
        if (model.favorite) {
            deleteFromDefaults(book: model)
            syncModelWithView(addingFavorite: false)
        } else {
            saveIntoDefaults(book: model)
            syncModelWithView(addingFavorite: true)
        }
        
        syncViewWithModel()
        
    }
    
    // MARK: - Utils
    func syncViewWithModel() {
        
        self.bookCoverImageView.image = loadCoverImage(withFileName: model.urlImage.lastPathComponent)
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
            notificationName = BookViewController.kKeyAddFavoriteNotification
        } else {
            notificationName = BookViewController.kKeyDelFavoriteNotification
        }
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue: notificationName),
                object: nil,
                userInfo: [BookViewController.kKeyBookUserInfoNotification : model])
        
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
    
    func loadCoverImage(withFileName name : String) -> UIImage {
        
        let sourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = sourcePaths[0]
        let file: URL = URL(fileURLWithPath: name, relativeTo: path)
        
        do {
            guard let image = UIImage.init(data: try Data.init(contentsOf: file)) else {
                return UIImage(named: LibraryTableViewController.defaultCoverImage)!
            }
            return image
            
        } catch {
            print ("Error al cargar la imagen de portada")
        }
        
        return UIImage(named: LibraryTableViewController.defaultCoverImage)!
        
    }

}

// MARK: - Protocols

extension BookViewController : LibraryTableViewControllerDelegate {
    
    func libraryTableViewController(_ uVC: LibraryTableViewController, didSelectBook book: Book) {
        self.model = book
        syncViewWithModel()
    }
    
}
