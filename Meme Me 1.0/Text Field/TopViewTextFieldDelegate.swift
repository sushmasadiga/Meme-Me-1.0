//
//  TopViewTextFieldDelegate.swift
//  Meme Me 1.0
//
//  Created by Sushma Adiga on 03/05/21.
//

import Foundation
import UIKit

class TopViewTextFieldDelegate: NSObject, UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
           
           var newText = textField.text! as NSString
           newText = newText.replacingCharacters(in: range, with: string) as NSString
           return true
       }
       
    private func textFieldDidBeginEditing(_ textField: UITextField) {
           print(textField.text!)
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           
           return true;
       }
       
}
