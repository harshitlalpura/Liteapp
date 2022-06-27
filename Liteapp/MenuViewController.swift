//
//  MenuViewController.swift
//  Liteapp
//
//  Created by Navroz Huda on 07/06/22.
//

import Foundation
import UIKit

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
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    @IBOutlet weak var menuTableview: UITableView!
    @IBOutlet weak var userImageview: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var upgradePremiumView: UIView!
    var selectedOption:SelectedOption = .TimeClock
    weak public var delegate: MenuItemDelegate?
    var menuItems = ["TimeClock","Employees","TimeSheets","Settings","Logout \n Manager"]
    var menuImages = ["ic_timeclock","ic_employee","ic_timesheet","ic_settings","ic_logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    private func setupTableView(){
        if Defaults.shared.currentUser?.empType ?? "" == "S"{
            menuItems = ["TimeClock","Employees","TimeSheets","Settings","Logout \n Manager"]
            menuImages = ["ic_timeclock","ic_employee","ic_timesheets","ic_settings","ic_logout"]
        }else{
           menuItems = ["TimeClock","Logout \n Manager"]
            menuImages = ["ic_timeclock","ic_logout"]
        }
        menuTableview.delegate = self
        menuTableview.dataSource = self
        menuTableview.rowHeight = 50.0
        menuTableview.separatorStyle = .none
        menuTableview.bouncesZoom = false
        menuTableview.bounces = false
        
    }
    func setSelected(selectedOption:SelectedOption,index:Int){
       
            
    }
    

}
extension MenuViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell",for:indexPath) as! MenuCell
        cell.label.text = menuItems[indexPath.row]
        cell.label.textAlignment = .left
      
        cell.label.textColor = .black
        cell.imageview.image = UIImage(named:menuImages[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.Color.white
        
        if indexPath.row == self.selectedOption.rawValue{
            cell.label.textColor = UIColor.Color.appBlueColor
         //   cell.label.font = UIFont.Robotobold(size:20)
            
        }else{
          //  cell.label.font = UIFont.Robotobold(size:20)
            cell.label.textColor = .black
        }
        cell.selectedBar.isHidden = true
        if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .TimeClock{
            cell.imageview.image = UIImage(named:"ic_timeclock_selected")
            cell.selectedBar.isHidden = false
        }else if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .Employee{
            cell.imageview.image = UIImage(named:"ic_employee_selected")
            cell.selectedBar.isHidden = false
        }else if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .TimeSheet{
            cell.imageview.image = UIImage(named:"ic_timesheets_selected")
            cell.selectedBar.isHidden = false
        }else if indexPath.row == self.selectedOption.rawValue && self.selectedOption == .Settings{
            cell.imageview.image = UIImage(named:"ic_settings_selected")
            cell.selectedBar.isHidden = false
        }
        
        return cell
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
class MenuCell : UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectedBar: UIView!
}
protocol MenuItemDelegate : NSObjectProtocol {
    func MenuItemClicked(menuName:String)
}
extension MenuItemDelegate{
    func MenuItemClicked(menuName:String){}
}
