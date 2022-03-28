//
//  FeedbackCell.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 14/09/2021.
//

import UIKit

class FeedbackCell: UICollectionViewCell {

    @IBOutlet weak var mtagLabel: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    @IBOutlet weak var dateOfSubmission: UILabel!
    
    static let identifier = "FeedbackCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        remarksLabel.textColor = ColorConstants.textGray
        remarksLabel.font = FontConstants.regular?.withSize(14)
        
        mtagLabel.textColor = ColorConstants.textBlack
        mtagLabel.font = FontConstants.regular?.withSize(15)
        
        dateOfSubmission.textColor = ColorConstants.textGray
        dateOfSubmission.font = FontConstants.regular?.withSize(14)
    }
    
    func configure(mtag: String, remarks: String, date: String) {
        mtagLabel.text = "mtag".localized() + mtag
        remarksLabel.text = "remarks".localized() + ": " + remarks
        dateOfSubmission.text = date
    }
    
    class func height() -> CGFloat {
        return 102.0
    }

}
