//
//  UIImageViewExtension.swift
//  AddMee
//
//  Created by Abdul Wahab on 22/04/2021.
//

import Foundation
import UIKit

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = 20
    }
    
    func makeRounded() {
            self.layer.borderWidth = 0
            self.layer.masksToBounds = false
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.cornerRadius = self.frame.height / 2
            self.clipsToBounds = true
        }
}
