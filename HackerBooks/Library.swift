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
    //typealias BooksDictionary = [TagName : BooksArray]
    typealias BooksDictionary = MultiDictionary<String, Book>
    
    // MARK: - Properties
    var dict: BooksDictionary = BooksDictionary()
    static var allBooks = Set<String>()
    static var allTags = Set<String>()
    
    // MARK: - Initialization
    init(books : BooksArray) {
        
        //dict = makeEmptyTags()
        
        // 1. Todas las etiquetas
        for someBook in books {
            for tag in someBook.tags! {
                Library.allTags.insert(tag)
            }
        }
        
        // 2. Asignar libros con etiqueta
        for aTag in Library.allTags {
            print(aTag)
            var setBooks = Set<Book>()
            for aBook in books {
                if (aBook.tags?.contains(aTag))! {
                    aBook.favorite = checkFavoriteFromUserDefaults(book: aBook)
                    setBooks.insert(aBook)
                    // it exists, do something
                }
                
//                dict[aTag]?.insert(aBook)
            }
            dict[aTag] = setBooks
            print(dict[aTag]!)
        }
        
//        for someBook in books {
//            for tag in someBook.tags! {
////                dict[tag]?.append(someBook)
////                Library.allTags.insert(tag)
//                dict[tag] = someBook
////                
////                BooksDictionary[tag] = someBook.title
//            }
//        }
        
//        for (tag, book) in dict {
//            dict[tag] = book.sorted()
//        }
        
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
    
//    fileprivate func makeEmptyTags() -> BooksDictionary {
//        
//        var d = BooksDictionary()
//        
//        d[TagName.git] = BooksArray()
//        d[TagName.javascript] = BooksArray()
//        d[TagName.programming] = BooksArray()
//        d[TagName.versionControl] = BooksArray()
//        d[TagName.other] = BooksArray()
//        
//        return d
//        
//    }
    
}
