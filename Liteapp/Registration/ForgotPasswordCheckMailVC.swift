//
//  ForgotPasswordCheckMailVC.swift
//  Liteapp
//
//  Created by Apurv Soni on 21/08/22.
//

import UIKit

class ForgotPasswordCheckMailVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var btnResend: UIButton!
    
    @IBOutlet weak var lblInstructions: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var vwGradiantContainer: UIView!
    
    @IBOutlet weak var lblCheckMail: UILabel!
    @IBOutlet weak var lblNoEmailRevieced: UILabel!
    
    // MARK: - Variables
    var strEmail : String?
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()
        lblCheckMail.text = NSLocalizedString("Check your mail", comment: "lblCheckMail")
        lblNoEmailRevieced.text = NSLocalizedString("Didn't receive the email?", comment: "lblNoEmailRevieced")
        if let email = strEmail{
        lblInstructions.text = NSLocalizedString("We have sent password reset instructions to ", comment: "lblInstructions") + email
        }else{
            lblInstructions.text = NSLocalizedString("We have sent password reset instructions to email address", comment: "lblInstructions")
        }
        btnResend.setTitle(NSLocalizedString("Click to resend", comment: "btnResend"), for: .normal)
        btnBack.setTitle(NSLocalizedString("Back to Login", comment: "btnBack"), for: .normal)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func btnResendTapped(_ sender: Any) {
        if let email = strEmail{
            self.forgotPasswordAPI(email: email)
        }
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func forgotPasswordAPI(email : String){
        let parameter = ["emp_work_email":email]
        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints: APIEndPoints.forgotPassword(), param: parameter) { success, response, error in
            if let res = response{
                print(res)
                if let status = res["status"] as? Int{
                    if status == 0{
                        if let messagae  = res["message"] as? String{
                            self.showAlert(alertType:.validation, message: messagae)
                            
                        }
                    }
                }
                
            }else if let err = error{
                print(err)
            }

        }
    }
    
}
