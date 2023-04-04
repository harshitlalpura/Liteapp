//
//  MenuViewController.swift
//  Liteapp
//
//  Created by Navroz Huda on 07/06/22.
//

import Foundation
import UIKit
import MessageUI

enum Menuname{
    static let timeClock = "TimeClock"
    static let employee = "Employees"
    static let timeSheet = "TimeSheets"
    static let Exams = "Exams"
    static let settings = "Settings"
    static let logout = "Logout \n Manager"
    
    
}

enum SelectedOption:Int{
    case TimeClock = 0
    case Employee = 1
    case TimeSheet = 2
    case Settings = 3
    case Logout = 4
}


class MenuViewController: BaseViewController, StoryboardSceneBased{
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.main.rawValue : StoryboardName.main.rawValue, bundle: nil)
    @IBOutlet weak var menuTableview: UITableView!
    @IBOutlet weak var userImageview: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var upgradePremiumView: UIView!
    @IBOutlet weak var btnSupport: UIButton!
    @IBOutlet weak var lblSupportText: UILabel!
    @IBOutlet weak var lblSupportQuestionText: UILabel!
    @IBOutlet weak var constvwSupportHeight: NSLayoutConstraint!
    var selectedOption:SelectedOption = .TimeClock
    weak public var delegate: MenuItemDelegate?
    var menuItems = ["TimeClock","Employees","TimeSheets","Settings","Logout \n Manager"]
//    var menuImages = ["ic_timeclock","ic_employee","ic_timesheet","ic_settings","ic_logout"]
    var menuImages = ["ic_timeclock_tint","ic_employees_tint","ic_timesheet_tint","ic_settings_tint","ic_logout_tint"]
    
    var supportText : String = NSLocalizedString("Let us know how we can help and a member from our Support Team will get back to you!", comment: "lblSupportText")
    var supportEmail = "support@getilluminate.io"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSupport.setTitle(NSLocalizedString("Support", comment: "btnSupport"), for: .normal)
        lblSupportQuestionText.text = NSLocalizedString("Looking for support?", comment: "btnSupport")
        
        self.constvwSupportHeight.constant = 0.0
        setupTableView()
        setupSupportLabel()
    }
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.alpha = 0.0

        return view
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showOverlayView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        hideOverlayView()
        super.viewWillDisappear(animated)
    }
    private func setupTableView(){
        if Defaults.shared.currentUser?.empType ?? "" == "S"{
            menuItems = ["TimeClock","Employees","TimeSheets","Settings","Logout \n Manager"]
//            menuImages = ["ic_timeclock","ic_employee","ic_timesheets","ic_settings","ic_logout"]
            menuImages = ["ic_timeclock_tint","ic_employees_tint","ic_timesheet_tint","ic_settings_tint","ic_logout_tint"]
        }else{
           menuItems = ["TimeClock","Logout \n Manager"]
//            menuImages = ["ic_timeclock","ic_logout"]
            menuImages = ["ic_timeclock_tint","ic_logout_tint"]
        }
        menuTableview.delegate = self
        menuTableview.dataSource = self
        menuTableview.estimatedRowHeight = 65.0
        menuTableview.rowHeight = UITableView.automaticDimension
        menuTableview.separatorStyle = .none
        menuTableview.bouncesZoom = false
        menuTableview.bounces = false
        
    }
    func setSelected(selectedOption:SelectedOption,index:Int){
       
            
    }
    func setupSupportLabel(){
        DispatchQueue.main.async {
            self.lblSupportText.text = self.supportText
            self.lblSupportText.textColor =  UIColor.Color.supportGrey
            let underlineAttriString = NSMutableAttributedString(string: self.supportText)
            let range1 = (self.supportText as NSString).range(of: self.supportEmail)
            let rangeFull = (self.supportText as NSString).range(of: self.supportText)
            underlineAttriString.addAttributes([ NSAttributedString.Key.foregroundColor: UIColor.Color.appBlueColor2, NSAttributedString.Key.font: UIFont.RobotoMedium(size: 14.0),NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue], range: range1)
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .natural
            underlineAttriString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: rangeFull)
            self.lblSupportText.attributedText = underlineAttriString
            self.lblSupportText.lineBreakMode = .byWordWrapping
            self.lblSupportText.isUserInteractionEnabled = true
            self.lblSupportText.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.tapLabel(gesture:))))
        }
    
    }
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let emailRange = (supportText as NSString).range(of: supportEmail)
        
        if gesture.didTapAttributedTextInLabel(label: lblSupportText, inRange: emailRange) {
            print("Tapped Email")
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([supportEmail])
                mail.setSubject("")
                mail.setMessageBody("", isHTML: true)
                present(mail, animated: true)
            } else {
                print("Application is not able to send an email")
            }
            
        } else {
            print("Tapped none")
        }
    }
    
    @IBAction func btnSupportClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
            if self.constvwSupportHeight.constant == 100.0{
                self.constvwSupportHeight.constant = 0.0
            }else{
                self.constvwSupportHeight.constant = 100.0
            }
            self.view.layoutIfNeeded()
        }
    }
    
}
extension MenuViewController {
    private func showOverlayView() {
        addOverlayView()
        UIView.animate(withDuration: 0.5) {
            self.overlayView.alpha = 0.5
        }
    }

