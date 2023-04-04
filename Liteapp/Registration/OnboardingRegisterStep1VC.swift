//
//  OnboardingRegisterStep1VC.swift
//  Liteapp
//
//  Created by Navroz Huda on 08/06/22.
//

import UIKit

class OnboardingRegisterStep1VC: BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var vwGradiantContainer: UIView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var firstNameTextValidationView: UIView!
    @IBOutlet weak var lastNameTextValidationView: UIView!
    @IBOutlet weak var emailTextValidationView: UIView!
    @IBOutlet weak var usernameTextValidationView: UIView!
    @IBOutlet weak var passwordTextValidationView: UIView!
    @IBOutlet weak var confirmPasswordTextValidationView: UIView!
    
    @IBOutlet weak var passwordValidationView: UIView!
    
    @IBOutlet weak var imgvwminimumCharacter: UIImageView!
    @IBOutlet weak var imgvwLowercaseLetter: UIImageView!
    @IBOutlet weak var imgvwCapitalLetter: UIImageView!
    @IBOutlet weak var imgvwNumber: UIImageView!
    @IBOutlet weak var imgvwSpecialCharacter: UIImageView!
    
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var firstNameValidationLabel: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lastNameValidationLabel: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var emailValidationLabel: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var userNameValidationLabel: UILabel!
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
    
    var isPasswordValidTotalCount : Bool = false
    var isPasswordValidCapitalChar : Bool = false
    var isPasswordValidSmallChar : Bool = false
    var isPasswordValidSpecialChar : Bool = false
    var isPasswordValidNumberChar : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblStep.text = NSLocalizedString("Step 1 of 5", comment: "stepLabel")
        lblTitle.text = NSLocalizedString("Let’s get your manager  account setup. Don’t worry, this will take less than 2 minutes.", comment: "titleLabel")
        lblFirstName.text = NSLocalizedString("First Name", comment: "firstNameLabel")
        txtFirstName.placeholder = NSLocalizedString("e.g. John", comment: "firstNamePlaceholder")
        firstNameValidationLabel.text = NSLocalizedString("Please Enter First Name", comment: "firstNameValidationLabel")
        lblLastName.text = NSLocalizedString("Last Name", comment: "lastNameLabel")
        txtLastName.placeholder = NSLocalizedString("e.g. Doe", comment: "lastNamePlaceholder")
        lastNameValidationLabel.text = NSLocalizedString("Please Enter Last Name", comment: "lastNameValidationLabel")
        lblEmail.text = NSLocalizedString("Email", comment: "emailLabel")
        txtEmail.placeholder = NSLocalizedString("e.g. myemail@email.com", comment: "emailPlaceholder")
        emailValidationLabel.text = NSLocalizedString("Please Enter Email", comment: "emailValidationLabel")
        lblUserName.text = NSLocalizedString("Username", comment: "userNameLabel")
        txtUsername.placeholder = NSLocalizedString("Enter Username", comment: "userNamePlaceholder")
        userNameValidationLabel.text = NSLocalizedString("Please Enter Username", comment: "userNameValidationLabel")
        lblPassword.text = NSLocalizedString("Password", comment: "passwordLabel")
        txtPassword.placeholder = NSLocalizedString("Enter Password", comment: "passwordPlaceholder")
        passwordValidationLabel.text = NSLocalizedString("Please Enter Password", comment: "passwordValidationLabel")
        lblConfirmPassword.text = NSLocalizedString("Confirm Password", comment: "confirmPasswordLabel")
        txtConfirmPassword.placeholder = NSLocalizedString("Confirm Password", comment: "confirmPasswordPlaceholder")
        confirmPasswordValidationLabel.text = NSLocalizedString("Please Confirm Password", comment: "confirmPasswordValidationLabel")
        btnContinue.setTitle(NSLocalizedString("Continue", comment: "continueButton"), for: .normal)
        requirementTitleLabel.text = NSLocalizedString("Please complete all the requirements.", comment: "requirementTitleLabel")
        requirementLabel1.text = NSLocalizedString("Minimum 8 characters", comment: "requirementLabel1")
        requirementLabel2.text = NSLocalizedString("Lowercase Letter", comment: "requirementLabel2")
        requirementLabel3.text = NSLocalizedString("Capital Letter", comment: "requirementLabel3")
        requirementLabel4.text = NSLocalizedString("Number", comment: "requirementLabel4")
        requirementLabel5.text = NSLocalizedString("Special Character", comment: "requirementLabel5")
        
        vwGradiantContainer.setGradientBackground()
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
    
    @IBAction func continueClicked(sender:UIButton){
        
        if checkValidation(){
            checkEmailAndUsernameAvailability()
        }
      
    }
    func checkTextValidation(){
        if txtFirstName.text!.count < 1{
            self.firstNameTextValidationView.isHidden = false
        }else{
            self.firstNameTextValidationView.isHidden = true
        }
        if txtLastName.text!.count < 1{
            self.lastNameTextValidationView.isHidden = false
        }else{
            self.lastNameTextValidationView.isHidden = true
        }
        if txtEmail.text!.count < 1{
            self.emailTextValidationView.isHidden = false
        }else{
            self.emailTextValidationView.isHidden = true
        }
        if txtUsername.text!.count < 1{
            self.usernameTextValidationView.isHidden = false
        }else{
            self.usernameTextValidationView.isHidden = true
        }
        if txtPassword.text!.count < 1{
            self.passwordTextValidationView.isHidden = false
        }else{
            self.passwordTextValidationView.isHidden = true
        }
        if txtConfirmPassword.text!.count < 1{
            self.confirmPasswordTextValidationView.isHidden = false
        }else{
            self.confirmPasswordTextValidationView.isHidden = true
        }
       
    }
    func checkValidation()->Bool{
        checkTextValidation()
        if txtFirstName.text!.count < 1{
          //  self.showAlert(alertType:.validation, message: "Please Eneter Name")
            return false
        }
        if let fname = txtFirstName.text, fname.count > 0{
            if fname.hasNumbers{
                self.showAlert(alertType:.validation, message: "Name can only contain alphabets.")
                return false
            }
        }
        if txtLastName.text!.count < 1{
          //  self.showAlert(alertType:.validation, message: "Please Eneter Name")
            return false
        }
        if let lname = txtLastName.text, lname.count > 0{
            if lname.hasNumbers{
                self.showAlert(alertType:.validation, message: "Name can only contain alphabets.")
                return false
            }
        }
        if txtEmail.text!.count < 1{
          //  self.showAlert(alertType:.validation, message: "Please Eneter Name")
            return false
        }
        if txtEmail.text!.count > 0{
            if txtEmail.text!.isEmail == false{
                self.showAlert(alertType:.validation, message: "Invalid Email. Please Try Again.")
                return false
            }
        }
        if txtUsername.text!.count < 1{
          //  self.showAlert(alertType:.validation, message: "Please Eneter Valid Username")
            return false
        }
        if txtUsername.text!.count < 5{
            self.showAlert(alertType:.validation, message: "Username Must Be At Least 5 Characters.")
            return false
        }
        if txtPassword.text! != txtConfirmPassword.text!{
            self.showAlert(alertType:.validation, message: "Passwords do not match.")
            return false
        }
        if isPasswordValidTotalCount == false || isPasswordValidCapitalChar == false || isPasswordValidSmallChar == false || isPasswordValidSpecialChar == false || isPasswordValidNumberChar == false{
            self.showAlert(alertType:.validation, message: "Please enter password which follows all required criteria.")
            return false
        }
        return true
    }
    
    func checkEmailAndUsernameAvailability(){
        let parameter = ["emp_work_email":txtEmail.text!]
            NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints:APIEndPoints.checkEmail(), param: parameter) { success, response, error in
                if let res = response{
                    print(res)
                    if let status = res["status"] as? Int , status == 0{
                    //Same Email exists, could not proceed
                        self.showAlert(alertType:.validation, message: "This email already exists. Please try another email or try to login")
                    }
                    else{
                        //No Such emiail exists, checking for username
                        let parameterUserName = ["emp_username":self.txtUsername.text!]
                        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints:APIEndPoints.checkUsername(), param: parameterUserName) { success, response, error in
                            if let res = response{
                                print(res)
                                if let status = res["status"] as? Int , status == 0{
                                //Same Username exists, could not proceed
                                    self.showAlert(alertType:.validation, message: "This username already exists. Please try another username")
                                }
                                else{
                                    //Proceed Ahead
                                    var saveMerchent = SaveMerchant()
                                    saveMerchent.emp_firstname = self.txtFirstName.text!
                                    saveMerchent.emp_lastname = self.txtLastName.text!
                                    saveMerchent.emp_work_email = self.txtEmail.text!
                                    saveMerchent.emp_username = self.txtUsername.text!
                                    saveMerchent.emp_password = self.txtPassword.text!
                                    print(saveMerchent)
                                    let vc = OnboardingRegisterStep2VC.instantiate()
                                    vc.saveMerchent = saveMerchent
                                    self.pushVC(controller:vc)
                                }
                            }
                            else if let err = error{
                                print(err)
                            }
                        }
                    }
                    
                }else if let err = error{
                    print(err)
                }
            }
        
    }
}
extension OnboardingRegisterStep1VC:UITextFieldDelegate{
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
                isPasswordValidTotalCount = true
            }else{
                imgvwminimumCharacter.image = UIImage.unselectedImage
                isPasswordValidTotalCount = false
            }
           let capitalLetterRegEx  = ".*[A-Z]+.*"
           let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
            if texttest.evaluate(with: str){
                imgvwCapitalLetter.image = UIImage.selectedImage
                isPasswordValidCapitalChar = true
            }else{
                imgvwCapitalLetter.image = UIImage.unselectedImage
                isPasswordValidCapitalChar = false
            }
          
            let lowercaseLetterRegEx  = ".*[a-z]+.*"
            let texttest3 = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegEx)
             if texttest3.evaluate(with: str){
                 imgvwLowercaseLetter.image = UIImage.selectedImage
                 isPasswordValidSmallChar = true
             }else{
                 imgvwLowercaseLetter.image = UIImage.unselectedImage
                 isPasswordValidSmallChar = false
             }

           let numberRegEx  = ".*[0-9]+.*"
           let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            if texttest1.evaluate(with: str){
                imgvwNumber.image = UIImage.selectedImage
                isPasswordValidNumberChar = true
            }else{
                imgvwNumber.image = UIImage.unselectedImage
                isPasswordValidNumberChar = false
            }

           let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
           let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            if texttest2.evaluate(with: str){
                imgvwSpecialCharacter.image = UIImage.selectedImage
                isPasswordValidSpecialChar = true
            }else{
                imgvwSpecialCharacter.image = UIImage.unselectedImage
                isPasswordValidSpecialChar = false
            }
        
    }
}
