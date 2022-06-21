//
//  AddEmployeeVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 16/06/22.
//

import UIKit

class AddEmployeeVC:BaseViewController, StoryboardSceneBased{

    static let sceneStoryboard = UIStoryboard(name: StoryboardName.merchant.rawValue, bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeClicked(sender:UIButton){
        self.dismiss(animated:true)
        self.popVC()
        
    }
    
    @IBAction func addClick(sender:UIButton){
        if sender.tag == 4{
            let vc = CreateEmployeeVC.instantiate()
            self.pushVC(controller:vc)
        }else if sender.tag == 3{
            let vc = InviteViaEmailVC.instantiate()
            self.pushVC(controller:vc)
        }else if sender.tag == 2{
            let vc = InviteViaTextVC.instantiate()
            self.pushVC(controller:vc)
        }else if sender.tag == 1{
            let vc = InviteViaRefferalLinkVC.instantiate()
            self.pushVC(controller:vc)
        }else{
            let vc = CreateEmployeeVC.instantiate()
            self.pushVC(controller:vc)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
