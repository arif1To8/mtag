//
//  RequestMtagPopUpViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 07/06/2021.
//

import UIKit

class RequestMtagPopUpViewController: UIViewController, Storyboarded {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        setupUI()
    }
    
    private func setupUI() {
        instructionLabel.textColor = ColorConstants.textGray
        instructionLabel.font = FontConstants.regular?.withSize(16)
        instructionLabel.text = "requestSubmitted".localized()
        
        continueButton.backgroundColor = ColorConstants.orange
        continueButton.setTitle("goHome".localized(), for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.setTitleColor(ColorConstants.white, for: .normal)
        continueButton.titleLabel?.font = FontConstants.regular?.withSize(16)
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        Router.showHomeScreenAsRootVC()
    }
    
}
