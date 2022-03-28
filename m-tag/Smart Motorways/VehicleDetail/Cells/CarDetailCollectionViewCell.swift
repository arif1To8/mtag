//
//  CarDetailCollectionViewCell.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 08/06/2021.
//

import UIKit

class CarDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CarDetailCollectionViewCell"
    
    @IBOutlet weak var makeTitle: UILabel!
    @IBOutlet weak var makeValue: UILabel!
    @IBOutlet weak var regNumTitle: UILabel!
    @IBOutlet weak var regNumValue: UILabel!
    @IBOutlet weak var vehicleTypeTitle: UILabel!
    @IBOutlet weak var vehicleTypeValue: UILabel!
    @IBOutlet weak var registeredInTitle: UILabel!
    @IBOutlet weak var registeredInValue: UILabel!

    @IBOutlet weak var carFront: UIImageView!
    @IBOutlet weak var carBack: UIImageView!
    @IBOutlet weak var cnicfront: UIImageView!
    @IBOutlet weak var cnicBack: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeTitle.textColor = ColorConstants.textGray
        makeTitle.font = FontConstants.regular?.withSize(14)
        makeTitle.text = "ownerName".localized()
        
        makeValue.textColor = ColorConstants.textBlack
        makeValue.font = FontConstants.bold?.withSize(15)
        
        regNumTitle.textColor = ColorConstants.textGray
        regNumTitle.font = FontConstants.regular?.withSize(14)
        regNumTitle.text = "registrationNum".localized()
        
        regNumValue.textColor = ColorConstants.textBlack
        regNumValue.font = FontConstants.bold?.withSize(15)
        
        vehicleTypeTitle.textColor = ColorConstants.textGray
        vehicleTypeTitle.font = FontConstants.regular?.withSize(14)
        vehicleTypeTitle.text = "vehicleType".localized()
        
        vehicleTypeValue.textColor = ColorConstants.textBlack
        vehicleTypeValue.font = FontConstants.bold?.withSize(15)
        
        registeredInTitle.textColor = ColorConstants.textGray
        registeredInTitle.font = FontConstants.regular?.withSize(14)
        registeredInTitle.text = "expiryDate".localized()
        
        registeredInValue.textColor = ColorConstants.textBlack
        registeredInValue.font = FontConstants.bold?.withSize(15)
    }
    
    func configure(ownerName: String, regNum: String, expiryDate: String, vehicleType: String) {
        makeValue.text = ownerName
        regNumValue.text = regNum
        vehicleTypeValue.text = vehicleType
        registeredInValue.text = expiryDate
    }
    
    func setImages(carFrontURL: String, carBackURL: String, cnicFrontURL: String, cnicBackURL: String) {
        carFront.sd_setImage(with: URL(string: carFrontURL)) { image, error, isLoadedFromCache, imageURL in
        }
        carBack.sd_setImage(with: URL(string: carBackURL)) { image, error, isLoadedFromCache, imageURL in
        }
        cnicfront.sd_setImage(with: URL(string: cnicFrontURL)) { image, error, isLoadedFromCache, imageURL in
        }
        cnicBack.sd_setImage(with: URL(string: cnicBackURL)) { image, error, isLoadedFromCache, imageURL in
        }
    }

    class func height() -> CGFloat {
        return 130.0
    }
}
