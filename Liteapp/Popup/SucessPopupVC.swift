//
//  SucessPopupVC.swift
//  Liteapp
//
//  Created by Apurv Soni on 09/09/22.
//

import UIKit

class SucessPopupVC: UIViewController,StoryboardSceneBased {

    // MARK: - Outlets
    @IBOutlet weak var viewPopup: UIView!
    
    // MARK: - Variables
    var completion: ((Bool) -> ())?
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
   
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPopup.alpha = 0.0
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.viewPopup.alpha = 1.0
        }
    }
    
    // MARK: - Helper
    func hideView(){
        UIView.animate(withDuration: 0.2) {
            self.viewPopup.alpha = 0.0
        }completion: { completed in
            self.completion!(true)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    // MARK: - Button Actions
    @IBAction func btnCloseTapped(_ sender: Any) {
        hideView()
    }
    
    
}

extension SucessPopupVC {
    class func showSuccessPopup(prevVC : UIViewController , completion: @escaping (Bool) -> () ) {
        
        let vc = SucessPopupVC.instantiate()
        vc.completion = completion
        vc.modalPresentationStyle = .overCurrentContext
        prevVC.present(vc, animated: false, completion: nil)
    }
}
