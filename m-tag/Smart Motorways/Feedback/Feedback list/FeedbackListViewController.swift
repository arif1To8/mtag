//
//  FeedbackListViewController.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 14/09/2021.
//

import UIKit
import NVActivityIndicatorView

class FeedbackListViewController: UIViewController, Storyboarded, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var noRecordsLabel: UILabel!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    var feedbacks: [FeedbackResponse] = []
    let network = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupUI()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFeedbackList()
    }
    
    func setupUI() {
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.color = ColorConstants.orange
        screenTitle.font = FontConstants.bold?.withSize(16)
        screenTitle.textColor = ColorConstants.textGray
        screenTitle.text = "feedback".localized()
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = FontConstants.bold?.withSize(35)
        addButton.backgroundColor = ColorConstants.orange
        noRecordsLabel.textColor = ColorConstants.textBlack
        noRecordsLabel.font = FontConstants.bold?.withSize(18)
        noRecordsLabel.text = "noRecordAvailable".localized()
    }
    
    func registerCells() {
        collectionView.register(UINib(nibName: FeedbackCell.identifier, bundle: nil), forCellWithReuseIdentifier: FeedbackCell.identifier)
    }

    @IBAction func backPressed(_ sender: UIButton) {
        Router.pop(from: self)
    }
    
    @IBAction func addPressed(_ sender: UIButton) {
        Router.showFeedback(from: self)
    }
}

extension FeedbackListViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedbacks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedbackCell.identifier, for: indexPath) as! FeedbackCell
        cell.configure(mtag: feedbacks[indexPath.row].ITOKENNO ?? "", remarks: feedbacks[indexPath.row].REMARKS ?? "", date: feedbacks[indexPath.row].SUBMSSIONDATE ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: MtagCollectionViewCell.height())
    }
}

extension FeedbackListViewController {
    func getFeedbackList() {
        activityIndicator.startAnimating()
        collectionView.isUserInteractionEnabled = false
        network.request("getFeedback",
                        method: .post,
                        headers: [HeaderConstants.authorization: "Bearer \(LocalStorage.getAccessToken())",
                                  HeaderConstants.accept:HeaderConstants.acceptValue],
                        modelType: FeedbackListResponse.self,
                        success: { (response) in
                            if let response = response as? FeedbackListResponse {
                                self.feedbacks = response.Data ?? []
                                self.activityIndicator.stopAnimating()
                                self.collectionView.isUserInteractionEnabled = true
                                self.collectionView.reloadData()
                            }
                            if self.feedbacks.count == 0 {
                                self.noRecordsLabel.isHidden = false
                            }
                        },
                        failure: { (error) in
                            self.collectionView.isUserInteractionEnabled = true
                            self.activityIndicator.stopAnimating()
                            self.noRecordsLabel.isHidden = false
                        })
    }
}
