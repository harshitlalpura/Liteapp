//
//  CustomAlertViewController.swift
//  Liteapp
//
//  Created by Navroz Huda on 09/06/22.
//

import UIKit
import SwiftUI

enum AlertType:Int{
        case success  = 1
        case failed = 2
        case validation = 3
}
class CustomAlertViewController: BaseViewController, StoryboardSceneBased{

    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.main.rawValue : StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    var validationMessage: String = ""
    var successMessage: String = ""
    var failureMessage: String = ""
    @IBOutlet weak var validationAlert: UIView!
    @IBOutlet weak var successAlert: UIView!
    @IBOutlet weak var failedAlert: UIView!
    var alertType:AlertType = .success
    @IBOutlet weak var lblSuccessMessage: UILabel!
    @IBOutlet weak var lblValidationMessage: UILabel!
    @IBOutlet weak var lblFailureMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSuccessMessage.text = successMessage
        lblValidationMessage.text = validationMessage
        lblFailureMessage.text = failureMessage
        if alertType == .success{
            self.validationAlert.isHidden = true
            self.successAlert.isHidden = false
            self.failedAlert.isHidden = true
        }else if alertType == .validation{
            self.validationAlert.isHidden = false
            self.successAlert.isHidden = true
            self.failedAlert.isHidden = true
        }else if alertType == .failed{
            self.validationAlert.isHidden = true
            self.successAlert.isHidden = true
            self.failedAlert.isHidden = false
        }
       
    }
    func setupUI(){
        if alertType == .success{
            topBarView.backgroundColor = UIColor.Color.appGreenColor
            button.backgroundColor = UIColor.Color.appGreenColor
            lblTitle.text = "Congratulations"
        }else if alertType == .failed{
            topBarView.backgroundColor = UIColor.Color.appRedColor
            button.backgroundColor = UIColor.Color.appRedColor
            lblTitle.text = "Delete Employee"
        }else if alertType == .validation{
            topBarView.backgroundColor = UIColor.Color.appYellowColor
            button.backgroundColor = UIColor.Color.appYellowColor
            lblTitle.text = "Delete Employee"
        }
    }
    @IBAction func buttonClicked(sender:UIButton){
        
        self.dismiss(animated:true)
        
    }
    

}
