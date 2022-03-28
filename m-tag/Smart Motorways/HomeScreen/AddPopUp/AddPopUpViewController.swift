//
//  AddPopUpViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 07/06/2021.
//

import UIKit

class AddPopUpViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var addBalanceButton: UIButton!
    
    var requestPressedAction: (() -> ())?
    var addBalancePressedAction: (() -> ())?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestButton.tintColor = ColorConstants.textBlack
        requestButton.titleLabel?.font = FontConstants.regular?.withSize(16)
        
        addBalanceButton.tintColor = ColorConstants.textBlack
        addBalanceButton.titleLabel?.font = FontConstants.regular?.withSize(16)
        
        requestButton.setTitle("requestMtag".localized(), for: .normal)
        addBalanceButton.setTitle("addBalance".localized(), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    @IBAction func crossPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func requestPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: {
            self.requestPressedAction?()
        })
    }
    
    @IBAction func addBalancePressed(_ sender: UIButton) {
        dismiss(animated: false, completion: {
            self.addBalancePressedAction?()
        })
    }
    
    
}
