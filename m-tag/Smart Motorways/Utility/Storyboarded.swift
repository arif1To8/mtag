//
//  Storyboarded.swift
//  AddMee
//
//  Created by Abdul Wahab on 11/04/2021.
//

import UIKit

protocol Storyboarded {
    static func instantiate(storyBoardName:String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyBoardName:String = "Main") -> Self {
        // this pulls out "ALW.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: storyBoardName, bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
