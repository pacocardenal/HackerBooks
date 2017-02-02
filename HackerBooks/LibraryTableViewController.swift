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
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let book = model.character(atIndex: indexPath.row, forAffiliation: getAffiliation(forSection: indexPath.section))
        
        let book = model.book(atIndex: indexPath.row, forTag: getTag(forSection: indexPath.section))
        
        //        let charVC = CharacterViewController(model: character)
        //        self.navigationController?.pushViewController(charVC, animated: true)
        let bookVC = BookViewController(model: book)
        self.navigationController?.pushViewController(bookVC, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return model.tagCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.bookCount(forTag: getTag(forSection: section))
//        return model.bookCount(forTag: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.tagName(section).capitalized
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cellId = "BookCell"
        let cellId = "LibraryTableViewCell"
        let book = model.book(atIndex: indexPath.row, forTag: getTag(forSection: indexPath.section))
        
//        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! LibraryTableViewCell
        
//        if (cell == nil) {
//            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
//        }
        
        //cell?.textLabel?.text = book.title
        cell.bookTitleLabel.text = book.title
        cell.bookAuthorsLabel.text = book.authors?.joined(separator: ", ")
        let data = try? Data(contentsOf: book.urlImage) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        if let imageData = data {
            cell.bookCoverImageView.image = UIImage(data: imageData)
        }
        
        return cell
        
    }
    
    // MARK: - Utils
    func getTag(forSection section : Int) -> String {
        
        return model.tagName(section)
        
    }

}
