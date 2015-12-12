//
//  MemeDetailViewController.swift
//  meme-me-editor-project-1
//
//  Created by Trevor Adams on 12/12/2015.
//  Copyright © 2015 Trevor Adams. All rights reserved.
//

import UIKit


class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        detailImageView.image = meme.memedImage
    }
}