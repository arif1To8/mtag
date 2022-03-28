//
//  TollChargesTableViewCell.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 29/06/2021.
//

import UIKit

class TollChargesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    static let identifier = "TollChargesTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        vehicleTypeLabel.textColor = ColorConstants.textBlack
        vehicleTypeLabel.font = FontConstants.bold?.withSize(15)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String) {
        vehicleTypeLabel.text = title
    }
    
    class func height() -> CGFloat {
        return 25.0
    }
    
}
