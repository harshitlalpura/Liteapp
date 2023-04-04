//
//  InviteViaRefferalLinkVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 19/06/22.
//

import UIKit

class InviteViaRefferalLinkVC:BaseViewController,StoryboardSceneBased{

    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
    
    var inviteLink = ""
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblviaCode: UILabel!
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var btnClose: UIButton!
       
    override func viewDidLoad() {
        super.viewDidLoad()
    //https://lite.testbryteportal.com/referral/NAS0
        // Do any additional setup after loading the view.
        
        lblTitle.text = NSLocalizedString("Add New Employee", comment: "lblTitle")
        lblDesc.text = NSLocalizedString("This referral code allows anyone who has it to join this organization. This referral code is only valid for 30 days.", comment: "lblDesc")
        lblviaCode.text = NSLocalizedString("via Referral Code", comment: "lblviaCode")
        btnCode.setTitle(NSLocalizedString("Copy Code", comment: "btnCode"), for: .normal)
        btnClose.setTitle(NSLocalizedString("Close", comment: "btnClose"), for: .normal)
        
        inviteLink = "Hey! Please download our TimeClock App with the link below. \n Your referral code is \(Defaults.shared.currentUser?.merchantReferenceNumber ?? "").\n https://lite.testbryteportal.com/referral/\(Defaults.shared.currentUser?.merchantReferenceNumber ?? "")"
        lblCode.text = "\(Defaults.shared.currentUser?.merchantReferenceNumber ?? "")"
    }
    @IBAction func backClicked(sender:UIButton){
        self.popVC()
    }
    @IBAction func copyClicked(sender:UIButton){
        UIPasteboard.general.string = "\(Defaults.shared.currentUser?.merchantReferenceNumber ?? "")"
        self.showToast(message:"Copied to clipboard", font: UIFont.RobotoRegular(size:16.0))
    }

    

}
extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }
