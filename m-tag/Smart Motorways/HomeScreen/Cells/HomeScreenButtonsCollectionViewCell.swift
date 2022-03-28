//
//  HomeScreenButtonsCollectionViewCell.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 27/06/2021.
//

import UIKit

class HomeScreenButtonsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myMtags: UIView!
    @IBOutlet weak var tollHistory: UIView!
    @IBOutlet weak var recharge: UIView!
    @IBOutlet weak var pendingMtag: UIView!
    @IBOutlet weak var request: UIView!
    @IBOutlet weak var tollCalculator: UIView!
    @IBOutlet weak var tollcharges: UIView!
    @IBOutlet weak var helpline: UIView!
    
    @IBOutlet weak var myMtagsLabel: UILabel!
    @IBOutlet weak var tollHistoryLabel: UILabel!
    @IBOutlet weak var rechargeLabel: UILabel!
    @IBOutlet weak var pendingMtagLabel: UILabel!
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var tollCalculatorLabel: UILabel!
    @IBOutlet weak var tollchargesLabel: UILabel!
    @IBOutlet weak var helplineLabel: UILabel!
    
    static let identifier = "HomeScreenButtonsCollectionViewCell"
    var myMtagAction: (() -> ())?
    var tollHistoryAction: (() -> ())?
    var pendingMtagAction: (() -> ())?
    var requestAction: (() -> ())?
    var tollChargesAction: (() -> ())?
    var tollCalculatorAction: (() -> ())?
    var helplineAction: (() -> ())?
    var rechargeAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        myMtagsLabel.font = FontConstants.bold?.withSize(14)
        myMtagsLabel.textColor = ColorConstants.textBlack
        myMtagsLabel.text = "myMtag".localized()
        
        tollHistoryLabel.font = FontConstants.bold?.withSize(14)
        tollHistoryLabel.textColor = ColorConstants.textBlack
        tollHistoryLabel.text = "tollHistory".localized()
        
        rechargeLabel.font = FontConstants.bold?.withSize(14)
        rechargeLabel.textColor = ColorConstants.textBlack
        rechargeLabel.text = "recharge".localized()
        
        pendingMtagLabel.font = FontConstants.bold?.withSize(14)
        pendingMtagLabel.textColor = ColorConstants.textBlack
        pendingMtagLabel.text = "pendingMtag".localized()
        
        requestLabel.font = FontConstants.bold?.withSize(14)
        requestLabel.textColor = ColorConstants.textBlack
        requestLabel.text = "request_mtag".localized()
        
        tollCalculatorLabel.font = FontConstants.bold?.withSize(14)
        tollCalculatorLabel.textColor = ColorConstants.textBlack
        tollCalculatorLabel.text = "tollCalculator".localized()
        
        tollchargesLabel.font = FontConstants.bold?.withSize(14)
        tollchargesLabel.textColor = ColorConstants.textBlack
        tollchargesLabel.text = "feedback".localized()
        
        helplineLabel.font = FontConstants.bold?.withSize(14)
        helplineLabel.textColor = ColorConstants.textBlack
        helplineLabel.text = "helpline".localized()
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(mtagTapped(tapGestureRecognizer:)))
        myMtags.isUserInteractionEnabled = true
        myMtags.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(tollHistoryTapped(tapGestureRecognizer:)))
        tollHistory.isUserInteractionEnabled = true
        tollHistory.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(pendingMtagTapped(tapGestureRecognizer:)))
        pendingMtag.isUserInteractionEnabled = true
        pendingMtag.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(requestMtagTapped(tapGestureRecognizer:)))
        request.isUserInteractionEnabled = true
        request.addGestureRecognizer(tapGestureRecognizer4)
        
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(tollChargesTapped(tapGestureRecognizer:)))
        tollcharges.isUserInteractionEnabled = true
        tollcharges.addGestureRecognizer(tapGestureRecognizer5)
        
        let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(tollCalcTapped(tapGestureRecognizer:)))
        tollCalculator.isUserInteractionEnabled = true
        tollCalculator.addGestureRecognizer(tapGestureRecognizer6)
        
        let tapGestureRecognizer7 = UITapGestureRecognizer(target: self, action: #selector(helplineTapped(tapGestureRecognizer:)))
        helpline.isUserInteractionEnabled = true
        helpline.addGestureRecognizer(tapGestureRecognizer7)
        
        let tapGestureRecognizer8 = UITapGestureRecognizer(target: self, action: #selector(rechargeTapped(tapGestureRecognizer:)))
        recharge.isUserInteractionEnabled = true
        recharge.addGestureRecognizer(tapGestureRecognizer8)
    }
    
    func configure(myMtagAction: @escaping (() -> ()), tollHistoryAction: @escaping (() -> ()), pendingMtagAction: @escaping (() -> ()), requestaction: @escaping (() -> ()), tollchargesAction: @escaping (() -> ()), tollCalculatorAction: @escaping (() -> ()), helplineAction: @escaping (() -> ()), rechargeAction: @escaping (() -> ())) {
        self.myMtagAction = myMtagAction
        self.tollHistoryAction = tollHistoryAction
        self.pendingMtagAction = pendingMtagAction
        self.requestAction = requestaction
        self.tollChargesAction = tollchargesAction
        self.tollCalculatorAction = tollCalculatorAction
        self.helplineAction = helplineAction
        self.rechargeAction = rechargeAction
    }
    
    @objc func mtagTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        myMtagAction?()
    }
    
    @objc func tollHistoryTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        tollHistoryAction?()
    }
    
    @objc func rechargeTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        rechargeAction?()
    }
    
    @objc func pendingMtagTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        pendingMtagAction?()
    }
    
    @objc func requestMtagTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        requestAction?()
    }
    
    @objc func tollCalcTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        tollCalculatorAction?()
    }
    
    @objc func tollChargesTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        tollChargesAction?()
    }
    
    @objc func helplineTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        helplineAction?()
    }
    
    class func height() -> CGFloat {
        return 380
    }

}
