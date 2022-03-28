//
//  HistoryTableViewCell.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 08/06/2021.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var mTagIDLabel: UILabel!
    static let identifier = "HistoryTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cityLabel.textColor = ColorConstants.textBlack
        cityLabel.font = FontConstants.regular?.withSize(18)
        
        dateLabel.textColor = ColorConstants.textGray
        dateLabel.font = FontConstants.regular?.withSize(14)
        
        amountLabel.font = FontConstants.bold?.withSize(15)
        mTagIDLabel.font = FontConstants.regular?.withSize(14)
        mTagIDLabel.textColor = ColorConstants.textGray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(transaction: TransactionObject) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let transactionDate = dateFormatter.date(from: transaction.TRANS_TIME ?? "")
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        dateLabel.text = dateFormatter.string(from: transactionDate ?? Date())
        mTagIDLabel.text = "M-Tag \(transaction.ITOKKENNO ?? "N/A")"
        
        if transaction.CR == "-"{
            cityLabel.text = "\(transaction.ENTRY_STATION_NAME ?? "N/A") - \(transaction.EXIT_STATION_NAME ?? "N/A")"
            amountLabel.textColor = ColorConstants.red
            
            let amountText = NSMutableAttributedString(string: "- " + "rs".localized() + "\(transaction.FARE ?? "")" + "\n" + "deduction".localized())
            amountText.setColor(color: ColorConstants.textGray, forText: "deduction".localized())
            amountText.setFont(font: (FontConstants.regular?.withSize(14))!, forText: "deduction".localized())
            amountLabel.attributedText = amountText
            
        }
        else{
            cityLabel.text = transaction.EXIT_STATION_NAME
            amountLabel.textColor = ColorConstants.green
            let amountText = NSMutableAttributedString(string: "+ " + "rs".localized() + "\(transaction.FARE ?? "")" + "\n" + "added".localized())
            amountText.setColor(color: ColorConstants.textGray, forText: "added".localized())
            amountText.setFont(font: (FontConstants.regular?.withSize(14))!, forText: "added".localized())
            amountLabel.attributedText = amountText
            
        }
        
    }
    
    
    class func height() -> CGFloat {
        return 76.0
    }
    
}
