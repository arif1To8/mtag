//
//  deletePermissionPopUp.swift
//  Smart Motorways
//
//  Created by fwo on 15/03/2022.
//

import UIKit






class deletePermissionPopUp: UIViewController,Storyboarded {
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var txtReason: UITextView!
    @IBOutlet weak var viewReason: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOk: UIButton!
    
    var callbackAction: ((String,MtagDetailsObject) -> ())?
    var tagDetailObj: MtagDetailsObject?
    var detail: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUI()
        
    }
    

    private func setupUI() {
        self.txtReason.delegate = self
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        lbltitle.textColor = ColorConstants.textBlack
        lbltitle.font = FontConstants.bold?.withSize(18)
        lbltitle.text = "Delink".localized()
        
        
        lblDesc.textColor = ColorConstants.textGray
        lblDesc.font = FontConstants.regular?.withSize(16)
        
        
        
        btnCancel.backgroundColor = ColorConstants.white
        btnCancel.setTitle("Cancel".localized(), for: .normal)
        btnCancel.setTitleColor(ColorConstants.blue, for: .normal)
        btnCancel.titleLabel?.font = FontConstants.regular?.withSize(16)
        
        btnOk.backgroundColor = ColorConstants.white
        btnOk.setTitle("Ok".localized(), for: .normal)
        btnOk.setTitleColor(ColorConstants.blue, for: .normal)
        btnOk.titleLabel?.font = FontConstants.regular?.withSize(16)
        
        
        self.lblDesc.text = """
                            Are you sure to delink this vehicle
                            M-Tag: \(self.tagDetailObj?.tokenno ?? "")
                            Model: \(self.tagDetailObj?.registration ?? "")
                            """
        
        
        txtReason.font = FontConstants.bold?.withSize(16)
        txtReason.layer.cornerRadius = 12
        txtReason.backgroundColor = ColorConstants.silver.withAlphaComponent(0.3)
        txtReason.isUserInteractionEnabled = true
        txtReason.text = "addReasonHere".localized()
        txtReason.textColor = ColorConstants.textGray.withAlphaComponent(0.5)
        
    }
    
    @IBAction func okBtnAction(_ sender: UIButton) {
        let text = self.txtReason.text ?? ""
        dismiss(animated: false) {
            self.callbackAction!(text, self.tagDetailObj!)
        }
    }
    
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}
extension deletePermissionPopUp:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == "addReasonHere".localized() {
            txtReason.text = ""
            txtReason.textColor = ColorConstants.textBlack
        }
        return true
    }
}
