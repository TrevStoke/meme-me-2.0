//
//  MemeEditorViewController.swift
//  meme-me-editor-project-1
//
//  Created by Trevor Adams on 20/09/2015.
//  Copyright © 2015 Trevor Adams. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    var activeTextField: UITextField!
    let defaultTop: String = "TOP"
    let defaultBottom: String = "BOTTOM"
    
    var itemToEdit: Int! = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        resetTextFields()
        disableShareButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        configureTextFields()
        subscribeToKeyboardNotifications()
        
        if (itemToEdit > -1) {
            displayMeme(memes[itemToEdit])
        }
    }
    
    func displayMeme(meme: Meme) {
        topTextField.text = meme.topText
        bottomTextField.text = meme.bottomText
        pickedImage.image = meme.originalImage
        enableShareButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)    }
    
    
    @IBAction func pickImageWithCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        pickedImage.image = image
        enableShareButton()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelMeme(sender: AnyObject) {
        pickedImage.image = nil
        resetTextFields()
        disableShareButton()
        if (isEditingMeme()) {
            NSNotificationCenter.defaultCenter().postNotificationName("FinishedEditing", object: nil)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resetTextFields() {
        topTextField.text = defaultTop
        bottomTextField.text = defaultBottom
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        switch(textField.text!) {
        case defaultTop: textField.text = ""
        case defaultBottom: textField.text = ""
        default: break
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.characters.count == 0 {
            switch(textField) {
            case topTextField: textField.text = defaultTop
            case bottomTextField: textField.text = defaultBottom
            default: textField.text = "YOUR MEME HERE"
            }
        }
    }
    
    func configureTextFields() {
        prepareTextField(topTextField, defaultText: defaultTop)
        prepareTextField(bottomTextField, defaultText: defaultBottom)
    }
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.autocapitalizationType = .AllCharacters
        textField.textAlignment = .Center
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if(activeTextField == bottomTextField) {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(activeTextField == bottomTextField) {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func generateMeme() -> UIImage {
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let meme: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return meme
    }
    
    func isEditingMeme() -> Bool {
        return itemToEdit > -1
    }
    
    func save() {
        var meme = Meme()
        
        meme.originalImage = pickedImage.image
        meme.memedImage = generateMeme()
        meme.topText = topTextField.text
        meme.bottomText = bottomTextField.text
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        
        if (isEditingMeme()) {
            appDelegate.memes[itemToEdit] = meme
        } else {
            appDelegate.memes.append(meme)
        }
    }
    
    func share() {
        let activityController = UIActivityViewController(activityItems: [generateMeme()], applicationActivities: nil)
        
        // Using completion handler described at:
        // https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIActivityViewController_Class/#//apple_ref/c/tdef/UIActivityViewControllerCompletionWithItemsHandler
        
        activityController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems, activityError) in
            if(completed) {
                self.save()
            }
        }
        
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        share()
    }
    
    func disableShareButton() {
        shareButton.enabled = false
    }
    
    func enableShareButton() {
        shareButton.enabled = true
    }
}