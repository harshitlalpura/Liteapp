//
//  EmployeeOnboardingVCStep1.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import UIKit

class EmployeeOnboardingVCStep1:BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtJobTitle: UITextField!
   
    @IBOutlet weak var firstnameTextValidationView: UIView!
    @IBOutlet weak var lastnameTextValidationView: UIView!
    @IBOutlet weak var jobtitleTextValidationView: UIView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func continueClicked(sender:UIButton){
        checkTextValidation()
        if checkValidation(){
            var saveEmployee = SaveEmployee()
            saveEmployee.emp_firstname = txtFirstName.text!
            saveEmployee.emp_lastname = txtLastName.text!
            saveEmployee.emp_job_title = txtJobTitle.text!
            
            let vc = EmployeeOnboardingVCStep2.instantiate()
            vc.saveEmployee = saveEmployee
            self.pushVC(controller:vc)
        }
    }
    func checkTextValidation(){
        if txtFirstName.text!.count < 1{
            self.firstnameTextValidationView.isHidden = false
        }else{
            self.firstnameTextValidationView.isHidden = true
        }
        if txtLastName.text!.count < 1{
            self.lastnameTextValidationView.isHidden = false
        }else{
            self.lastnameTextValidationView.isHidden = true
        }
        if txtJobTitle.text!.count < 1{
            self.jobtitleTextValidationView.isHidden = false
        }else{
            self.jobtitleTextValidationView.isHidden = true
        }
       
       
    }
    func checkValidation()->Bool{
        if txtFirstName.text!.count < 1{
          //  self.showAlert(alertType:.validation, message: "Please Enter Valid First Name")
            return false
        }
        if txtLastName.text!.count < 1{
           
           // self.showAlert(alertType:.validation, message: "Please Enter Valid Last Name")
            return false
        }
        if txtJobTitle.text!.count < 1{
          //  self.showAlert(alertType:.validation, message: "Please Enter Job Title")
            return false
        }
        return true
    }
}
