//
//  AddEmployeeVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 16/06/22.
//

import UIKit

protocol AddEmployeeVCDelegate : NSObjectProtocol {
    func didDismiss()
}
extension AddEmployeeVCDelegate{
    func didDismiss(){}
 
}


class AddEmployeeVC:BaseViewController, StoryboardSceneBased{

    var delegate:AddEmployeeVCDelegate?
    @IBOutlet weak var viewPopup: UIView!
    
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopup.alpha = 0.0
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.viewPopup.alpha = 1.0
        }
    }
    
    @IBAction func closeClicked(sender:UIButton){
        UIView.animate(withDuration: 0.25) {
            self.viewPopup.alpha = 0.0
            self.dismiss(animated:false)
            self.popVC()
        }
        
    }
    
    @IBAction func addClick(sender:UIButton){
        if sender.tag == 4{
            self.dismiss(animated:false) {
                self.delegate?.didDismiss()
            }
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
            self.dismiss(animated:true) {
                self.delegate?.didDismiss()
            }
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
