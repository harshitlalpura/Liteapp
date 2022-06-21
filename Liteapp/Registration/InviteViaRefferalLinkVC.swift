//
//  InviteViaRefferalLinkVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 19/06/22.
//

import UIKit

class InviteViaRefferalLinkVC:BaseViewController,StoryboardSceneBased{

    static let sceneStoryboard = UIStoryboard(name: StoryboardName.merchant.rawValue, bundle: nil)
    var inviteLink = ""
    @IBOutlet weak var lblCode: UILabel!
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        inviteLink = "Hey! Please download our TimeClock App with the link below. \n Your referral code is 0DB9.\n https://lite.testbryteportal.com/\(Defaults.shared.currentUser?.merchantReferenceNumber ?? "")"
        lblCode.text = "\(Defaults.shared.currentUser?.merchantReferenceNumber ?? "")"
    }
    @IBAction func backClicked(sender:UIButton){
        self.popVC()
    }
    @IBAction func copyClicked(sender:UIButton){
        UIPasteboard.general.string = "\(Defaults.shared.currentUser?.merchantReferenceNumber ?? "")"
    }

    

}
