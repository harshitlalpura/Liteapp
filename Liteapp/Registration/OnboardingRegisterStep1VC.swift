//
//  OnboardingRegisterStep1VC.swift
//  Liteapp
//
//  Created by Navroz Huda on 08/06/22.
//

import UIKit

class OnboardingRegisterStep1VC: BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueClicked(sender:UIButton){
        
        if checkValidation(){
            var saveMerchent = SaveMerchant()
            saveMerchent.emp_firstname = txtName.text!
            saveMerchent.emp_username = txtUsername.text!
            saveMerchent.emp_password = txtPassword.text!
            print(saveMerchent)
            let vc = OnboardingRegisterStep2VC.instantiate()
            vc.saveMerchent = saveMerchent
            self.pushVC(controller:vc)
        }
      
    }
    func checkValidation()->Bool{
        if txtName.text!.count < 3{
            AlertMesage.show(.error, message: "Please Eneter Name")
            return false
        }
        if txtUsername.text!.count < 3{
            AlertMesage.show(.error, message: "Please Eneter Valid Username")
            return false
        }
        if txtPassword.text! != txtConfirmPassword.text!{
            AlertMesage.show(.error, message: "Confirm Password Mismatch")
            return false
        }
        return true
    }
}
