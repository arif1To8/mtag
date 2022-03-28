//
//  PendingMtagListViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 16/06/2021.
//

import UIKit

class PendingMtagListViewController: UIViewController, Storyboarded, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var noRecordsLabel: UILabel!
    var pendingMtagList: [PendingMtagObject]! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "pendingMtag".localized()
        noRecordsLabel.text = "noRecordAvailable".localized()
        noRecordsLabel.textColor = ColorConstants.textBlack
        noRecordsLabel.font = FontConstants.bold?.withSize(18)
        registerCells()
        if pendingMtagList.count == 0 {
            noRecordsLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            noRecordsLabel.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: MtagCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MtagCollectionViewCell.identifier)
    }

    @IBAction func backPressed(_ sender: UIButton) {
        Router.pop(from: self)
    }
}

extension PendingMtagListViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pendingMtagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MtagCollectionViewCell.identifier, for: indexPath) as! MtagCollectionViewCell
        cell.configure(carImageURL: ApiConstants.url + (pendingMtagList[indexPath.row].CARFRONTPICTURE ?? ""), mtagNumber: pendingMtagList[indexPath.row].REF_NO ?? "", carModel: pendingMtagList[indexPath.row].VEHICLEMAKEMODEL ?? "", balance: "0", isPending: true, regNum: pendingMtagList[indexPath.row].VEHICLEREGISTRATIONNUMBER ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: MtagCollectionViewCell.height())
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Router.showPendingMtagDetailPopUp(from: self, detail: pendingMtagList[indexPath.row])
    }
}
