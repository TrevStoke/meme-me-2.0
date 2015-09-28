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
    
    var activeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        resetTextFields()
        disableShareButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        configureTextFields()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
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
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resetTextFields() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        switch(textField.text!) {
        case "TOP": textField.text = ""
        case "BOTTOM": textField.text = ""
        default: break
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.characters.count == 0 {
            switch(textField) {
            case topTextField: textField.text = "TOP"
            case bottomTextField: textField.text = "BOTTOM"
            default: textField.text = "YOUR MEME HERE"
            }
        }
    }
    
    func configureTextFields() {
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0,
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
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
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if(activeTextField == bottomTextField) {
            self.view.frame.origin.y += getKeyboardHeight(notification)
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
    
    func save() {
        //Create the meme
        let meme = Meme(
            originalImage: pickedImage.image!,
            memedImage: generateMeme(),
            topText: topTextField.text!,
            bottomText: bottomTextField.text!)
        
        print(meme)
    }
    
    func share() {
        let activityController = UIActivityViewController(activityItems: [generateMeme()], applicationActivities: nil)
        
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