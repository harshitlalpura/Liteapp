//
//  LoginViewController.swift
//  Liteapp
//
//  Created by Navroz Huda on 07/06/22.
//

import UIKit
import SideMenu
import ObjectMapper

extension UIImage{
    static let selectedImage = UIImage(named:"ic_selected")
    static let unselectedImage = UIImage(named:"ic_unselected")
}
class LoginViewController: BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var passwordValidationView: UIView!
    
    @IBOutlet weak var imgvwminimumCharacter: UIImageView!
    @IBOutlet weak var imgvwLowercaseLetter: UIImageView!
    @IBOutlet weak var imgvwCapitalLetter: UIImageView!
    @IBOutlet weak var imgvwNumber: UIImageView!
    @IBOutlet weak var imgvwSpecialCharacter: UIImageView!
    
    @IBOutlet weak var emailTextValidationView: UIView!
    @IBOutlet weak var passwordTextValidationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
       // txtEmail.text = "davemannn"
       // txtPassword.text = "Mascot@2205"
        txtPassword.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
//        if let code = Defaults.shared.referralCode{
//            self.showToast(message:"\(code)", font: UIFont.RobotoRegular(size:20.0))
//        }
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
       
    }
    @objc func messageTapped(sender:UIButton){
        
    }
    @IBAction func loginClicked(sender:UIButton){
        checkTextValidation()
        if checkValidation(){
            self.loginAPI()
        }
    }
    @IBAction func registerClicked(sender:UIButton){
        let vc = OnboardingRegisterVC.instantiate()
        self.pushVC(controller:vc)
    }
    func loginAPI(){
        let parameter = ["emp_username":txtEmail.text!,"emp_work_email":txtEmail.text!,"emp_password":txtPassword.text!]
        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints: APIEndPoints.login(), param: parameter) { success, response, error in
            if let res = response{
                print(res)
                let user = Mapper<EmployeeData>().map(JSONObject:res)
                Defaults.shared.currentUser = user?.empData?.first
                print(Defaults.shared.currentUser?.merchantName ?? "")
                if user?.status ?? 0 == 0{
     
                    self.showAlert(alertType:.validation, message: user?.message ?? "")
                    return
                }
                if let empType = Defaults.shared.currentUser?.empType{
                    if empType == "E"{
                        let vc = DashBoardVC.instantiate()
                        self.pushVC(controller:vc)
                    }else if empType == "S"{
                        if user?.empData?.first?.merchantProfileCompleted == "Y"{
                            let vc = DashBoardVC.instantiate()
                            self.pushVC(controller:vc)
                        }else{
                            let vc = SettingsVC.instantiate()
                            vc.setupProfile = true
                            self.pushVC(controller:vc)
                        }
                    }
                }
            }else if let err = error{
                print(err)
            }
        }
    }
    func checkValidation()->Bool{
        if txtEmail.text!.count < 1{
          
           // self.showAlert(alertType:.validation, message: "Please enter valid username")
            return false
        }
        if txtPassword.text!.count > 1{
            if txtPassword.text!.isValidPassword == false{
                self.showAlert(alertType:.validation, message: "Please enter valid password")
                return false
            }
        }
        return true
    }
}
extension LoginViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
extension UIViewController{
    func showAlert(alertType:AlertType = .success,message:String = "",subTitle:String = ""){
        let vc = CustomAlertViewController.instantiate()
        vc.alertType = alertType
        if alertType == .success{
            vc.successMessage = message
        }else if alertType == .validation{
            vc.validationMessage = message
        }else if alertType == .failed{
            vc.failureMessage = message
        }
        
        self.presentVC(controller:vc)
    }
}
