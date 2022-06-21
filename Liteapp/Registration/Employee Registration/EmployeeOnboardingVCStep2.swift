//
//  EmployeeOnboardingVCStep2.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import UIKit

class EmployeeOnboardingVCStep2:BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfrimPassword: UITextField!
    
    var saveEmployee:SaveEmployee!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueClicked(sender:UIButton){
        if checkValidation(){
            
            saveEmployee.emp_password = txtPassword.text!
            saveEmployee.emp_work_email = txtEmail.text!
           
            
            let vc = EmployeeOnboardingVCStep3.instantiate()
            vc.saveEmployee = saveEmployee
            self.pushVC(controller:vc)
        }
    }
    func checkValidation()->Bool{
       
        if txtEmail.text!.isEmail == false{
            AlertMesage.show(.error, message: "Please Eneter Valid Email")
            return false
        }
        if txtPassword.text! != txtConfrimPassword.text!{
            AlertMesage.show(.error, message: "Confirm Password Mismatch")
            return false
        }
        return true
    }

}
