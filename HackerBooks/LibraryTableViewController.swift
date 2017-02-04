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
        tableView.register(UINib.init(nibName: "LibraryTableViewCell", bundle: nil), forCellReuseIdentifier: "LibraryTableViewCell")
        registerForNotifications()
        loadFavorites()
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let book = model.character(atIndex: indexPath.row, forAffiliation: getAffiliation(forSection: indexPath.section))
        
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
        // #warning Incomplete implementation, return the number of sections
        return model.tagCount + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return self.favorites.count
        } else {
            return model.bookCount(forTag: getTag(forSection: section))
        }
        //        return model.bookCount(forTag: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Favorites"
        } else {
            return model.tagName(section).capitalized
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cellId = "BookCell"
        let cellId = "LibraryTableViewCell"
        
        let book: Book
        
        if (indexPath.section == 0) {
            var favoritesArray = Array(favorites)
            favoritesArray = favoritesArray.sorted()
            book = favoritesArray[indexPath.row]
        } else {
            book = model.book(atIndex: indexPath.row, forTag: getTag(forSection: indexPath.section))
        }
        
//        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! LibraryTableViewCell
        
//        if (cell == nil) {
//            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
//        }
        
        //cell?.textLabel?.text = book.title
        cell.bookTitleLabel.text = book.title
        cell.bookAuthorsLabel.text = book.authors?.joined(separator: ", ")
        cell.bookCoverImageView.image = loadTableCellImage(withFileName: book.urlImage.lastPathComponent)
//        let data = try? Data(contentsOf: book.urlImage) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//        if let imageData = data {
//            cell.bookCoverImageView.image = UIImage(data: imageData)
//        }
        
        return cell
        
    }
    
    // MARK: - Notifications
    func registerForNotifications() {

        let nc = NotificationCenter.default
        
        nc.addObserver(forName:Notification.Name(rawValue:"kNotificationAddFavorite"),
                       object:nil, queue:nil,
                       using:bookAddedFavorite)
        
        nc.addObserver(forName:Notification.Name(rawValue:"kNotificationRemoveFavorite"),
                       object:nil, queue:nil,
                       using:bookRemovedFavorite)
        
    }
    
    func bookAddedFavorite(notification: Notification) {
        
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let bookFav  = userInfo["bookToUpdate"] as? Book else {
                print("No userInfo found in notification")
                return
        }
        
        print("Store \(bookFav) as favorite")
        self.favorites.insert(bookFav)
        tableView.reloadData()
        
    }
    
    func bookRemovedFavorite(notification: Notification) {
        
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let bookFav  = userInfo["bookToUpdate"] as? Book else {
                print("No userInfo found in notification")
                return
        }
        
        print("Remove \(bookFav) as favorite")
        self.favorites.remove(bookFav)
        tableView.reloadData()
        
    }
    
    // MARK: - Utils
    func getTag(forSection section : Int) -> String {
        
        if (section == 0) {
            return "Favorites"
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
    
    func loadTableCellImage(withFileName name : String) -> UIImage {
        
        let sourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = sourcePaths[0]
        let file: URL = URL(fileURLWithPath: name, relativeTo: path)

        do {
            guard let image = UIImage.init(data: try Data.init(contentsOf: file)) else {
                return UIImage(named: "defaultBookCover.png")!
            }
            return image
            
        } catch {
            print ("Error")
        }
        
        return UIImage(named: "defaultBookCover.png")!
    }

}

// MARK: - LibraryTableViewControllerDelegate
protocol LibraryTableViewControllerDelegate : class {
    
    func libraryTableViewController(_ uVC: LibraryTableViewController, didSelectBook book: Book)
    
}

// MARK: - Notifications
extension LibraryTableViewController {
    
    func notify(bookChanged book : Book) {
        
        let nc =  NotificationCenter.default
        let notification = Notification(name: LibraryTableViewController.notificationName, object: self, userInfo: [LibraryTableViewController.bookKey : book])
        
        nc.post(notification)
        
    }
    
}
