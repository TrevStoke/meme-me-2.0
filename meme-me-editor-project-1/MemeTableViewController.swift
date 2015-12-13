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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")
        cell?.textLabel?.text = memes[indexPath.row].topText + " ... " + memes[indexPath.row].bottomText
        cell?.imageView?.image = memes[indexPath.row].memedImage
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewControllerWithIdentifier("DetailView") as! MemeDetailViewController
        detailViewController.memeIndex = indexPath.item
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func newMeme() {
        let memeEditor = MemeEditorViewController()
        if let navigationController = self.navigationController {
            navigationController.pushViewController(memeEditor, animated: true)
        }
    }
    
}