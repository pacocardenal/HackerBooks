//
//  FoundationExtensions.swift
//  HackerBooks
//
//  Created by Paco Cardenal on 5/2/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import Foundation

extension Bundle {
    
    func downloadFileToDocumentDirectory(fromUrl url : URL) throws {
        
        let fileToDownload = try? Data(contentsOf: url)
        guard let downloadedData = fileToDownload else {
            throw HackerBooksError.filePointedByURLNotReachable
        }
        
        let sourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = sourcePaths[0]
        let file: URL = URL(fileURLWithPath: url.lastPathComponent, relativeTo: path)
        let fileManager = FileManager.default
        fileManager.createFile(atPath: file.path, contents: downloadedData, attributes: nil)
        
    }

    func isFileDownloadedToDocumentDirectory(withName name : String) -> Bool {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(name)?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            return true
        } else {
            return false
        }
        
    }
    
}
