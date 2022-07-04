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
    //https://lite.testbryteportal.com/referral/NAS0
        // Do any additional setup after loading the view.
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
