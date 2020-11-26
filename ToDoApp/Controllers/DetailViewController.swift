//
//  DetailViewController.swift
//  ToDoApp
//
//  Created by mawetecnologías on 25/11/20.
//  Copyright © 2020 sestier. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    var cTitle:String?
    var cContent:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = cTitle
        self.lblContent.text = cContent
        self.lblContent.sizeToFit()
        
    }

}
