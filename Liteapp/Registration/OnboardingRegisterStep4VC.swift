//
//  OnboardingRegisterStep4VC.swift
//  Liteapp
//
//  Created by Navroz Huda on 08/06/22.
//

import UIKit
import ObjectMapper
enum EmployeeRange:Int{
        case employee1to4  = 1
        case employee5to19 = 2
        case employee20to99 = 3
        case employee100to499 = 4
        case employee500Plus = 5
   
}

struct RadioButton{
    static let checked = "ic_radio_button_checked"
    static let unchecked = "ic_radio_button_unchecked"
}

class OnboardingRegisterStep4VC: BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    
    
    @IBOutlet weak var imgViewRange1to4: UIImageView!
    @IBOutlet weak var imgViewRange5to19: UIImageView!
    @IBOutlet weak var imgViewRange20to99: UIImageView!
    @IBOutlet weak var imgViewRange100to499: UIImageView!
    @IBOutlet weak var imgViewRange500Plus: UIImageView!
    
    @IBOutlet weak var btnViewRange1to4: UIButton!
    @IBOutlet weak var btnViewRange5to19: UIButton!
    @IBOutlet weak var btnViewRange20to99: UIButton!
    @IBOutlet weak var btnViewRange100to499: UIButton!
    @IBOutlet weak var btnViewRange500Plus: UIButton!
    @IBOutlet weak var vwGradiantContainer: UIView!
    var saveMerchent:SaveMerchant!
    var selectedEmployeeRange:EmployeeRange = .employee1to4
    var selectedEmployees = "1 to 4"
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()
        btnViewRange1to4.tag = 1
        btnViewRange5to19.tag = 2
        btnViewRange20to99.tag = 3
        btnViewRange100to499.tag = 4
        btnViewRange500Plus.tag = 5
    }
    

    @IBAction func employeeSelected(sender:UIButton){
        
        self.btnViewRange1to4.isSelected = false
        self.btnViewRange5to19.isSelected = false
        self.btnViewRange20to99.isSelected = false
        self.btnViewRange100to499.isSelected = false
        self.btnViewRange500Plus.isSelected = false
        
        self.imgViewRange1to4.image = UIImage(named:RadioButton.unchecked)
        self.imgViewRange5to19.image = UIImage(named:RadioButton.unchecked)
        self.imgViewRange20to99.image = UIImage(named:RadioButton.unchecked)
        self.imgViewRange100to499.image = UIImage(named:RadioButton.unchecked)
        self.imgViewRange500Plus.image = UIImage(named:RadioButton.unchecked)
        
        
        switch sender.tag {
        case 1:
            self.selectedEmployeeRange = .employee1to4
           // self.btnViewRange1to4.isSelected = true
            self.imgViewRange1to4.image = UIImage(named:RadioButton.checked)
            self.selectedEmployees = "1 - 4"
            return
        case 2:
            self.selectedEmployeeRange = .employee5to19
           // self.btnViewRange5to19.isSelected = true
            self.imgViewRange5to19.image = UIImage(named:RadioButton.checked)
            self.selectedEmployees = "5 - 19"
            return
        case 3:
            self.selectedEmployeeRange = .employee20to99
           // self.btnViewRange20to99.isSelected = true
            self.imgViewRange20to99.image = UIImage(named:RadioButton.checked)
            self.selectedEmployees = "20 - 99"
            return
        case 4:
            self.selectedEmployeeRange = .employee100to499
          //  self.btnViewRange100to499.isSelected = true
            self.imgViewRange100to499.image = UIImage(named:RadioButton.checked)
            self.selectedEmployees = "100 - 499"
            return
        case 5:
            self.selectedEmployeeRange = .employee500Plus
           // self.btnViewRange500Plus.isSelected = true
            self.imgViewRange500Plus.image = UIImage(named:RadioButton.checked)
            self.selectedEmployees = "500+"
            return
        default:
            return
        }
    }
    
    @IBAction func continueClicked(sender:UIButton){
        self.saveMerchent.merchant_company_size = self.selectedEmployees
        saveMerchant()
//        let vc = OnboardingRegisterStep5VC.instantiate()
//        vc.saveMerchent = saveMerchent
//        self.pushVC(controller:vc)
    }
    
    func saveMerchant(){
        print(self.saveMerchent.getParam())
        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints:APIEndPoints.saveMerchants(), param: self.saveMerchent.getParam()) { success, response, error in
            if let res = response{
                print(res)
                let user = Mapper<EmployeeData>().map(JSONObject:res)
                Defaults.shared.currentUser = user?.empData?.first
                Defaults.shared.passLen = self.saveMerchent.emp_password?.length
                
                print(Defaults.shared.currentUser?.merchantName ?? "")
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
}
