//
//  PopupMenuVC.swift
//  Liteapp
//
//  Created by Apurv Soni on 24/08/22.
//

import UIKit

enum menuItem {
  case account, logout
}

class PopupMenuVC: UIViewController,StoryboardSceneBased {

    // MARK: - Outlets
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var viewMenu: UIView!
    // MARK: - Variables
    var completion: ((menuItem?) -> ())?
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.timesheetiPad.rawValue : StoryboardName.timesheet.rawValue, bundle: nil)
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMenu.alpha = 0.0
        viewMenu.dropShadow()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.viewMenu.alpha = 1.0
        }
    }
    
    func showMenu(on viewCtl : UIViewController, with completion: (menuItem) -> ()){
        
    }
    
    func hideView(with option : menuItem? = nil){
        UIView.animate(withDuration: 0.2) {
            self.viewMenu.alpha = 0.0
        }completion: { completed in
            self.completion!(option)
            self.dismiss(animated: false, completion: nil)
        }
    }
   
    // MARK: - Button Actions
    @IBAction func btnOutsideMenuTapped(_ sender: Any) {
        self.hideView()
    }
    
    @IBAction func btnAccountTapped(_ sender: Any) {
        self.hideView(with: .account)
    }
    
    @IBAction func btnLogoutTapped(_ sender: Any) {
        self.hideView(with: .logout)
    }
    

}
extension PopupMenuVC {
    class func showPopupMenu(prevVC : UIViewController , completion: @escaping (menuItem?) -> () ) {
        
        let vc = PopupMenuVC.instantiate()
        vc.completion = completion
        vc.modalPresentationStyle = .overCurrentContext
        prevVC.present(vc, animated: false, completion: nil)
    }
}
