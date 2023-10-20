//
//  AddEmployeeVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 16/06/22.
//

import UIKit
import FirebaseAnalytics

protocol AddEmployeeVCDelegate : NSObjectProtocol {
    func didDismiss()
}
extension AddEmployeeVCDelegate{
    func didDismiss(){}
 
}


class AddEmployeeVC:BaseViewController, StoryboardSceneBased{

    var delegate:AddEmployeeVCDelegate?
    @IBOutlet weak var viewPopup: UIView!
    
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblDesc1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var lblDesc2: UILabel!
    @IBOutlet weak var lblTitle3: UILabel!
    @IBOutlet weak var lblDesc3: UILabel!
    @IBOutlet weak var lblTitle4: UILabel!
    @IBOutlet weak var lblDesc4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopup.alpha = 0.0
        // Do any additional setup after loading the view.
        
        lblTitle.text = NSLocalizedString("Add New Employee", comment: "lblTitle")
        lblDesc.text = NSLocalizedString("How would you like to add your employees?", comment: "lblDesc")
        lblTitle1.text = NSLocalizedString("Invite Employees via Referral Code", comment: "lblTitle1")
        lblDesc1.text = NSLocalizedString("Gives you a referral code employees can use to join your organization", comment: "lblDesc1")
        lblTitle2.text = NSLocalizedString("Invite Employees via Text Message", comment: "lblTitle2")
        lblDesc2.text = NSLocalizedString("Employees will receive an invite via text to create their profile", comment: "lblDesc2")
        lblTitle3.text = NSLocalizedString("Invite Employees via Email", comment: "lblTitle3")
        lblDesc3.text = NSLocalizedString("Employees will receive an invite via  email to create their profile", comment: "lblDesc3")
        lblTitle4.text = NSLocalizedString("Manually Create Employees", comment: "lblTitle4")
        lblDesc4.text = NSLocalizedString("Create each employee manually", comment: "lblDesc4")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.viewPopup.alpha = 1.0
        }
    }
    
    @IBAction func closeClicked(sender:UIButton){
        UIView.animate(withDuration: 0.25) {
            self.viewPopup.alpha = 0.0
            self.dismiss(animated:false)
            self.popVC()
        }
        
    }
    
    @IBAction func addClick(sender:UIButton){
        if sender.tag == 4{
            self.dismiss(animated:false) {
                self.delegate?.didDismiss()
            }
        }else if sender.tag == 3{
            LogFirebaseEvents(event_type: "EM", event_name: "emp_invitation_sent", content_type: "button")
            let vc = InviteViaEmailVC.instantiate()
            self.pushVC(controller:vc)
        }else if sender.tag == 2{
            LogFirebaseEvents(event_type: "TM", event_name: "emp_invitation_sent", content_type: "button")
            let vc = InviteViaTextVC.instantiate()
            self.pushVC(controller:vc)
        }else if sender.tag == 1{
            let vc = InviteViaRefferalLinkVC.instantiate()
            self.pushVC(controller:vc)
        }else{
            self.dismiss(animated:true) {
                self.delegate?.didDismiss()
            }
        }
    }
    
    private func LogFirebaseEvents(event_type: String, event_name: String, content_type: String){
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: event_type,
          AnalyticsParameterItemName: event_name,
          AnalyticsParameterContentType: content_type,
        ])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
