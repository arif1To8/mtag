//
//  VehicleDetailCarCollectionViewCell.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 07/06/2021.
//

import UIKit

class VehicleDetailCarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var mtagLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var rechargeButton: UIButton!
    var mtagDetailsObject: MtagDetailsObject!
    var showMtagRchargeViewController: () -> () = {}

    static let identifier = "VehicleDetailCarCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        carModelLabel.textColor = ColorConstants.textGray
        carModelLabel.font = FontConstants.regular?.withSize(16)
        
        mtagLabel.textColor = ColorConstants.textBlack
        mtagLabel.font = FontConstants.regular?.withSize(18)
        
        balanceLabel.textColor = ColorConstants.orange
        balanceLabel.font = FontConstants.bold?.withSize(15)
        
        carImageView.layer.cornerRadius = 9
        
        rechargeButton.backgroundColor = ColorConstants.orange
        rechargeButton.setTitle("recharge".localized(), for: .normal)
        rechargeButton.layer.cornerRadius = 10
        rechargeButton.setTitleColor(ColorConstants.white, for: .normal)
        rechargeButton.titleLabel?.font = FontConstants.regular?.withSize(16)
    }
    
    func configure(carImageURL: String, mtagNumber: String, carModel: String, balance: String) {
        carImageView.sd_setImage(with: URL(string: carImageURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")) { image, error, isLoadedFromCache, imageURL in
            if image == nil {
                self.carImageView.image = UIImage(named: "placeholder-image")
            }
        }
        mtagLabel.text = mtagNumber
        carModelLabel.text = carModel
        balanceLabel.text = balance
        
        let mtagText = NSMutableAttributedString(string: "mtag".localized() + mtagNumber)
        mtagText.setFont(font: (FontConstants.bold?.withSize(18))!, forText: mtagNumber)
        mtagLabel.attributedText = mtagText
        
        let balanceText = NSMutableAttributedString(string: "rs".localized() + balance + "\n" + "balance".localized())
        balanceText.setColor(color: ColorConstants.textGray, forText: "balance".localized())
        balanceText.setFont(font: (FontConstants.regular?.withSize(14))!, forText: "balance".localized())
        balanceLabel.attributedText = balanceText
    }
    
    class func height() -> CGFloat {
        return 150.0
    }
    
    @IBAction func rechargePressed(_ sender: UIButton) {
      //  if let vc = UIApplication.topViewController() {
            
            showMtagRchargeViewController()
            

//            Helper.showAlert("comingsoon".localized(), message: "comingSoonRecharge".localized(), controller: vc)
      //  }
    }
}
