//
//  ViewControllerAdd.swift
//  My meme
//
//  Created by Ira Singaevkaia on 10/10/16.
//  Copyright © 2016 Ira S. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    func prepareTextField(textField: UITextField, defaultText: String){
        
        //aligning to center
        
        //setting default text
        textField.text = defaultText
        
        //setting text Attributes
        textField.defaultTextAttributes = memeTextAttributes
        
        //setting text field Delegate
        
       // textField.delegate = textFieldsDelegate
        
        //aligning to center
        textField.textAlignment = .center
        
        }

}
