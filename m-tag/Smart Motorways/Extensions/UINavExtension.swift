//
//  UINavExtension.swift
//  AddMee
//
//  Created by Abdul Wahab on 14/05/2021.
//

import Foundation
import UIKit

extension UINavigationController {

    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
