//
//  Library.swift
//  HackerBooks
//
//  Created by Paco Cardenal on 30/1/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import Foundation
import UIKit

class Library {
    
    // MARK: - Utility types
    typealias BooksArray = [Book]
    typealias BooksDictionary = MultiDictionary<String, Book>
    
    // MARK: - Properties
    var dict: BooksDictionary = BooksDictionary()
    static var allBooks = Set<String>()
    static var allTags = Set<String>()
    
    // MARK: - Initialization
    init(books : BooksArray) {
        
        for someBook in books {
            for tag in someBook.tags! {
                Library.allTags.insert(tag)
            }
        }
        
        for aTag in Library.allTags {
            var setBooks = Set<Book>()
            for aBook in books {
                if (aBook.tags?.contains(aTag))! {
                    aBook.favorite = checkFavoriteFromUserDefaults(book: aBook)
                    setBooks.insert(aBook)
                }
            }
            dict[aTag] = setBooks
        }
        
    }
    
    // MARK: - Accessors
    var tagCount : Int {
        get {
            return dict.countBuckets
        }
    }
    
    // MARK: - Utils
    func bookCount(forTag tag : String) -> Int {
        
        guard let count = dict[tag]?.count else {
            return 0
        }
        
        return count
        
    }
    
    func book(atIndex index : Int, forTag tag : String) -> Book {
        
        let books = Array(dict[tag]!).sorted()
        let book = books[index]
        
        return book
        
    }
    
    func tagName(_ tagNumber : Int) -> String {
        var keysArray = Array(dict.keys)
        keysArray = keysArray.sorted()
        if tagNumber > 0 {
            return keysArray[tagNumber - 1]
        } else {
            return keysArray[0]
        }
    }
    
    func checkFavoriteFromUserDefaults(book: Book) -> Bool {
        
        let defaults = UserDefaults.standard
        guard let array = defaults.stringArray(forKey: BookViewController.kKeyFavoriteUserDefaults) else {
            return false
        }
        
        return array.contains(String(book.hashValue))
        
    }
    
}
