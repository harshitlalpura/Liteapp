//
//  DeleteAccountVC.swift
//  Liteapp
//
//  Created by Apurv Soni on 14/12/22.
//

import UIKit

class DeleteAccountVC: UIViewController ,StoryboardSceneBased {
    
    // MARK: - Outlets
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblDeleteTitle: UILabel!
    @IBOutlet weak var lblDeleteDesc: UILabel!
    
    // MARK: - Variables
    var completion: ((Bool) -> ())?
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblDeleteTitle.text = NSLocalizedString("Delete Account?", comment: "lblDeleteTitle")
        lblDeleteDesc.text = NSLocalizedString("Are you sure you want to delete your account? All of your data will be deleted and your employees will no longer be able to access their accounts.", comment: "lblDeleteDesc")
        btnDelete.setTitle(NSLocalizedString("Delete", comment: "btnDelete"), for: .normal)
        btnCancel.setTitle(NSLocalizedString("Cancel", comment: "btnCancel"), for: .normal)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.viewPopup.alpha = 1.0
        }
    }
    
    // MARK: - Helper
    func hideView(with isDeleted: Bool){
        UIView.animate(withDuration: 0.2) {
            self.viewPopup.alpha = 0.0
        }completion: { completed in
            self.completion!(isDeleted)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Button Actions
  
    @IBAction func btnDeleteTapped(_ sender: Any) {
        hideView(with: true)
    }
    
    @IBAction func btnCancelTapped(_ sender: Any) {
        hideView(with: false)
    }
}

extension DeleteAccountVC {
    class func showDeleteAccountPopup(prevVC : UIViewController , completion: @escaping (Bool) -> () ) {
        
        let vc = DeleteAccountVC.instantiate()
        vc.completion = completion
        vc.modalPresentationStyle = .overCurrentContext
        prevVC.present(vc, animated: false, completion: nil)
    }
}

