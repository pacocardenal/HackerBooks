//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Paco Cardenal on 27/1/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import Foundation

/*
 {
 "authors": "Scott Chacon, Ben Straub",
 "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
 "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
 "tags": "version control, git",
 "title": "Pro Git"
 },
 */

let kKeyJsonDownloadedUserDefaults: String = "JSONDownloaded"

// MARK: - Aliases
typealias JSONObject        = AnyObject
typealias JSONDictionary    = [String : JSONObject]
typealias JSONArray         = [JSONDictionary]

// MARK: - Decodification
func decode(book json: JSONDictionary) throws -> Book {
    
    guard let urlPdfString = json["pdf_url"] as? String, let urlPdf = URL(string: urlPdfString) else {
        throw HackerBooksError.wrongURLFormatForJSONResource
    }
    
    guard let urlImageString = json["image_url"] as? String, let urlImage = URL(string: urlImageString) else {
        throw HackerBooksError.wrongURLFormatForJSONResource
    }
    
    //let map = MultiDictionary<String, Int>()
    var tagSet = Set<String>()
    
    if let tagsString = json["tags"] as? String {
        
        let tagsArray = tagsString.components(separatedBy: ", ")
        for tag in tagsArray {
            tagSet.insert(tag)
        }
    }
    var tags = Array(tagSet)
    tags = tags.sorted()
    
    var authors = [String]()
    if let authorsString = json["authors"] as? String {
        
        let authorsArray = authorsString.components(separatedBy: ", ")
        for author in authorsArray {
            authors.append(author)
        }
        
    } else {
        authors = []
    }
    
    if let title = json["title"] as? String {
        return Book(title: title, authors: authors, tags: tags, urlImage: urlImage, urlPdf: urlPdf)
    } else {
        throw HackerBooksError.wrongJSONFormat
    }
    
}

func decode(book json: JSONDictionary?) throws -> Book {
    
    guard let json = json else {
        throw HackerBooksError.nilJSONObject
    }
    
    return try decode(book: json)
    
}

// MARK: - Loading
func loadFromLocalFile(filename name: String, bundle : Bundle = Bundle.main) throws -> JSONArray {
    
    let sourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let path = sourcePaths[0]
    let file: URL = URL(fileURLWithPath: "K9ziV0z3SJ", relativeTo: path)
    
    if let data = try? Data(contentsOf: file), let maybeArray = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray, let array = maybeArray {
        
        return array
        
    } else {
        throw HackerBooksError.wrongJSONFormat
    }
    
}

func downloadAndSaveJSONFile() throws {
    
    let url: URL = URL.init(string: "https://t.co/K9ziV0z3SJ")!
//    let json = try? Data(contentsOf: URL(string: url)!)
//    guard let downloadedData = json else {
//        throw HackerBooksError.filePointedByURLNotReachable
//    }
//    
//    let sourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//    let path = sourcePaths[0]
//    let file: URL = URL(fileURLWithPath: "books_readable.json", relativeTo: path)
//    let fileManager = FileManager.default
//    fileManager.createFile(atPath: file.path, contents: downloadedData, attributes: nil)
    try Bundle.main.downloadFileToDocumentDirectory(fromUrl: url)
    
    saveJsonIntoDefaults()
    
}

func saveJsonIntoDefaults() {
    
    let defaults = UserDefaults.standard
    defaults.set(true, forKey: "JSONDownloaded")
    
}

func isJsonDownloaded() -> Bool {
    
    let defaults = UserDefaults.standard
    
    return (defaults.object(forKey: "JSONDownloaded") != nil)
    
}

func downloadImages(model: Library) throws {
    
    for book in model.dict.bucketsUnique {
        
        do {
            if(checkImageDownloaded(withImage: book.urlImage.lastPathComponent)) == false {
                try downloadImage(fromUrl: book.urlImage)
            }
            
        } catch {
            throw HackerBooksError.wrongURLFormatForJSONResource
        }
        
    }
    
}

func downloadImage(fromUrl url : URL) throws {
    
//    let image = try? Data(contentsOf: url)
//    guard let downloadedData = image else {
//        throw HackerBooksError.filePointedByURLNotReachable
//    }
//    
//    let sourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//    let path = sourcePaths[0]
//    let file: URL = URL(fileURLWithPath: url.lastPathComponent, relativeTo: path)
//    let fileManager = FileManager.default
//    fileManager.createFile(atPath: file.path, contents: downloadedData, attributes: nil)
    
    try Bundle.main.downloadFileToDocumentDirectory(fromUrl: url)
    
}

func checkImageDownloaded(withImage name : String) -> Bool {
    
//    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//    let url = NSURL(fileURLWithPath: path)
//    let filePath = url.appendingPathComponent(name)?.path
//    let fileManager = FileManager.default
//    if fileManager.fileExists(atPath: filePath!) {
//        return true
//    } else {
//        return false
//    }
    return Bundle.main.isFileDownloadedToDocumentDirectory(withName: name)
    
}
