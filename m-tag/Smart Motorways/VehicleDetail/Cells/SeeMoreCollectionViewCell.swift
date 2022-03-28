//
//  SeeMoreCollectionViewCell.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 14/06/2021.
//

import UIKit

class SeeMoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var seeMoreButton: UIButton!
    
    var mtagId = ""
    static let identifier = "SeeMoreCollectionViewCell"
    var action: (() ->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        seeMoreButton.layer.cornerRadius = 10
        seeMoreButton.layer.borderWidth = 1
        seeMoreButton.layer.borderColor = ColorConstants.textGray.cgColor
        
        seeMoreButton.setTitle("seeMore".localized(), for: .normal)
        seeMoreButton.titleLabel?.font = FontConstants.regular?.withSize(16)
        seeMoreButton.tintColor = ColorConstants.textGray
    }
    
    func configure(mtagId: String, action: @escaping (() ->())) {
        self.mtagId = mtagId
        self.action = action
    }
    
    @IBAction func seeMoreTapped(_ sender: UIButton) {
        action?()
    }
    
    class func height() -> CGFloat {
        return 50.0
    }

}
