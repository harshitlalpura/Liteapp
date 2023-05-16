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
    @IBOutlet weak var businessURLValidationView: UIView!
    @IBOutlet weak var vwGradiantContainer: UIView!
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var businessTitleLabel: UILabel!
    @IBOutlet weak var businessUrlLabel: UILabel!
    @IBOutlet weak var businessUrlValidationLabel: UILabel!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()
        // Do any additional setup after loading the view.
        
        stepLabel.text = NSLocalizedString("Step 3 of 5", comment: "stepLabel")
        businessTitleLabel.text = NSLocalizedString("Does your business have a website ?", comment: "businessTitleLabel")
        businessUrlLabel.text = NSLocalizedString("Business Website", comment: "businessUrlLabel")
        txtBusinessURL.placeholder = NSLocalizedString("Enter Website URL", comment: "txtBusinessURL")
        businessUrlValidationLabel.text = NSLocalizedString("Please Enter Valid URL", comment: "businessUrlValidationLabel")
        btnSkip.setTitle(NSLocalizedString("Skip", comment: "btnSkip"), for: .normal)
        btnContinue.setTitle(NSLocalizedString("Continue", comment: "btnContinue"), for: .normal)
    }
    
    func checkTextValidation(){
        if txtBusinessURL.text!.count < 1{
            self.businessURLValidationView.isHidden = false
        }else{
            self.businessURLValidationView.isHidden = true
        }
    }
    
    func checkValidation()->Bool{
        checkTextValidation()
        if txtBusinessURL.text!.count < 1{
          
          //  self.showAlert(alertType:.validation, message: "Please Eneter Business Name")
            return false
        }
        
        if let url = txtBusinessURL.text{
            if !(url.count > 0 && url.isValidUrl()){
                self.showAlert(alertType:.validation, message: NSLocalizedString("Invalid Website. Please Try Again.", comment: "alertLabel"))
                return false
            }
        }
        return true
    }
    
    @IBAction func continueClicked(sender:UIButton){
        if checkValidation(){
            saveMerchent.merchant_web = txtBusinessURL.text!
            let vc = OnboardingRegisterStep4VC.instantiate()
            vc.saveMerchent = saveMerchent
            self.pushVC(controller:vc)
        }
    }
    @IBAction func skipClicked(sender:UIButton){
        let vc = OnboardingRegisterStep4VC.instantiate()
        vc.saveMerchent = saveMerchent
        self.pushVC(controller:vc)
    }
    


}
