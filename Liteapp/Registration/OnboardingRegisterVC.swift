//
//  OnboardingRegisterVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 07/06/22.
//

import UIKit

class OnboardingRegisterVC: BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

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
