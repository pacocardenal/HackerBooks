//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Paco Cardenal on 30/1/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {

    // MARK: - Constants
    static let notificationName = Notification.Name(rawValue: "BookDidChange")
    static let bookKey = Notification.Name(rawValue: "BookKey")
    static let headerSectionFavorites = "Favorites"
    static let bookCellId = "LibraryTableViewCell"
    static let defaultCoverImage = "defaultBookCover.png"
    static let customCellName = "LibraryTableViewCell"
    
    // MARK: - Properties
    let model: Library
    var favorites: Set<Book> = Set()
    weak var delegate: LibraryTableViewControllerDelegate? = nil
    
    // MARK: - Initialization
    init(model: Library) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        self.title = "HackerBooks"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        tableView.register(UINib.init(nibName: LibraryTableViewController.customCellName, bundle: nil), forCellReuseIdentifier: LibraryTableViewController.customCellName)
        loadFavorites()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribe()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let book: Book
        if indexPath.section == 0 {
            var arrayFavorites = Array(self.favorites)
            arrayFavorites = arrayFavorites.sorted()
            book = arrayFavorites[indexPath.row]
        } else {
            book = model.book(atIndex: indexPath.row, forTag: getTag(forSection: indexPath.section))
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let bookVC = BookViewController(model: book)
            self.navigationController?.pushViewController(bookVC, animated: true)
        } else {
            self.delegate?.libraryTableViewController(self, didSelectBook: book)
            notify(bookChanged: book)
        }
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.tagCount + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.favorites.count
        } else {
            return model.bookCount(forTag: getTag(forSection: section))
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if (section == 0) {
            return LibraryTableViewController.headerSectionFavorites
        } else {
            return model.tagName(section).capitalized
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let book: Book
        
        if (indexPath.section == 0) {
            var favoritesArray = Array(favorites)
            favoritesArray = favoritesArray.sorted()
            book = favoritesArray[indexPath.row]
        } else {
            book = model.book(atIndex: indexPath.row, forTag: getTag(forSection: indexPath.section))
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LibraryTableViewController.bookCellId) as! LibraryTableViewCell
        
        cell.bookTitleLabel.text = book.title
        cell.bookAuthorsLabel.text = book.authors?.joined(separator: ", ")
        do {
            cell.bookCoverImageView.image = try loadTableCellImage(withFileName: book.urlImage.lastPathComponent)
        } catch {
            print ("Error al cargar la imagen")
        }
        
        return cell
        
    }
    
    // MARK: - Utils
    func getTag(forSection section : Int) -> String {
        
        if (section == 0) {
            return LibraryTableViewController.headerSectionFavorites
        } else {
            return model.tagName(section)
        }
        
    }
    
    func loadFavorites() {
        
        for bookSet in model.dict.buckets {
            for book in bookSet {
                if book.favorite {
                    self.favorites.insert(book)
                }
            }
        }
        
    }
    
    func loadTableCellImage(withFileName name : String) throws -> UIImage {
        
        let sourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = sourcePaths[0]
        let file: URL = URL(fileURLWithPath: name, relativeTo: path)

        do {
            guard let image = UIImage.init(data: try Data.init(contentsOf: file)) else {
                return UIImage(named: LibraryTableViewController.defaultCoverImage)!
            }
            return image
            
        } catch {
            throw HackerBooksError.wrongURLFormatForJSONResource
        }
        
    }

}

// MARK: - LibraryTableViewControllerDelegate
protocol LibraryTableViewControllerDelegate : class {
    
    func libraryTableViewController(_ uVC: LibraryTableViewController, didSelectBook book: Book)
    
}

// MARK: - Extensions
extension LibraryTableViewController {
    
    func notify(bookChanged book : Book) {
        
        let nc =  NotificationCenter.default
        let notification = Notification(name: LibraryTableViewController.notificationName, object: self, userInfo: [LibraryTableViewController.bookKey : book])
        
        nc.post(notification)
        
    }
    
    func subscribe() {
        
        let nc = NotificationCenter.default
        
        nc.addObserver(forName: NSNotification.Name(rawValue: BookViewController.kKeyAddFavoriteNotification), object: nil, queue: OperationQueue.main) { (note : Notification) in
            
            guard let userInfo = note.userInfo,
                let bookFav  = userInfo[BookViewController.kKeyBookUserInfoNotification] as? Book else {
                    print("No userInfo found in notification")
                    return
            }
            
            self.favorites.insert(bookFav)
            self.tableView.reloadData()
            
        }
        
        nc.addObserver(forName: NSNotification.Name(rawValue: BookViewController.kKeyDelFavoriteNotification), object: nil, queue: OperationQueue.main) { (note : Notification) in
            
            guard let userInfo = note.userInfo,
                let bookFav  = userInfo[BookViewController.kKeyBookUserInfoNotification] as? Book else {
                    print("No userInfo found in notification")
                    return
            }
            
            self.favorites.remove(bookFav)
            self.tableView.reloadData()
            
        }
        
    }
    
    func unsubscribe() {
        
        let nc = NotificationCenter.default
        nc.removeObserver(self)
        
    }
    
}
