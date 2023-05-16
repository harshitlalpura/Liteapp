//
//  ResetPasswordVC.swift
//  Liteapp
//
//  Created by Apurv Soni on 29/08/22.
//

import UIKit

class ResetPasswordVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewEnterPassword: UIView!
    @IBOutlet weak var btnPasswordVisibility: UIButton!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var viewReEnterPassword: UIView!
    @IBOutlet weak var btnConfirmPasswordVisibility: UIButton!
    
    @IBOutlet weak var passwordValidationView: UIView!
    
    @IBOutlet weak var imgvwminimumCharacter: UIImageView!
    @IBOutlet weak var imgvwLowercaseLetter: UIImageView!
    @IBOutlet weak var imgvwCapitalLetter: UIImageView!
    @IBOutlet weak var imgvwNumber: UIImageView!
    @IBOutlet weak var imgvwSpecialCharacter: UIImageView!
    @IBOutlet weak var vwGradiantContainer: UIView!
    
    @IBOutlet weak var requirementTitleLabel: UILabel!
    @IBOutlet weak var requirementLabel1: UILabel!
    @IBOutlet weak var requirementLabel2: UILabel!
    @IBOutlet weak var requirementLabel3: UILabel!
    @IBOutlet weak var requirementLabel4: UILabel!
    @IBOutlet weak var requirementLabel5: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordValidationLabel: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnResetPassword: UIButton!
    
    // MARK: - Variables
    var empId : String = ""
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()
        Defaults.shared.forgotPasswordEmpId = nil
        // Do any additional setup after loading the view.
        
        requirementTitleLabel.text = NSLocalizedString("Please complete all the requirements.", comment: "requirementTitleLabel")
        requirementLabel1.text = NSLocalizedString("Minimum 8 characters", comment: "requirementLabel1")
        requirementLabel2.text = NSLocalizedString("Lowercase Letter", comment: "requirementLabel2")
        requirementLabel3.text = NSLocalizedString("Capital Letter", comment: "requirementLabel3")
        requirementLabel4.text = NSLocalizedString("Number", comment: "requirementLabel4")
        requirementLabel5.text = NSLocalizedString("Special Character", comment: "requirementLabel5")
        lblTitle.text = NSLocalizedString("Create New Password", comment: "lblTitle")
        lblDescription.text = NSLocalizedString("Enter your new password below, both passwords must match", comment: "lblDescription")
        passwordLabel.text = NSLocalizedString("Password", comment: "passwordLabel")
        txtPassword.placeholder = NSLocalizedString("Enter Password", comment: "txtPassword")
        passwordValidationLabel.text = NSLocalizedString("Please Enter Password", comment: "passwordValidationLabel")
        confirmPasswordLabel.text = NSLocalizedString("Confirm Password", comment: "confirmPasswordLabel")
        txtConfirmPassword.placeholder = NSLocalizedString("Enter Password Again", comment: "txtConfirmPassword")
        confirmPasswordValidationLabel.text = NSLocalizedString("Please Re-Enter Password", comment: "confirmPasswordValidationLabel")
        btnBack.setTitle(NSLocalizedString("Back to Login", comment: "btnBack"), for: .normal)
        btnResetPassword.setTitle(NSLocalizedString("Reset Password", comment: "btnResetPassword"), for: .normal)
    }
    
    // MARK: - Button Actions
    @IBAction func btnPasswordVisibility(_ sender: Any) {
        if txtPassword.isSecureTextEntry == true{
            txtPassword.isSecureTextEntry = false
            btnPasswordVisibility.setImage(UIImage.init(named: "ic_visibilityOff"), for: .normal)
        } else {
            txtPassword.isSecureTextEntry = true
            btnPasswordVisibility.setImage(UIImage.init(named: "ic_visibility"), for: .normal)
        }
        
    }
    
    @IBAction func btnConfirmPasswordVisibility(_ sender: Any) {
        if txtConfirmPassword.isSecureTextEntry == true{
            txtConfirmPassword.isSecureTextEntry = false
            btnConfirmPasswordVisibility.setImage(UIImage.init(named: "ic_visibilityOff"), for: .normal)
        } else {
            txtConfirmPassword.isSecureTextEntry = true
            btnConfirmPasswordVisibility.setImage(UIImage.init(named: "ic_visibility"), for: .normal)
        }
        
    }
    
    @IBAction func btnResetPasswordTapped(_ sender: Any) {
        if checkValidation(){
            resetPasswordAPI()
        }
    }
    
    @IBAction func btnBackToLoginTapped(_ sender: Any) {
        self.popVC()
    }
    
    // MARK: - Validations
    func checkTextValidation(){
        if txtPassword.text!.count < 1{
            self.viewEnterPassword.isHidden = false
        }else{
            self.viewEnterPassword.isHidden = true
        }
        if txtConfirmPassword.text!.count < 1{
            self.viewReEnterPassword.isHidden = false
        }else{
            self.viewReEnterPassword.isHidden = true
        }
       
    }
    func checkValidation()->Bool{
        checkTextValidation()
        
        if txtPassword.text!.count < 1 || txtConfirmPassword.text!.count < 1 {
            return false
        }
        if txtPassword.text! != txtConfirmPassword.text!{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Passwords do not match.", comment: "alertLabel"))
            return false
        }
        return true
    }
    
    // MARK: - API Calls
    func resetPasswordAPI(){
        let parameter = ["emp_id":empId,"new_password":txtPassword.text!]
        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints: APIEndPoints.resetPassword(), param: parameter) { success, response, error in
            if let res = response{
                print(res)
                if let status = res["status"] as? Int{
                    if status == 0{
                        if let messagae  = res["message"] as? String{
                            self.showAlert(alertType:.validation, message: messagae)
                            
                        }
                    }else{
                        //Redirect to next screen
                        let vc = ResetPasswordSuccessVC.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
                        self.pushVC(controller:vc)
                    }
                }
                
            }else if let err = error{
                print(err)
            }

        }
    }
    
}
extension ResetPasswordVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPassword{
            self.updatePasswordValidation(str:textField.text!)
            self.passwordValidationView.isHidden = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPassword{
            self.updatePasswordValidation(str:textField.text!)
            self.passwordValidationView.isHidden = true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPassword{
            
            if let char = string.cString(using: String.Encoding.utf8) {
                   let isBackSpace = strcmp(char, "\\b")
                   if (isBackSpace == -92) {
                       print("Backspace was pressed")
                       self.updatePasswordValidation(str:String(textField.text?.dropLast() ?? ""))
                   }else{
                       self.updatePasswordValidation(str:textField.text! + string)
                   }
            }else{
                self.updatePasswordValidation(str:textField.text! + string)
            }
           
        }
        return true
    }
    func updatePasswordValidation(str:String){
            if str == ""{
                imgvwminimumCharacter.image = UIImage.unselectedImage
                imgvwCapitalLetter.image = UIImage.unselectedImage
                imgvwLowercaseLetter.image = UIImage.unselectedImage
                imgvwNumber.image = UIImage.unselectedImage
                imgvwSpecialCharacter.image = UIImage.unselectedImage
            }
         
            if str.count >= 8{
                imgvwminimumCharacter.image = UIImage.selectedImage
            }else{
                imgvwminimumCharacter.image = UIImage.unselectedImage
            }
           let capitalLetterRegEx  = ".*[A-Z]+.*"
           let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
            if texttest.evaluate(with: str){
                imgvwCapitalLetter.image = UIImage.selectedImage
            }else{
                imgvwCapitalLetter.image = UIImage.unselectedImage
            }
          
            let lowercaseLetterRegEx  = ".*[a-z]+.*"
            let texttest3 = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegEx)
             if texttest3.evaluate(with: str){
                 imgvwLowercaseLetter.image = UIImage.selectedImage
             }else{
                 imgvwLowercaseLetter.image = UIImage.unselectedImage
             }

           let numberRegEx  = ".*[0-9]+.*"
           let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            if texttest1.evaluate(with: str){
                imgvwNumber.image = UIImage.selectedImage
            }else{
                imgvwNumber.image = UIImage.unselectedImage
            }

           let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
           let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            if texttest2.evaluate(with: str){
                imgvwSpecialCharacter.image = UIImage.selectedImage
            }else{
                imgvwSpecialCharacter.image = UIImage.unselectedImage
            }
        
    }
}
