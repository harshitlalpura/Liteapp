//
//  OnboardingRegisterStep2VC.swift
//  Liteapp
//
//  Created by Navroz Huda on 08/06/22.
//

import UIKit
import IQKeyboardManagerSwift
class OnboardingRegisterStep2VC:BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    var saveMerchent:SaveMerchant!
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtTimezone: UITextField!
    
    @IBOutlet weak var businessnameTextValidationView: UIView!
    @IBOutlet weak var zipcodeTextValidationView: UIView!
    @IBOutlet weak var timezoneextValidationView: UIView!
    @IBOutlet weak var vwGradiantContainer: UIView!
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var businessTitleLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessNameValidationLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var zipCodeValidationLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var timeZoneValidationLabel: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()
        
        stepLabel.text = NSLocalizedString("Step 2 of 5", comment: "stepLabel")
        businessTitleLabel.text = NSLocalizedString("Where is your business located ?", comment: "businessTitleLabel")
        businessNameLabel.text = NSLocalizedString("Business Name", comment: "businessNameLabel")
        txtBusinessName.placeholder = NSLocalizedString("Enter Business Name", comment: "txtBusinessName")
        businessNameValidationLabel.text = NSLocalizedString("Please Enter Business Name", comment: "businessNameValidationLabel")
        zipCodeLabel.text = NSLocalizedString("Zipcode", comment: "zipCodeLabel")
        txtZipcode.placeholder = NSLocalizedString("e.g. 11332", comment: "txtZipcode")
        zipCodeValidationLabel.text = NSLocalizedString("Please Enter Zipcode", comment: "zipCodeValidationLabel")
        timeZoneLabel.text = NSLocalizedString("Timezone", comment: "timeZoneLabel")
        txtTimezone.placeholder = NSLocalizedString("Select Timezone", comment: "txtTimezone")
        timeZoneValidationLabel.text = NSLocalizedString("Please Enter Timezone", comment: "timeZoneValidationLabel")
        btnContinue.setTitle(NSLocalizedString("Continue", comment: "btnContinue"), for: .normal)
       
    }
    func checkTextValidation(){
        if txtBusinessName.text!.count < 1{
            self.businessnameTextValidationView.isHidden = false
        }else{
            self.businessnameTextValidationView.isHidden = true
        }
        if txtZipcode.text!.count < 1{
            self.zipcodeTextValidationView.isHidden = false
        }else{
            self.zipcodeTextValidationView.isHidden = true
        }
        if txtTimezone.text!.count < 1{
            self.timezoneextValidationView.isHidden = false
        }else{
            self.timezoneextValidationView.isHidden = true
        }
       
    }
    func checkValidation()->Bool{
        checkTextValidation()
        if txtBusinessName.text!.count < 1{
          
          //  self.showAlert(alertType:.validation, message: "Please Eneter Business Name")
            return false
        }
        if let bname = txtBusinessName.text, bname.count > 0{
            if bname.hasNumbers{
                self.showAlert(alertType:.validation, message: "Business name can only contain alphabets.")
                return false
            }
        }
        
        if txtZipcode.text!.count < 1{
            
           // self.showAlert(alertType:.validation, message: "Please Eneter Valid Zipcode")
            return false
        }
        if txtZipcode.text!.count < 5{
            self.showAlert(alertType:.validation, message: "Zipcode must be of minimum 5 characters.")
            return false
        }
        
        if txtTimezone.text! == ""{
           
           // self.showAlert(alertType:.validation, message: "Please select Timezone")
            return false
        }
        return true
    }
    @IBAction func continueClicked(sender:UIButton){
        
        if checkValidation(){
            saveMerchent.merchant_name = txtBusinessName.text!
            saveMerchent.merchant_zip = txtZipcode.text!
            let timezone = txtTimezone.text!.components(separatedBy:" ")[0]
//            if timezone == "Test"{
//                saveMerchent.merchant_timezone = "Asia/Kolkata"
//            }
//            else{
                saveMerchent.merchant_timezone = "US/\(timezone)"
//            }
            let vc = OnboardingRegisterStep3VC.instantiate()
            vc.saveMerchent = saveMerchent
            self.pushVC(controller:vc)
        }
      
    }
   
    @IBAction func selectTimezoneClick(sender:UIButton){
        
//        let pickerArray = ["Atlantic Standard Time(AST)","Eastern Standard Time(EST)","Central Standard Time(CST)","Mountain Standard Time(MST)","Pacific Standard Time(PST)"]
        let pickerArray = ["Eastern Standard Time(EST)","Central Standard Time(CST)","Mountain Standard Time(MST)","Pacific Standard Time(PST)"]
        IQKeyboardManager.shared.enable = false
        PickerView.sharedInstance.addPicker(self, onTextField: txtTimezone, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                IQKeyboardManager.shared.enable = true
                 self.txtTimezone.text = value
                 print(value)
             }
            self.txtTimezone.resignFirstResponder()
        }
        
    }
}


extension OnboardingRegisterStep2VC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtZipcode{
            let maxLength = 5
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
            
            return newString.length <= maxLength
        }
        return true
    }
}
