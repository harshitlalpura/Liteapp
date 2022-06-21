//
//  LoginViewController.swift
//  Liteapp
//
//  Created by Navroz Huda on 07/06/22.
//

import UIKit
import SideMenu
import ObjectMapper

class LoginViewController: BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
           // txtEmail.text = "hudanavroz@gmail.com"
          //  txtEmail.text = "navrozhuda29@gmail.com"
            //txtPassword.text = "Nvrz@336179"
            txtEmail.text = "davemannn"
            txtPassword.text = "Mascot@2205"
    }

    @objc func messageTapped(sender:UIButton){
        
    }
    @IBAction func loginClicked(sender:UIButton){
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
                    AlertMesage.show(.error, message: user?.message ?? "")
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
        if txtEmail.text!.count < 3{
            AlertMesage.show(.error, message: "Please enter valid username")
            return false
        }
        if txtPassword.text!.count < 3{
            AlertMesage.show(.error, message: "Please enter valid password.")
            return false
        }
        
        return true
    }
}

