//
//  InviteViaEmailVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 19/06/22.
//

import UIKit
import MessageUI

class InviteViaEmailVC:BaseViewController, StoryboardSceneBased,MFMailComposeViewControllerDelegate{

    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
    var inviteLink = ""
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblviaEmail: UILabel!
    @IBOutlet weak var lblApple: UILabel!
    @IBOutlet weak var lblGmail: UILabel!
    @IBOutlet weak var lblOutlook: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = NSLocalizedString("Add New Employee", comment: "lblTitle")
        lblDesc.text = NSLocalizedString("Hey! Please join our organization on TimeClock with the link below. The link will allow you to create a employee profile and clock in and out.", comment: "lblDesc")
        lblviaEmail.text = NSLocalizedString("Via Email", comment: "lblviaEmail")
        lblApple.text = NSLocalizedString("Apple", comment: "lblApple")
        lblGmail.text = NSLocalizedString("Gmail", comment: "lblGmail")
        lblOutlook.text = NSLocalizedString("Outlook", comment: "lblOutlook")
        btnClose.setTitle(NSLocalizedString("Close", comment: "btnClose"), for: .normal)
        
        // Do any additional setup after loading the view.
        inviteLink = NSLocalizedString("Hey! Please download our TimeClock App with the link below. \n Your referral code is", comment: "link") +  (Defaults.shared.currentUser?.merchantReferenceNumber ?? "") + ".\n https://lite.testbryteportal.com/referral/" + (Defaults.shared.currentUser?.merchantReferenceNumber ?? "")
    }
    @IBAction func backClicked(sender:UIButton){
        self.popVC()
    }
    
    @IBAction func gmailClicked(sender:UIButton){
        let recipientEmail = ""
        let subject = NSLocalizedString("Join us on TimeClock", comment: "emailsubject")
        let body = "\(self.inviteLink)"
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(recipientEmail)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
       
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
           
            UIApplication.shared.open(gmailUrl)
        }else{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Gmail app not installed", comment: "emailerror"))
        }
        
    }
    @IBAction func outlookClicked(sender:UIButton){
        let recipientEmail = ""
        let subject = NSLocalizedString("Join us on TimeClock", comment: "emailsubject")
        let body = "\(self.inviteLink)"
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
       
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(recipientEmail)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
           
            UIApplication.shared.open(outlookUrl)
        }else{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Outlook app not installed", comment: "emailerror"))
        }
        
    }
    @IBAction func appleMailClicked(sender:UIButton){
        
        let recipientEmail = ""
        let subject = NSLocalizedString("Join us on TimeClock", comment: "emailsubject")
        let body = "\(self.inviteLink)"
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
        
        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
            // Modify following variables with your text / recipient
            let recipientEmail = ""
            let subject = NSLocalizedString("Join us on TimeClock", comment: "emailsubject")
            let body = "\(self.inviteLink)"
            
            // Show default mail composer
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([recipientEmail])
                mail.setSubject(subject)
                mail.setMessageBody(body, isHTML: false)
                
                present(mail, animated: true)
            
            // Show third party email composer if default Mail app is not present
            } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
                UIApplication.shared.open(emailUrl)
            }
    }
            
        private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
            let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            
            let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
            let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
            let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
            
            if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
                return gmailUrl
            } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
                return outlookUrl
            } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
                return yahooMail
            } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
                return sparkUrl
            }
            
            return defaultUrl
        }
            
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
}
