//
//  TextFieldsDelegate.swift
//  My meme
//
//  Created by Ira Singaevkaia on 10/11/16.
//  Copyright © 2016 Ira S. All rights reserved.
//

import Foundation
import UIKit

class TextFieldsDelegate  : NSObject, UITextFieldDelegate {
    
    
     //Dismisses the keyboard when the return key is pressed
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
     //Clear the text field if default text ("TOP" or "BOTTOM")
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = ""
        }
    }
    
}
