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
    
    // MARK: - Table view delegate
    

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
        return model.tagName(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "BookCell"
        let book = model.book(atIndex: indexPath.row, forTag: getTag(forSection: indexPath.section))
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = book.title
        
        return cell!
        
    }
    
    // MARK: - Utils
    func getTag(forSection section : Int) -> String {
        
        return model.tagName(section)
        
    }

}
