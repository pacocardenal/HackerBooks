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
        
        let aData = NSData(contentsOf: model.urlPdf)
        self.bookPdfWebView.load(aData as! Data, mimeType: "application/pdf", textEncodingName: "", baseURL: model.urlPdf.deletingLastPathComponent())
        
    }
}
