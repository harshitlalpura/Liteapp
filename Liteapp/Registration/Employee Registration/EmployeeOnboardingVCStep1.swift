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
//    @IBOutlet weak var txtJobTitle: UITextField!
   
    @IBOutlet weak var firstnameTextValidationView: UIView!
    @IBOutlet weak var lastnameTextValidationView: UIView!
//    @IBOutlet weak var jobtitleTextValidationView: UIView!
    @IBOutlet weak var vwGradiantContainer: UIView!
    
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var firstNameValidationLabel: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lastNameValidationLabel: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()
        // Do any additional setup after loading the view.
        lblStep.text = NSLocalizedString("Step 1 of 3", comment: "stepLabel")
        lblTitle.text = NSLocalizedString("Let’s get your employee account set up. Don’t worry, this should only take about 2 minutes.", comment: "titleLabel")
        lblFirstName.text = NSLocalizedString("First Name", comment: "firstNameLabel")
        txtFirstName.placeholder = NSLocalizedString("e.g. John", comment: "firstNamePlaceholder")
        firstNameValidationLabel.text = NSLocalizedString("Please Enter First Name", comment: "firstNameValidationLabel")
        lblLastName.text = NSLocalizedString("Last Name", comment: "lastNameLabel")
        txtLastName.placeholder = NSLocalizedString("e.g. Doe", comment: "lastNamePlaceholder")
        lastNameValidationLabel.text = NSLocalizedString("Please Enter Last Name", comment: "lastNameValidationLabel")
        btnContinue.setTitle(NSLocalizedString("Continue", comment: "continueButton"), for: .normal)
    }
    @IBAction func continueClicked(sender:UIButton){
        checkTextValidation()
        if checkValidation(){
            var saveEmployee = SaveEmployee()
            saveEmployee.emp_firstname = txtFirstName.text!
            saveEmployee.emp_lastname = txtLastName.text!
//            saveEmployee.emp_job_title = txtJobTitle.text!
            
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
//        if txtJobTitle.text!.count < 1{
//            self.jobtitleTextValidationView.isHidden = false
//        }else{
//            self.jobtitleTextValidationView.isHidden = true
//        }
       
       
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
        if (txtFirstName.text?.hasNumbers == true){
            self.showAlert(alertType:.validation, message: "Name can only contain alphabets")
            return false
        }
        if (txtLastName.text?.hasNumbers == true){
            self.showAlert(alertType:.validation, message: "Name can only contain alphabets")
            return false
        }
        
//        if txtJobTitle.text!.count < 1{
//          //  self.showAlert(alertType:.validation, message: "Please Enter Job Title")
//            return false
//        }
        return true
    }
}
