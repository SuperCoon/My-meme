//
//  ViewController.swift
//  My meme
//
//  Created by Ira Singaevkaia on 10/10/16.
//  Copyright © 2016 Ira S. All rights reserved.
//

import UIKit
import Foundation

struct Meme {
    let topText: String
    let bottomText: String
    let image: UIImage
    let memeImage: UIImage
}

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    //Outlet variables
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    // Set default text style attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white ,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -1.0
    ] as [String : Any]
    
    // Build the text field delegate
    var textFieldsDelegate = TextFieldsDelegate()

    func configure(textField:UITextField, attributes:[String:Any]){
        textField.defaultTextAttributes = attributes
        textField.textAlignment = .center
    }
    
        override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    
        // Disable camera button if device doesn't have a camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)

    
        // Set text attributes for topTextField and bottomTextField
        // Center text in text fields
    
        configure(textField: topTextField, attributes: memeTextAttributes)
        configure(textField: bottomTextField, attributes: memeTextAttributes)
    
        subscribeToKeyboardNotifications()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       unsubscribeToKeyboardNotifications()
    }
   
    //Cancel button
    @IBAction func cancelAction(_ sender: AnyObject) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false

    }
    
    //Keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardHeight = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardHeight.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y =  -getKeyboardHeight(notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = textFieldsDelegate
        bottomTextField.delegate = textFieldsDelegate
        
        // Share button disabled until image selected
        shareButton.isEnabled = false
        
    }
    
    //To hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)

    }
 
    //Pick imades from the camera
    @IBAction func pickCamera(_ sender: AnyObject) {
       presentImagePickerWith(sourceType: UIImagePickerControllerSourceType.camera)
  }

    //Pick imades from the album
    @IBAction func pickFromAlbum(_ sender: AnyObject) {
        presentImagePickerWith(sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
  
    //This func addes pictures to the imagePickerView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
       
        // Enable share button
        shareButton.isEnabled = true
        
        
        // Dismiss image picker
        dismiss(animated: true, completion: nil)
}
    
    //Dismiss the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func generateMemedImage() -> UIImage
    {
        
        toolBar.isHidden = true
        navigationBar.isHidden = true

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        toolBar.isHidden = false
        navigationBar.isHidden = false
    
        return memedImage
    }
    
    func save(memedImage:UIImage) {
        //Create the meme
        _ = Meme(topText: self.topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memeImage: memedImage)
    }
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        let generateMeme = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [generateMeme], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {(_, completed, _, _) in
            if completed {
                self.save(memedImage: generateMeme)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
   
