//
//  PendingMtagDetailPopupViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 20/06/2021.
//

import UIKit

class PendingMtagDetailPopupViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var refNumValue: UILabel!
    @IBOutlet weak var vehicleRegTitle: UILabel!
    @IBOutlet weak var vehicleRegValue: UILabel!
    @IBOutlet weak var pendingMtagHeading: UILabel!
    @IBOutlet weak var vehicleMakeValue: UILabel!
    @IBOutlet weak var vehicleTypeTitle: UILabel!
    @IBOutlet weak var vehicleInfoHeading: UILabel!
    @IBOutlet weak var vehicleTypeValue: UILabel!
    @IBOutlet weak var carFrontImage: UIImageView!
    
    var detail: PendingMtagObject! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        pendingMtagHeading.textColor = ColorConstants.textBlack
        pendingMtagHeading.font = FontConstants.bold?.withSize(18)
        pendingMtagHeading.text = "pendingApproval".localized()
        
        vehicleInfoHeading.textColor = ColorConstants.textBlack
        vehicleInfoHeading.font = FontConstants.bold?.withSize(18)
        vehicleInfoHeading.text = "vehicleInfo".localized()

        vehicleTypeTitle.textColor = ColorConstants.textGray
        vehicleTypeTitle.font = FontConstants.regular?.withSize(12)
        vehicleTypeTitle.text = "vehicleType".localized()
        
        vehicleTypeValue.textColor = ColorConstants.textBlack
        vehicleTypeValue.font = FontConstants.bold?.withSize(15)
        vehicleTypeValue.text = Helper.vehicleType(from: detail.VEHICLETYPE ?? "")
        
        refNumValue.textColor = ColorConstants.textGray
        refNumValue.font = FontConstants.regular?.withSize(15)
        refNumValue.text = "referenceNumber".localized() + (detail.REF_NO ?? "")
        
        vehicleRegTitle.textColor = ColorConstants.textGray
        vehicleRegTitle.font = FontConstants.regular?.withSize(12)
        vehicleRegTitle.text = "registrationNum".localized()
        
        vehicleRegValue.textColor = ColorConstants.textBlack
        vehicleRegValue.font = FontConstants.bold?.withSize(15)
        vehicleRegValue.text = detail.VEHICLEREGISTRATIONNUMBER
        
        vehicleMakeValue.textColor = ColorConstants.textBlack
        vehicleMakeValue.font = FontConstants.bold?.withSize(18)
        vehicleMakeValue.text = detail.VEHICLEMAKEMODEL
        
        carFrontImage.sd_setImage(with: URL(string: ApiConstants.url + (detail.CARFRONTPICTURE ?? ""))) { image, error, isLoadedFromCache, imageURL in
            if image == nil {
                self.carFrontImage.image = UIImage(named: "placeholder-image")
            }
        }

    }
    
    @IBAction func crossPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
}
