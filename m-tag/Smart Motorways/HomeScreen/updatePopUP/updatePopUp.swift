//
//  updatePopUp.swift
//  Smart Motorways
//
//  Created by fwo on 25/03/2022.
//

import UIKit

class updatePopUp: UIViewController, Storyboarded {
    
    var desc:String!
    @IBOutlet weak var lblDetail: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lblDetail.text = desc
    }

    
    @IBAction func update(){
        Helper.moveToAppstore()
    }

    
    
}
 
