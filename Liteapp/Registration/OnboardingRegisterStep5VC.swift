//
//  OnboardingRegisterStep5VC.swift
//  Liteapp
//
//  Created by Navroz Huda on 08/06/22.
//

import UIKit
import ObjectMapper

class OnboardingRegisterStep5VC:BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    var saveMerchent:SaveMerchant!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(saveMerchent ?? "")
        saveMerchant()
    }
    func saveMerchant(){
        print(self.saveMerchent.getParam())
        NetworkLayer.sharedNetworkLayer.postWebApiCall(apiEndPoints:APIEndPoints.saveMerchants(), param: self.saveMerchent.getParam()) { success, response, error in
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

    @IBAction func continueClicked(sender:UIButton){
       
    }

}
