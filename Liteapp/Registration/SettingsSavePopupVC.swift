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
    @IBOutlet weak var lblSaveTitle: UILabel!
    @IBOutlet weak var lblSaveDesc: UILabel!
    @IBOutlet weak var lblWeeklyOvertime: UILabel!
    @IBOutlet weak var lblDailyOvertime: UILabel!
    @IBOutlet weak var lblPayPeriod: UILabel!
    @IBOutlet weak var lblPayPeriodWeek: UILabel!
    @IBOutlet weak var lblPayPeriodStart: UILabel!
    
    // MARK: - Variables
    var completion: ((Bool) -> ())?
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewSavePopup.alpha = 0.0
        
        lblSaveTitle.text = NSLocalizedString("Before you Save...", comment: "lblSaveTitle")
        lblSaveDesc.text = NSLocalizedString("Any changes made to the following settings will display on the next pay period", comment: "lblSaveDesc")
        lblWeeklyOvertime.text = NSLocalizedString("Weekly Overtime", comment: "lblWeeklyOvertime")
        lblDailyOvertime.text = NSLocalizedString("Daily Overtime", comment: "lblDailyOvertime")
        lblPayPeriod.text = NSLocalizedString("Pay Period Type", comment: "lblPayPeriod")
        lblPayPeriodWeek.text = NSLocalizedString("Current Pay Period Week", comment: "lblPayPeriodWeek")
        lblPayPeriodStart.text = NSLocalizedString("Pay Period Start Day", comment: "lblPayPeriodStart")
        btnSave.setTitle(NSLocalizedString("Save", comment: "btnSave"), for: .normal)
        btnCancel.setTitle(NSLocalizedString("Cancel", comment: "btnCancel"), for: .normal)
        
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