    private func hideOverlayView() {
        UIView.animate(withDuration: 0.5) {
            self.overlayView.alpha = 0.0
        } completion: { _ in
            self.removeOverlayView()
        }
    }

    private func addOverlayView() {
        guard let view = presentingViewController?.view else { return }
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func removeOverlayView() {
        overlayView.removeFromSuperview()
    }
}
extension MenuViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == menuItems.count - 1{
            let cell = tableView.dequeueReusableCell(withIdentifier:"cellLogout",for:indexPath) as! MenuLogoutCell
            cell.label.text = NSLocalizedString(menuItems[indexPath.row], comment: "menuItems")
            cell.label.textAlignment = .left
          
            cell.label.textColor = .black
            cell.imageview.image = UIImage(named:menuImages[indexPath.row])
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.Color.white
            
            if indexPath.row == self.selectedOption.rawValue{
                cell.label.textColor = UIColor.Color.appBlueColor2
                cell.imageview.tintColor = UIColor.Color.appBlueColor2.withAlphaComponent(0.5)
             //   cell.label.font = UIFont.Robotobold(size:20)
                
            }else{
              //  cell.label.font = UIFont.Robotobold(size:20)
                cell.label.textColor = UIColor.Color.black
                cell.imageview.tintColor = UIColor.Color.grayblack
            }
            cell.selectedBar.isHidden = true
            if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .TimeClock{
    //            cell.imageview.image = UIImage(named:"ic_timeclock_selected")
                cell.selectedBar.isHidden = false
            }else if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .Employee{
    //            cell.imageview.image = UIImage(named:"ic_employee_selected")
                cell.selectedBar.isHidden = false
            }else if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .TimeSheet{
    //            cell.imageview.image = UIImage(named:"ic_timesheets_selected")
                cell.selectedBar.isHidden = false
            }else if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .Settings{
    //            cell.imageview.image = UIImage(named:"ic_settings_selected")
                cell.selectedBar.isHidden = false
            }
            if let firstName = Defaults.shared.currentUser?.empFirstname, let lastname = Defaults.shared.currentUser?.empLastname{
                cell.lblUserName.text = firstName + " " + lastname
            }
            else{
                cell.lblUserName.text = ""
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier:"cell",for:indexPath) as! MenuCell
             cell.label.text = NSLocalizedString(menuItems[indexPath.row], comment: "menuItems")
             cell.label.textAlignment = .left
           
             cell.label.textColor = .black
             cell.imageview.image = UIImage(named:menuImages[indexPath.row])
             cell.selectionStyle = .none
             cell.backgroundColor = UIColor.Color.white
             
             if indexPath.row == self.selectedOption.rawValue{
                 cell.label.textColor = UIColor.Color.appBlueColor2
                 cell.imageview.tintColor = UIColor.Color.appBlueColor2.withAlphaComponent(0.5)
              //   cell.label.font = UIFont.Robotobold(size:20)
                 
             }else{
               //  cell.label.font = UIFont.Robotobold(size:20)
                 cell.label.textColor = UIColor.Color.black
                 cell.imageview.tintColor = UIColor.Color.grayblack
             }
             cell.selectedBar.isHidden = true
             if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .TimeClock{
     //            cell.imageview.image = UIImage(named:"ic_timeclock_selected")
                 cell.selectedBar.isHidden = false
             }else if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .Employee{
     //            cell.imageview.image = UIImage(named:"ic_employee_selected")
                 cell.selectedBar.isHidden = false
             }else if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .TimeSheet{
     //            cell.imageview.image = UIImage(named:"ic_timesheets_selected")
                 cell.selectedBar.isHidden = false
             }else if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .Settings{
     //            cell.imageview.image = UIImage(named:"ic_settings_selected")
                 cell.selectedBar.isHidden = false
             }
             
             return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuItems[indexPath.row] == Menuname.Exams{
           
            return
        }
        self.dismiss(animated:true) { [self] in
            delegate?.MenuItemClicked(menuName: menuItems[indexPath.row])
        }
    }

}
extension MenuViewController : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

class MenuCell : UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectedBar: UIView!
}

class MenuLogoutCell : UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var selectedBar: UIView!
}


protocol MenuItemDelegate : NSObjectProtocol {
    func MenuItemClicked(menuName:String)
}
extension MenuItemDelegate{
    func MenuItemClicked(menuName:String){}
}
