//
//  MtagHeaderCollectionReusableView.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 07/06/2021.
//

import UIKit

class MtagHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pendingCount: UILabel!
    @IBOutlet weak var pendingButton: UIButton!
    
    var pendingAction: (() -> ())?
    static let identifier = "MtagHeaderCollectionReusableView"

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = ColorConstants.textGray
        titleLabel.font = FontConstants.bold?.withSize(16)
        
        pendingButton.tintColor = ColorConstants.textGray
        pendingButton.titleLabel?.font = FontConstants.regular?.withSize(16)
        
        pendingCount.textColor = ColorConstants.textGray
        pendingCount.font = FontConstants.bold?.withSize(15)
        
        titleLabel.text = "mtagAssigned".localized()
        pendingButton.setTitle("pending".localized(), for: .normal)
    }
    
    func configure(pending: Int, pendingAction: @escaping (() -> ())) {
        self.pendingAction = pendingAction
        pendingCount.text = "\(pending)"
    }
    
    @IBAction func pendingTapped(_ sender: UIButton) {
        pendingAction?()
    }
    
    class func height() -> CGFloat {
        return 37.0
    }
    
}
