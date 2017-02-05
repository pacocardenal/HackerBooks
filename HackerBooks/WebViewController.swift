//
//  WebViewController.swift
//  HackerBooks
//
//  Created by Paco Cardenal on 2/2/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var bookPdfWebView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
        self.bookPdfWebView.delegate = self
        loadPdfWebView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribe()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribe()
        
    }
    
    // MARK: - Utils
    func loadPdfWebView() {
        
        //        let aData = NSData(contentsOf: model.urlPdf)
        do {
            if (checkPdfDownloaded(withPdf: model.urlPdf.lastPathComponent) == false) {
                spinner.isHidden = false
                spinner.startAnimating()
                try downloadPdf(withURL: model.urlPdf)
                spinner.stopAnimating()
                spinner.isHidden = true
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
        
//        //Descargamos los datos de Internet
//        
//        let pdf = try? Data(contentsOf: url)
//        guard let downloadedData = pdf else {
//            throw HackerBooksError.filePointedByURLNotReachable
//        }
//        
//        // Guardamos los datos en un archivo
//        
//        let sourcePaths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let path = sourcePaths[0]
//        let file: URL = URL(fileURLWithPath: url.lastPathComponent, relativeTo: path)
//        let fileManager = FileManager.default
//        fileManager.createFile(atPath: file.path, contents: downloadedData, attributes: nil)
        
        try Bundle.main.downloadFileToDocumentDirectory(fromUrl: url)
        
    }
    
    func checkPdfDownloaded(withPdf name : String) -> Bool {
        
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let url = NSURL(fileURLWithPath: path)
//        let filePath = url.appendingPathComponent(name)?.path
//        let fileManager = FileManager.default
//        if fileManager.fileExists(atPath: filePath!) {
//            return true
//        } else {
//            return false
//        }
        return Bundle.main.isFileDownloadedToDocumentDirectory(withName: name)
        
    }
}

// MARK: - Notifications
extension WebViewController {
    
    func subscribe() {
        
        let nc = NotificationCenter.default
        nc.addObserver(forName: LibraryTableViewController.notificationName, object: nil, queue: OperationQueue.main) { (note : Notification) in
            
            let userInfo = note.userInfo
            let book = userInfo?[LibraryTableViewController.bookKey]
            
            self.model = book as! Book
            self.loadPdfWebView()
            
        }
        
    }
    
    func unsubscribe() {
        
        let nc = NotificationCenter.default
        nc.removeObserver(self)
        
    }
    
}

// MARK: - UIWebViewDelegate
extension WebViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.stopAnimating()
        spinner.isHidden = true
    }
    
}
