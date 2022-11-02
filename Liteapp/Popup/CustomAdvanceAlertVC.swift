//
//  CustomAdvanceAlertVC.swift
//  Liteapp
//
//  Created by Apurv Soni on 13/09/22.
//

import UIKit

enum advAlertType {
    case validation
    case success
    case failure
}

class CustomAdvanceAlertVC: UIViewController,StoryboardSceneBased {

    // MARK: - Outlets
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewTop: UIView!
    
    // MARK: - Variables
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.mainiPad.rawValue : StoryboardName.main.rawValue, bundle: nil)
    var completion: ((Bool) -> ())?
    var strTitle : String = ""
    var strSubtitle : String = ""
    var alertType : advAlertType = .validation
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewPopup.alpha = 0.0
        setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.viewPopup.alpha = 1.0
        }
    }
    
    func setupUI(){
        lblTitle.text = strTitle
        lblSubtitle.text = strSubtitle
        if alertType == .validation{
            imgLogo.image = UIImage.init(named: "ic_validationAlert")
            viewTop.backgroundColor = UIColor.Color.appYellowColor
        }
        else if  alertType == .success{
            imgLogo.image = UIImage.init(named: "img_success")
            viewTop.backgroundColor = UIColor.Color.appGreenColor
        }
        else {
            imgLogo.image = UIImage.init(named: "ic_delete-1")
            viewTop.backgroundColor = UIColor.Color.appRedColor
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
    
    // MARK: - Button actions
    @IBAction func btnCloseTapped(_ sender: Any) {
        hideView()
    }
}

extension CustomAdvanceAlertVC {
    class func showAlert(prevVC : UIViewController, title: String , subTitle :String = "" , type : advAlertType = .validation , completion: @escaping (Bool) -> () ) {
        
        let vc = CustomAdvanceAlertVC.instantiate()
        vc.strTitle = title
        vc.strSubtitle = subTitle
        vc.alertType = type
        vc.completion = completion
        vc.modalPresentationStyle = .overCurrentContext
        prevVC.present(vc, animated: false, completion: nil)
    }
}

