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
    var memeIndex: Int = 0
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMeme")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        detailImageView.image = memes[memeIndex].memedImage
    }
    
    func editMeme() {
        let editorController = self.storyboard!.instantiateViewControllerWithIdentifier("EditorView") as! MemeEditorViewController
        editorController.itemToEdit = memeIndex
        editorController.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "finishedEditing", name: "FinishedEditing", object: nil)
        presentViewController(editorController, animated: true, completion: nil)
    }
    
    func finishedEditing() {
        detailImageView.image = memes[memeIndex].memedImage
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "FinishedEditing", object: nil)
    }
    
}