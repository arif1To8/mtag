//
//  activeMtagTblCell.swift
//  Smart Motorways
//
//  Created by fwo on 15/03/2022.
//

import UIKit

class activeMtagTblCell: UITableViewCell {
    
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var mtagLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var trailingLabel: NSLayoutConstraint!
    @IBOutlet weak var registrationNumber: UILabel!
    static let identifier = "activeMtagTblCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        carModelLabel.textColor = ColorConstants.textGray
        carModelLabel.font = FontConstants.regular?.withSize(14)
        
        mtagLabel.textColor = ColorConstants.textBlack
        mtagLabel.font = FontConstants.regular?.withSize(15)
        
        balanceLabel.textColor = ColorConstants.orange
        balanceLabel.font = FontConstants.bold?.withSize(13)
        
        carImageView.layer.cornerRadius = 9
        
        registrationNumber.textColor = ColorConstants.textGray
        registrationNumber.font = FontConstants.regular?.withSize(14)
        registrationNumber.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(carImageURL: String, mtagNumber: String, carModel: String, balance: String, isPending: Bool = false, regNum: String = "") {
        carImageView.sd_setImage(with: URL(string: carImageURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")) { image, error, isLoadedFromCache, imageURL in
            if image == nil {
                self.carImageView.image = UIImage(named: "placeholder-image")
            }
        }
        mtagLabel.text = mtagNumber
        carModelLabel.text = carModel
        balanceLabel.text = balance
        
        var mtagText = NSMutableAttributedString(string: "mtag".localized() + mtagNumber)
        if isPending {
            mtagText = NSMutableAttributedString(string: "referenceNumber".localized() + mtagNumber)
        }
        mtagText.setFont(font: (FontConstants.bold?.withSize(14))!, forText: mtagNumber)
        mtagLabel.attributedText = mtagText
        
        if isPending {
            let balanceText = NSMutableAttributedString(string: "status".localized() + "\n" + "pending".localized())
            balanceText.setColor(color: ColorConstants.textGray, forText: "status".localized())
            balanceText.setFont(font: (FontConstants.regular?.withSize(12))!, forText: "status".localized())
            balanceLabel.attributedText = balanceText
            arrow.isHidden = true
            trailingLabel.constant = 10
            registrationNumber.isHidden = false
            registrationNumber.text = regNum
        } else {
            registrationNumber.isHidden = true
            let balanceText = NSMutableAttributedString(string: "rs".localized() + balance + "\n" + "balance".localized())
            balanceText.setColor(color: ColorConstants.textGray, forText: "balance".localized())
            balanceText.setFont(font: (FontConstants.regular?.withSize(12))!, forText: "balance".localized())
            balanceLabel.attributedText = balanceText
        }
        
    }
    
    class func height() -> CGFloat {
        return 102.0
    }
    
}
