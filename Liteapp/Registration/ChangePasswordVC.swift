//
//  ChangePasswordVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 27/06/22.
//

import UIKit

class ChangePasswordVC: BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    @IBOutlet weak var txtOldPassword:UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var passwordValidationView: UIView!
    
    @IBOutlet weak var imgvwminimumCharacter: UIImageView!
    @IBOutlet weak var imgvwLowercaseLetter: UIImageView!
    @IBOutlet weak var imgvwCapitalLetter: UIImageView!
    @IBOutlet weak var imgvwNumber: UIImageView!
    @IBOutlet weak var imgvwSpecialCharacter: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOldPassword.delegate = self
        txtNewPassword.delegate = self
        txtConfirmPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveClicked(){
        if checkValidation(){
            self.changePasswordAPI()
        }
    }
    @IBAction func closeClicked(){
        self.dismiss(animated:true)
    }
    private func checkValidation()->Bool{
        if txtOldPassword.text?.count ?? 0 < 8{
            self.showAlert(alertType:.validation, message: "Password must be atleast 8 characters")
            
            return false
        }
        if txtNewPassword.text?.count ?? 0 < 8{
            self.showAlert(alertType:.validation, message: "Password must be atleast 8 characters")
           
            return false
        }
        if txtConfirmPassword.text?.count ?? 0 < 8{
            self.showAlert(alertType:.validation, message: "Password must be atleast 8 characters")
            
            return false
        }

        if (txtOldPassword.text?.isValidPassword ?? false == false){
            self.showAlert(alertType:.validation, message: "Please Enter Valid Password")
           
            
            return false
        }
        if (txtNewPassword.text?.isValidPassword ?? false == false){
            self.showAlert(alertType:.validation, message:"Please Enter Valid Password")
            
            return false
        }
        if (txtConfirmPassword.text?.isValidPassword ?? false == false){
            self.showAlert(alertType:.validation, message:"Please Enter Valid Password")
            
            return false
        }
        if txtConfirmPassword.text != txtNewPassword.text{
            self.showAlert(alertType:.validation, message: "Confirm Password must be same as New Password.")
            
            return false
        }
        return true
    }
    func changePasswordAPI(){
        
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0,
            "current_password":self.txtOldPassword.text!,
            "new_password":self.txtNewPassword.text!
        ] as [String : Any]
        print(parameters)
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.changePassword(), param: parameters, header: Defaults.shared.header ?? ["":""]){ success, response, error in
            if let res = response{
                print(res)
                if let status = res["status"] as? Int{
                    if status == 0{
                        if let messagae  = res["message"] as? String{
                            self.showAlert(alertType:.validation, message: messagae)
                            
                        }
                    }else{
                        if let messagae  = res["message"] as? String{
                            AlertMesage.show(.success, message: messagae)
                            self.dismiss(animated:true)
                        }
                    }
                }
                
            }else if let err = error{
                print(err)
            }
        }
      
    }
   
}

extension ChangePasswordVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtNewPassword{
            self.updatePasswordValidation(str:textField.text!)
            self.passwordValidationView.isHidden = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtNewPassword{
            self.updatePasswordValidation(str:textField.text!)
            self.passwordValidationView.isHidden = true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtNewPassword{
            
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
