//
//  CustomMenuView.swift
//  Liteapp
//
//  Created by Apurv Soni on 27/11/22.
//

import UIKit
import MessageUI

protocol CustomMenuItemDelegate : NSObjectProtocol {
    func customMenuItemClicked(menuName:String)
    func customMenuDidHide()
}

class CustomMenuView: UIView {
    
    let kCONTENT_XIB_NAME = "CustomMenuView"
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var constViewMenuLeading: NSLayoutConstraint!
    @IBOutlet weak var btnSupport: UIButton!
    @IBOutlet weak var lblSupportText: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    weak public var delegate: CustomMenuItemDelegate?
    @IBOutlet weak var constvwSupportHeight: NSLayoutConstraint!
    
    var selectedOption:SelectedOption = .TimeClock
    var menuItems = ["TimeClock","Employees","TimeSheets","Settings","Logout \n Manager"]
//    var menuImages = ["ic_timeclock","ic_employee","ic_timesheet","ic_settings","ic_logout"]
    var menuImages = ["ic_timeclock_tint","ic_employees_tint","ic_timesheet_tint","ic_settings_tint","ic_logout_tint"]
    
    var supportText : String = "Having trouble? We've got your back! Contact our support team at support@getilluminate.io and we'll respond as soon as possible."
    var supportEmail = "support@getilluminate.io"
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
            contentView.fixInView(self)
            
            if Defaults.shared.currentUser?.empType ?? "" == "S"{
                menuItems = ["TimeClock","Employees","TimeSheets","Settings","Logout \n Manager"]
    //            menuImages = ["ic_timeclock","ic_employee","ic_timesheets","ic_settings","ic_logout"]
                menuImages = ["ic_timeclock_tint","ic_employees_tint","ic_timesheet_tint","ic_settings_tint","ic_logout_tint"]
            }else{
               menuItems = ["TimeClock","Logout \n Manager"]
    //            menuImages = ["ic_timeclock","ic_logout"]
                menuImages = ["ic_timeclock_tint","ic_logout_tint"]
            }
            
            self.constvwSupportHeight.constant = 0.0
            self.constViewMenuLeading.constant = -277.0
            tblView.register(UINib(nibName: "CustomMenuCell", bundle: nil), forCellReuseIdentifier: "cell")
            tblView.register(UINib(nibName: "CustomMenuLogoutCell", bundle: nil), forCellReuseIdentifier: "cellLogout")
            
            DispatchQueue.main.async {
                self.setupSupportLabel()
            }
        }
    
    @IBAction func btnOutsideClicked(_ sender: Any) {
        self.showHideMenu()
    }
    
    func swipedLeft(){
        if self.isHidden == false{
            showHideMenu()
        }
    }
    
    func swipedRight(){
        if self.isHidden == true{
            showHideMenu()
        }
    }
    
    func showHideMenu(){
        if self.constViewMenuLeading.constant != 0{
            self.isHidden = false
        }
        UIView.animate(withDuration: 0.25) {
            if self.constViewMenuLeading.constant == 0{
                self.constViewMenuLeading.constant = -277
            }
            else{
                self.constViewMenuLeading.constant = 0
            }
            self.layoutIfNeeded()
        } completion: { completed in
            if self.constViewMenuLeading.constant == 0{
                
            }
            else{
                self.isHidden = true
                
                self.delegate?.customMenuDidHide()
                
            }
        }
    }
    
    @IBAction func btnSupportClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
            if self.constvwSupportHeight.constant == 100.0{
                self.constvwSupportHeight.constant = 0.0
            }else{
                self.constvwSupportHeight.constant = 100.0
            }
            self.layoutIfNeeded()
        }
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
                if let parentVC = self.parentViewController{
                    parentVC.present(mail, animated: true)
                }
                
            } else {
                print("Application is not able to send an email")
            }
            
        } else {
            print("Tapped none")
        }
    }
    
}

extension CustomMenuView:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == menuItems.count - 1{
            let cell = tableView.dequeueReusableCell(withIdentifier:"cellLogout",for:indexPath) as! CustomMenuLogoutCell
            cell.label.text = menuItems[indexPath.row]
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
            let cell = tableView.dequeueReusableCell(withIdentifier:"cell",for:indexPath) as! CustomMenuCell
             cell.label.text = menuItems[indexPath.row]
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
        
        delegate?.customMenuItemClicked(menuName: menuItems[indexPath.row])
        showHideMenu()
    }

}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
    
}

extension CustomMenuView : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
