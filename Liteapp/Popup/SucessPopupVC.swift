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
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    // MARK: - Variables
    var completion: ((Bool) -> ())?
    var strTitle : String = ""
    var strSubTitle : String = ""
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
   
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPopup.alpha = 0.0
        
        lblTitle.text = strTitle
        lblSubtitle.text = strSubTitle
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
    class func showSuccessPopup(prevVC : UIViewController, titleStr : String, strSubTitle : String , completion: @escaping (Bool) -> () ) {
        
        let vc = SucessPopupVC.instantiate()
        vc.completion = completion
        vc.strTitle = titleStr
        vc.strSubTitle = strSubTitle
        vc.modalPresentationStyle = .overCurrentContext
        prevVC.present(vc, animated: false, completion: nil)
    }
}
