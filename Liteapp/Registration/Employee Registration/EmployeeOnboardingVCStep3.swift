//
//  EmployeeOnboardingVCStep3.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import UIKit
import Alamofire
import ObjectMapper

class EmployeeOnboardingVCStep3:BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var txtReferralCode: UITextField!
    @IBOutlet weak var txtCompany: UITextField!
    @IBOutlet weak var referralCodeTextValidationView: UIView!
    var saveEmployee:SaveEmployee!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        if txtReferralCode.text!.count < 1{
            self.referralCodeTextValidationView.isHidden = false
        }else{
            self.referralCodeTextValidationView.isHidden = true
        }
       
    }
    func checkValidation()->Bool{
       
        return true
    }
    func saveEmployeeapiCall(){
        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints:APIEndPoints.saveEmployees(), param: self.saveEmployee.getParam()) { success, response, error in
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
                        self.showAlert(alertType:.validation, message: "No such merchant available.Please try again.")
                        self.txtCompany.text = ""
                        
                    }else if status == 1{
                        let data = Mapper<MerchantCodeData>().map(JSONObject:res)
                        print(data?.toJSON() ?? "")
                        self.txtCompany.text = data?.data?.first?.merchantName ?? ""
                        self.saveEmployee.merchant_id = "\(data?.data?.first?.merchantId ?? 0)"
                        print(self.saveEmployee.getParam())
                    }
                }else{
                    self.showAlert(alertType:.validation, message: "No such merchant available.Please try again.")
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
