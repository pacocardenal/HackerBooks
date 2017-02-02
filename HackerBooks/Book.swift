//
//  Book.swift
//  HackerBooks
//
//  Created by Paco Cardenal on 25/1/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import Foundation
import UIKit

//typealias BookTags = [TagName]
typealias BookTags = MultiDictionary<String, String>

class Book {
    
    // MARK: - Stored properties
    let title       : String
    let authors     : [String]?
    let tags        : [String]?
    let urlImage    : URL
    let urlPdf      : URL
    
    // MARK: - Computed properties
    
    // MARK: - Initialization
    init(title: String, authors: [String]?, tags: [String]?, urlImage: URL, urlPdf: URL) {
        
        self.title = title;
        self.authors = authors;
        self.tags = tags;
        self.urlImage = urlImage;
        self.urlPdf = urlPdf;
        
    }
    
    // MARK: - Proxies
    func proxyForEquality() -> String {
        
        return "\(title)\(urlPdf)"
        
    }
    
    func proxyForComparison() -> String {
        
        return proxyForEquality()
        
    }
    
}

// MARK: - Protocols
// Equatable, Comparable, CustomStringConvertible

extension Book : Equatable {
    
    public static func ==(lhs: Book, rhs: Book) -> Bool {
        
        return lhs.proxyForEquality() == rhs.proxyForEquality()
        
    }
    
}

extension Book : Comparable {
    
    public static func <(lhs: Book, rhs: Book) -> Bool {
        
        return lhs.proxyForComparison() < rhs.proxyForComparison()
        
    }
    
}

extension Book : CustomStringConvertible {
    
    public var description: String {
        
        get {
            return "<\(type(of:self)): \(title) (\(authors!.joined(separator: ", "))) (\(tags!.joined(separator: ", "))))>"
        }
    
    }
    
}

extension Book : Hashable {
    
    public var hashValue: Int {
        
        get {
            return title.hashValue // + (authors?.joined().hashValue)!
        }
    
    }
    
}



