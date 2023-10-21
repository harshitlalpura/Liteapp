//
//  EmployeeOnboardingVCStep2.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import UIKit

class EmployeeOnboardingVCStep2:BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfrimPassword: UITextField!
    
    var saveEmployee:SaveEmployee!
    @IBOutlet weak var passwordValidationView: UIView!
    @IBOutlet weak var imgvwminimumCharacter: UIImageView!
    @IBOutlet weak var imgvwLowercaseLetter: UIImageView!
    @IBOutlet weak var imgvwCapitalLetter: UIImageView!
    @IBOutlet weak var imgvwNumber: UIImageView!
    @IBOutlet weak var imgvwSpecialCharacter: UIImageView!
    
    @IBOutlet weak var emailTextValidationView: UIView!
    @IBOutlet weak var passwordTextValidationView: UIView!
    @IBOutlet weak var confirmPasswordTextValidationView: UIView!
    @IBOutlet weak var vwGradiantContainer: UIView!
    
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
    @IBOutlet weak var confirmPasswordValidationLabel: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var requirementTitleLabel: UILabel!
    @IBOutlet weak var requirementLabel1: UILabel!
    @IBOutlet weak var requirementLabel2: UILabel!
    @IBOutlet weak var requirementLabel3: UILabel!
    @IBOutlet weak var requirementLabel4: UILabel!
    @IBOutlet weak var requirementLabel5: UILabel!
    
    var performanceTracker = PerformanceTracker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()
        
        lblStep.text = NSLocalizedString("Step 2 of 3", comment: "stepLabel")
        lblTitle.text = NSLocalizedString("Now, let's create your account credentials.", comment: "titleLabel")
        lblEmail.text = NSLocalizedString("Email", comment: "emailLabel")
        txtEmail.placeholder = NSLocalizedString("e.g. myemail@email.com", comment: "emailPlaceholder")
        emailValidationLabel.text = NSLocalizedString("Please Enter Email", comment: "emailValidationLabel")
        lblPassword.text = NSLocalizedString("Password", comment: "passwordLabel")
        txtPassword.placeholder = NSLocalizedString("Enter Password", comment: "passwordPlaceholder")
        passwordValidationLabel.text = NSLocalizedString("Please Enter Password", comment: "passwordValidationLabel")
        lblConfirmPassword.text = NSLocalizedString("Confirm Password", comment: "confirmPasswordLabel")
        txtConfrimPassword.placeholder = NSLocalizedString("Confirm Password", comment: "confirmPasswordPlaceholder")
        confirmPasswordValidationLabel.text = NSLocalizedString("Please Confirm Password", comment: "confirmPasswordValidationLabel")
        btnContinue.setTitle(NSLocalizedString("Continue", comment: "continueButton"), for: .normal)
        requirementTitleLabel.text = NSLocalizedString("Please complete all the requirements.", comment: "requirementTitleLabel")
        requirementLabel1.text = NSLocalizedString("Minimum 8 characters", comment: "requirementLabel1")
        requirementLabel2.text = NSLocalizedString("Lowercase Letter", comment: "requirementLabel2")
        requirementLabel3.text = NSLocalizedString("Capital Letter", comment: "requirementLabel3")
        requirementLabel4.text = NSLocalizedString("Number", comment: "requirementLabel4")
        requirementLabel5.text = NSLocalizedString("Special Character", comment: "requirementLabel5")
        
        txtPassword.delegate = self
        txtConfrimPassword.delegate = self
    }

    
    @IBAction func continueClicked(sender:UIButton){
        checkTextValidation()
        if checkValidation(){
            
            saveEmployee.emp_password = txtPassword.text!
            saveEmployee.emp_work_email = txtEmail.text!
           
            
            let vc = EmployeeOnboardingVCStep3.instantiate()
            vc.performanceTracker = self.performanceTracker
            vc.saveEmployee = saveEmployee
            self.pushVC(controller:vc)
        }
    }
    func checkTextValidation(){
        if txtEmail.text!.count < 1{
            self.emailTextValidationView.isHidden = false
        }else{
            self.emailTextValidationView.isHidden = true
        }
        if txtPassword.text!.count < 1{
            self.passwordTextValidationView.isHidden = false
        }else{
            self.passwordTextValidationView.isHidden = true
        }
        if txtConfrimPassword.text!.count < 1{
            self.confirmPasswordTextValidationView.isHidden = false
        }else{
            self.confirmPasswordTextValidationView.isHidden = true
        }
       
       
    }
    func checkValidation()->Bool{
        if txtEmail.text!.count > 1{
            if txtEmail.text!.isEmail == false{
                self.showAlert(alertType:.validation, message: NSLocalizedString("Invalid E-Mail. Please Try Again.", comment: "alertLabel"))
                return false
            }
        }
        if txtPassword.text!.count < 1{
            return false
        }
        if txtConfrimPassword.text!.count < 1{
            return false
        }
        
        if txtPassword.text! != txtConfrimPassword.text!{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Passwords do not match.", comment: "alertLabel"))
            return false
        }
        return true
    }

}
extension EmployeeOnboardingVCStep2:UITextFieldDelegate{
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
