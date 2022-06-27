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
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            AlertMesage.show(.error, message: "Password must be atleast 8 characters")
            return false
        }
        if txtNewPassword.text?.count ?? 0 < 8{
            AlertMesage.show(.error, message: "Password must be atleast 8 characters")
            return false
        }
        if txtConfirmPassword.text?.count ?? 0 < 8{
            AlertMesage.show(.error, message: "Password must be atleast 8 characters")
            return false
        }

        if (txtOldPassword.text?.isValidPassword ?? false == false){
            AlertMesage.show(.error, message: "Please Enter Valid Password")
            
            return false
        }
        if (txtNewPassword.text?.isValidPassword ?? false == false){
            AlertMesage.show(.error, message: "Please Enter Valid Password")
            return false
        }
        if (txtConfirmPassword.text?.isValidPassword ?? false == false){
            AlertMesage.show(.error, message: "Please Enter Valid Password")
            return false
        }
        if txtConfirmPassword.text != txtNewPassword.text{
            AlertMesage.show(.error, message: "Confirm Password must be same as New Password.")
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
                            AlertMesage.show(.error, message: messagae)
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


