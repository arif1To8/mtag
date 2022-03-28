//
//  OTPTextField.swift
//  AddMee
//
//  Created by Abdul Wahab on 15/04/2021.
//

import Foundation
import UIKit

class OTPTextField: UITextField {
  weak var previousTextField: OTPTextField?
  weak var nextTextField: OTPTextField?
  override public func deleteBackward(){
    text = ""
    previousTextField?.becomeFirstResponder()
   }
}
