//
//  SettingsSavePopupVC.swift
//  Liteapp
//
//  Created by Apurv Soni on 06/09/22.
//

import UIKit

class SettingsSavePopupVC: UIViewController,StoryboardSceneBased {

    // MARK: - Outlets
    @IBOutlet weak var viewSavePopup: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    // MARK: - Variables
    var completion: ((Bool) -> ())?
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSavePopup.alpha = 0.0
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.viewSavePopup.alpha = 1.0
        }
    }
    
    func hideView(with isSaved: Bool){
        UIView.animate(withDuration: 0.2) {
            self.viewSavePopup.alpha = 0.0
        }completion: { completed in
            self.dismiss(animated: false, completion: nil)
            self.completion!(isSaved)
        }
    }
    
    // MARK: - Button Actions
    @IBAction func btnSaveClicked(_ sender: Any) {
        hideView(with: true)
    }
    
    @IBAction func btnCancelClicked(_ sender: Any) {
        hideView(with: false)
    }
}

extension SettingsSavePopupVC {
    class func showSettingsSavePopup(prevVC : UIViewController , completion: @escaping (Bool) -> () ) {
        
        let vc = SettingsSavePopupVC.instantiate()
        vc.completion = completion
        vc.modalPresentationStyle = .overCurrentContext
        prevVC.present(vc, animated: false, completion: nil)
    }
}
