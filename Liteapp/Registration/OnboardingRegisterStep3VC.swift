//
//  OnboardingRegisterStep3VC.swift
//  Liteapp
//
//  Created by Navroz Huda on 08/06/22.
//

import UIKit

class OnboardingRegisterStep3VC: BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    var saveMerchent:SaveMerchant!

    @IBOutlet weak var txtBusinessURL: UITextField!
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueClicked(sender:UIButton){
        saveMerchent.merchant_web = txtBusinessURL.text!
        let vc = OnboardingRegisterStep4VC.instantiate()
        vc.saveMerchent = saveMerchent
        self.pushVC(controller:vc)
    }
    @IBAction func skipClicked(sender:UIButton){
        let vc = OnboardingRegisterStep4VC.instantiate()
        vc.saveMerchent = saveMerchent
        self.pushVC(controller:vc)
    }
    


}
