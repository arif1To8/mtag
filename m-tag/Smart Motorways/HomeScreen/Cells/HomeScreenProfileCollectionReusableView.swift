//
//  HomeScreenProfileCollectionReusableView.swift
//  Smart Motorways
//
//  Created by Abdul Wahab on 07/06/2021.
//

import UIKit
import ImageSlideshow

class HomeScreenProfileCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var imageCarousel: ImageSlideshow!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var slideshowHeight: NSLayoutConstraint!
    
    static let identifier = "HomeScreenProfileCollectionReusableView"

    override func awakeFromNib() {
        super.awakeFromNib()
        setImagesForSlideShow()
        profileImageView.makeRounded()
        profileImageView.tintColor = ColorConstants.button_tint
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        if UIDevice.current.userInterfaceIdiom == .pad {
            slideshowHeight.constant = 500
        }
    }
    
    @objc func profileTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if let topViewController = UIApplication.topViewController() {
            Router.showProfile(from: topViewController)
        }
    }
    
    func setImagesForSlideShow() {
        imageCarousel.setImageInputs([
            ImageSource(image: UIImage(named: "slide_1")!),
            ImageSource(image: UIImage(named: "slide_2")!),
            ImageSource(image: UIImage(named: "slide_3")!),
            ImageSource(image: UIImage(named: "slide_4")!),
            ImageSource(image: UIImage(named: "slide_5")!)
        ])
        imageCarousel.contentScaleMode = .scaleAspectFill
        imageCarousel.layer.cornerRadius = 15
        imageCarousel.pageIndicatorPosition = PageIndicatorPosition(horizontal: .center, vertical: .customBottom(padding: 10))
    }
    
    class func height() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 600.0
        }
        return 320.0
    }
    
}
