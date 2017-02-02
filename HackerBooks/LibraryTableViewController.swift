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
    
    // MARK: - Properties
    let model: Library
    var favorites: Set<Book> = Set()
    
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
        
        //        let charVC = CharacterViewController(model: character)
        //        self.navigationController?.pushViewController(charVC, animated: true)
        let bookVC = BookViewController(model: book)
        self.navigationController?.pushViewController(bookVC, animated: true)
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

}
