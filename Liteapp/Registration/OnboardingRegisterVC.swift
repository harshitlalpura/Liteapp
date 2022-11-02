//
//  OnboardingRegisterVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 07/06/22.
//

import UIKit

class OnboardingRegisterVC: BaseViewController, StoryboardSceneBased{
    
    @IBOutlet weak var vwGradiantContainer: UIView!
    @IBOutlet weak var lblTermsAndPrivacy: UILabel!
    var privacyText : String = ""
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwGradiantContainer.setGradientBackground()

    }
    override func viewDidAppear(_ animated: Bool) {
//        if let code = Defaults.shared.referralCode{
//            self.showToast(message:"\(code)", font: UIFont.RobotoRegular(size:20.0))
//        }
    }
    
    func setupTermsAndPrivacyLabel(){
        
        privacyText = "By signing up, you agree to our End User License Agreement and Privacy Policy."
        lblTermsAndPrivacy.text = privacyText
        lblTermsAndPrivacy.textColor =  UIColor.white
        let underlineAttriString = NSMutableAttributedString(string: privacyText)
        let range1 = (privacyText as NSString).range(of: "End User License Agreement")
        let range2 = (privacyText as NSString).range(of: "Privacy Policy")
        let rangeFull = (privacyText as NSString).range(of: privacyText)
        let fontSize = lblTermsAndPrivacy.font.pointSize
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: fontSize), range: range2)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        underlineAttriString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: rangeFull)
        lblTermsAndPrivacy.attributedText = underlineAttriString
        lblTermsAndPrivacy.isUserInteractionEnabled = true
        lblTermsAndPrivacy.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (privacyText as NSString).range(of: "End User License Agreement")
        let privacyRange = (privacyText as NSString).range(of: "Privacy Policy")
        
        if gesture.didTapAttributedTextInLabel(label: lblTermsAndPrivacy, inRange: termsRange) {
            print("Tapped terms")
            let vc = TermsPrivacyStaticPagesVC.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
            vc.isForTerms = true
            self.pushVC(controller:vc)
        } else if gesture.didTapAttributedTextInLabel(label: lblTermsAndPrivacy, inRange: privacyRange) {
            print("Tapped privacy")
            let vc = TermsPrivacyStaticPagesVC.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
            vc.isForTerms = false
            self.pushVC(controller:vc)
        } else {
            print("Tapped none")
        }
    }
    
    
    @IBAction func registerAsEmployeeClicked(sender:UIButton){
        let vc = EmployeeOnboardingVCStep1.instantiate()
        self.pushVC(controller:vc)
    }
    @IBAction func registerAsManagerClicked(sender:UIButton){
        let vc = OnboardingRegisterStep1VC.instantiate()
        self.pushVC(controller:vc)
    }
    @IBAction func userAvailableClicked(sender:UIButton){
        
        self.popVC()
    }
}
