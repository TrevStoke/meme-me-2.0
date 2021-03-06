//
//  MemeCollectionViewController.swift
//  meme-me-editor-project-1
//
//  Created by Trevor Adams on 12/12/2015.
//  Copyright © 2015 Trevor Adams. All rights reserved.
//

import UIKit


class MemeCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewControllerWithIdentifier("DetailView") as! MemeDetailViewController
        detailViewController.memeIndex = indexPath.item
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath)
        let imageView = UIImageView(image: memes[indexPath.item].memedImage)
        cell.backgroundView = imageView
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
}