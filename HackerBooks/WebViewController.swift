//
//  WebViewController.swift
//  HackerBooks
//
//  Created by TalentoMobile on 2/2/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var bookPdfWebView: UIWebView!
    
    // MARK: - Properties
    var model: Book
    
    // MARK: - Initializers
    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPdfWebView()

    }
    
    // MARK: - Utils
    func loadPdfWebView() {
        
        //        let aData = NSData(contentsOf: model.urlPdf)
        do {
            if (checkPdfDownloaded(withPdf: model.urlPdf.lastPathComponent) == false) {
                try downloadPdf(withURL: model.urlPdf)
            }
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let getImagePath = paths.appending("/" + model.urlPdf.lastPathComponent)
            
            let aData = NSData(contentsOfFile: getImagePath)
            self.bookPdfWebView.load(aData as! Data, mimeType: "application/pdf", textEncodingName: "", baseURL: model.urlPdf.deletingLastPathComponent())
        } catch {
            print ("Error")
        }
        
        //        self.bookPdfWebView.load(aData as! Data, mimeType: "application/pdf", textEncodingName: "", baseURL: model.urlPdf.deletingLastPathComponent())
        
    }
    
    func downloadPdf(withURL url : URL) throws {
        
        //Descargamos los datos de Internet
        
        let pdf = try? Data(contentsOf: url)
        guard let downloadedData = pdf else {
            throw HackerBooksError.filePointedByURLNotReachable
        }
        
        // Guardamos los datos en un archivo
        
        let sourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = sourcePaths[0]
        let file: URL = URL(fileURLWithPath: url.lastPathComponent, relativeTo: path)
        let fileManager = FileManager.default
        fileManager.createFile(atPath: file.path, contents: downloadedData, attributes: nil)
        
    }
    
    func checkPdfDownloaded(withPdf name : String) -> Bool {
        
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
