//
//  EmployeeOnboardingVCStep3.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import UIKit
import Alamofire
import ObjectMapper
import FirebasePerformance

class EmployeeOnboardingVCStep3:BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var txtReferralCode: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var referralCodeTextValidationView: UIView!
    @IBOutlet weak var vwGradiantContainer: UIView!
    
    @IBOutlet weak var lblStep: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReferalCode: UILabel!
    @IBOutlet weak var referalCodeValidationLabel: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var noReferalLabel: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    var performanceTracker = PerformanceTracker()
    
    var saveEmployee:SaveEmployee!
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()
        
        lblStep.text = NSLocalizedString("Step 3 of 3", comment: "stepLabel")
        lblTitle.text = NSLocalizedString("Please enter your Referral Code below.", comment: "titleLabel")
        lblReferalCode.text = NSLocalizedString("Referral Code", comment: "emailLabel")
        txtReferralCode.placeholder = NSLocalizedString("eg. A001", comment: "emailPlaceholder")
        referalCodeValidationLabel.text = NSLocalizedString("Please enter referral code", comment: "emailValidationLabel")
        lblCompany.text = NSLocalizedString("Company", comment: "passwordLabel")
        txtCompany.placeholder = NSLocalizedString("--------", comment: "passwordPlaceholder")
        noReferalLabel.text = NSLocalizedString("Don’t have a referral code? That’s ok! The person who set up your company’s account can provide this to you.", comment: "confirmPasswordValidationLabel")
        btnContinue.setTitle(NSLocalizedString("Continue", comment: "continueButton"), for: .normal)
        
        
        txtReferralCode.delegate = self
        txtCompany.isUserInteractionEnabled = false
        if let code =  Defaults.shared.referralCode{
            txtReferralCode.text = code
            self.checkRefferalCode(code)
        }
    }
    
    @IBAction func continueClicked(sender:UIButton){
        checkTextValidation()
        if checkValidation(){
            
            self.saveEmployeeapiCall()
        }
    }
    func checkTextValidation(){
//        if txtReferralCode.text!.count < 1{
//            self.referralCodeTextValidationView.isHidden = false
//        }else{
//            self.referralCodeTextValidationView.isHidden = true
//        }
       
    }
    func checkValidation()->Bool{
        if txtReferralCode.text!.count < 1{
            self.showAlert(alertType:.validation, message: "Please Enter Referral Code.")
            return false
        }
        if txtReferralCode.text!.count < 4{
            self.showAlert(alertType:.validation, message: "Please Enter Valid Referral Code.")
            return false
        }
        return true
    }
    func saveEmployeeapiCall(){
        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints:APIEndPoints.saveEmployees(), param: self.saveEmployee.getParam()) { success, response, error in
            self.performanceTracker.stopTrackPerformance(traceName: "employee_registration")
            if let res = response{
                print(res)
                let user = Mapper<EmployeeData>().map(JSONObject:res)
                Defaults.shared.currentUser = user?.empData?.first
                print(Defaults.shared.currentUser?.merchantName ?? "")
                if let empType = Defaults.shared.currentUser?.empType{
                    if empType == "E"{
                        let vc = DashBoardVC.instantiate()
                        self.pushVC(controller:vc)
                    }else if empType == "S"{
                        
                    }
                }
            }else if let err = error{
                print(err)
            }
        }
    }
    
    func checkRefferalCode(_ code:String){
        let header = Defaults.shared.header ?? ["":""]
        let parameter = ["merchant_reference_number":"\(code)"]
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.searchMerchantsByRef(), param: parameter, header: header) { success, response, error in
            if let res = response{
                if let status = res["status"] as? Int{
                    if status == 0{
                        self.showAlert(alertType:.validation, message: NSLocalizedString("No such merchant available.Please try again.", comment: "alertLabel"))
                        self.txtCompany.text = ""
                        
                    }else if status == 1{
                        let data = Mapper<MerchantCodeData>().map(JSONObject:res)
                        print(data?.toJSON() ?? "")
                        self.txtCompany.text = data?.data?.first?.merchantName ?? ""
                        self.saveEmployee.merchant_id = "\(data?.data?.first?.merchantId ?? 0)"
                        print(self.saveEmployee.getParam())
                    }
                }else{
                    self.showAlert(alertType:.validation, message: NSLocalizedString("No such merchant available.Please try again.", comment: "alertLabel"))
                    self.txtCompany.text = ""
                    
                }
                
            }else if let err = error{
                print(err)
            }
            
        }
    }
    
    
}
extension EmployeeOnboardingVCStep3:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtReferralCode{
            if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                      
                        return true
                    }
            }
            if string.count > 3{
                //User did copy & paste
                self.checkRefferalCode(string)
            }
            if textField.text!.count == 4{
                return false
            }else if textField.text!.count == 3{
                let code = self.txtReferralCode.text! + string
                self.checkRefferalCode(code)
            }
            return true
        }
        return true
    }
}
