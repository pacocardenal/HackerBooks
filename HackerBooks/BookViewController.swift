//
//  BookViewController.swift
//  HackerBooks
//
//  Created by TalentoMobile on 2/2/17.
//  Copyright © 2017 Paco Cardenal. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    @IBOutlet weak var bookCoverImageView: UIImageView!
    
    // MARK: - Properties
    var model: Book
    
    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        syncViewWithModel()
    }
    
    // MARK: - Actions
    @IBAction func readBook(_ sender: Any) {
        print("Read book: \(model.urlPdf)")
    }
    
    // MARK: - Utils
    func syncViewWithModel() {
        self.bookCoverImageView.image = UIImage(data: try! Data(contentsOf: model.urlImage))
    }

}
