//
//  MemeTableViewController.swift
//  meme-me-editor-project-1
//
//  Created by Trevor Adams on 12/12/2015.
//  Copyright © 2015 Trevor Adams. All rights reserved.
//

import UIKit


class MemeTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navigationController = self.navigationController {
            navigationController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New",
                style: .Plain, target: self, action: "newMeme")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")
        cell?.textLabel?.text = memes[indexPath.row].topText
        cell?.imageView?.image = memes[indexPath.row].memedImage
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func newMeme() {
        let memeEditor = MemeEditorViewController()
        if let navigationController = self.navigationController {
            navigationController.pushViewController(memeEditor, animated: true)
        }
    }
    
}