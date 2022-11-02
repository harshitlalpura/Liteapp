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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()
       
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
            if timezone == "Test"{
                saveMerchent.merchant_timezone = "Asia/Kolkata"
            }
            else{
                saveMerchent.merchant_timezone = "US/\(timezone)"
            }
            let vc = OnboardingRegisterStep3VC.instantiate()
            vc.saveMerchent = saveMerchent
            self.pushVC(controller:vc)
        }
      
    }
   
    @IBAction func selectTimezoneClick(sender:UIButton){
        
//        let pickerArray = ["Atlantic Standard Time(AST)","Eastern Standard Time(EST)","Central Standard Time(CST)","Mountain Standard Time(MST)","Pacific Standard Time(PST)"]
        let pickerArray = ["Eastern Standard Time(EST)","Central Standard Time(CST)","Mountain Standard Time(MST)","Pacific Standard Time(PST)","Test Timezone(Don't Choose)"]
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


