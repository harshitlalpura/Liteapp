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
        case pending = 3
}
class CustomAlertViewController: BaseViewController, StoryboardSceneBased{

    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    var alertType:AlertType = .success
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        }else if alertType == .pending{
            topBarView.backgroundColor = UIColor.Color.appYellowColor
            button.backgroundColor = UIColor.Color.appYellowColor
            lblTitle.text = "Delete Employee"
        }
    }
    @IBAction func buttonClicked(sender:UIButton){
        
        self.dismiss(animated:true)
        
    }
    

}
