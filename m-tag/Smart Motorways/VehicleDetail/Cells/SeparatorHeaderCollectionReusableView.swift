//
//  TransactionHeaderCollectionReusableView.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 07/06/2021.
//

import UIKit

class SeparatorHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var transactionTitle: UILabel!
    
    static let identifier = "SeparatorHeaderCollectionReusableView"

    override func awakeFromNib() {
        super.awakeFromNib()
        transactionTitle.textColor = ColorConstants.textBlack
        transactionTitle.font = FontConstants.bold?.withSize(16)
    }
    
    func configure(titleText: String) {
        transactionTitle.text = titleText
    }
    
    class func height() -> CGFloat {
        return 86.0
    }
    
}
