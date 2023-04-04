//
//  ForgotPasswordVC.swift
//  Liteapp
//
//  Created by Apurv Soni on 21/08/22.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSendInstructions: UIButton!
    @IBOutlet weak var btnBackToLogin: UIButton!
    @IBOutlet weak var emailTextValidationView: UIView!
    @IBOutlet weak var viewGradiantContainer: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    
    // MARK: - Variables
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewGradiantContainer.setGradientBackground()
        lblTitle.text = NSLocalizedString("Forgot Password", comment: "lblTitle")
        lblDescription.text = NSLocalizedString("Enter the email associated with your account to receive password reset instructions", comment: "lblDescription")
        lblEmail.text = NSLocalizedString("Email", comment: "emailLabel")
        txtEmail.placeholder = NSLocalizedString("Enter Email", comment: "emailPlaceholder")
        emailValidationLabel.text = NSLocalizedString("Please Enter Email", comment: "emailValidationLabel")
        btnSendInstructions.setTitle(NSLocalizedString("Send Instructions", comment: "btnSendInstructions"), for: .normal)
        btnBackToLogin.setTitle(NSLocalizedString("Back to Login", comment: "btnBackToLogin"), for: .normal)
    }

    // MARK: - Button actions
    
    @IBAction func btnSendInstructionsTapped(_ sender: Any) {
        checkTextValidation()
        if checkValidation(){
            self.forgotPasswordAPI()
        }
    }
    
    
    @IBAction func btnBackToLoginTapped(_ sender: Any) {
        self.popVC()
    }

    // MARK: - Validations
    func checkTextValidation(){
        if txtEmail.text!.count < 1{
            self.emailTextValidationView.isHidden = false
        }else{
            self.emailTextValidationView.isHidden = true
        }
    }
    
    func checkValidation()->Bool{
        if txtEmail.text!.count < 1{
//            self.showAlert(alertType:.validation, message: "Please enter valid username")
            return false
        }
        if txtEmail.text!.count > 0{
            if txtEmail.text!.isEmail == false{
                self.showAlert(alertType:.validation, message: "Invalid E-mail. Please Try Again.")
                return false
            }
        }
        
        return true
    }
    
    // MARK: - API Call
    func forgotPasswordAPI(){
        let parameter = ["emp_work_email":txtEmail.text!]
        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints: APIEndPoints.forgotPassword(), param: parameter) { success, response, error in
            if let res = response{
                print(res)
                if let status = res["status"] as? Int{
                    if status == 0{
                        if let messagae  = res["message"] as? String{
                            self.showAlert(alertType:.validation, message: messagae)
                            
                        }
                    }else{
                        //Redirect to next screen
                        let vc = ForgotPasswordCheckMailVC.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
                        vc.strEmail = self.txtEmail.text
                        self.pushVC(controller:vc)
                        
                    }
                }
                
            }else if let err = error{
                print(err)
            }

        }
    }
}
