//
//  OnboardingRegisterStep2VC.swift
//  Liteapp
//
//  Created by Navroz Huda on 08/06/22.
//

import UIKit
import IQKeyboardManagerSwift
class OnboardingRegisterStep2VC:BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    var saveMerchent:SaveMerchant!
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtTimezone: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
    }
    func checkValidation()->Bool{
        if txtBusinessName.text!.count < 3{
            AlertMesage.show(.error, message: "Please Eneter Business Name")
            return false
        }
        if txtEmail.text!.isEmail == false{
            AlertMesage.show(.error, message: "Please Eneter Valid Email")
            return false
        }
        if txtZipcode.text!.count < 3{
            AlertMesage.show(.error, message: "Please Eneter Valid Zipcode")
            return false
        }
        if txtTimezone.text! == ""{
            AlertMesage.show(.error, message: "Please select Timezone")
            return false
        }
        return true
    }
    @IBAction func continueClicked(sender:UIButton){
        
        if checkValidation(){
            saveMerchent.merchant_name = txtBusinessName.text!
            saveMerchent.emp_work_email = txtEmail.text!
            saveMerchent.merchant_zip = txtZipcode.text!
            let timezone = txtTimezone.text!.components(separatedBy:" ")[0]
            saveMerchent.merchant_timezone = "US/\(timezone)"
            let vc = OnboardingRegisterStep3VC.instantiate()
            vc.saveMerchent = saveMerchent
            self.pushVC(controller:vc)
        }
      
    }
   
    @IBAction func selectTimezoneClick(sender:UIButton){
        
        let pickerArray = ["Atlantic Standard Time(AST)","Eastern Standard Time(AST)","Central Standard Time(AST)","Mountain Standard Time(AST)","Pacific Standard Time(AST)"]
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


