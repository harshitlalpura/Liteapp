//
//  TimesheetListVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 19/06/22.
//

import UIKit
import SideMenu
import ObjectMapper
import Alamofire
import SwiftUI

enum TimesheetStatus:String{
    case approved = "A"
    case unapproved = "U"
}

extension UIImage{
    static let checkImage = UIImage(named:"ic_check_box")
    static let uncheckImage = UIImage(named:"ic_uncheck_box")
}
class TimesheetListVC: BaseViewController, StoryboardSceneBased{
        
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.timesheet.rawValue, bundle: nil)
    var menu:SideMenuNavigationController!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var selectedPayperiodLabel: UILabel!
    @IBOutlet weak var txtselectedPayperiod: UITextField!
    
    @IBOutlet weak var exportMainView: UIView!
    @IBOutlet weak var approveMainview: UIView!
    var timesheetList =  [PayPeriodTimesheet]()
    var selectedTimesheetList =  [PayPeriodTimesheet]()
    var selectedPayPeriod:Payperiods?
    var selectedPayPeriodIndex:Int = 0
    var payPeriodsData = [Payperiods]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setupMenu()
        setData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        selectedTimesheetList =  [PayPeriodTimesheet]()
        fetchpayperiod()
    }
    override func viewDidAppear(_ animated: Bool) {
        selectedTimesheetList =  [PayPeriodTimesheet]()
    }
    @IBAction func menuClicked(sender:UIButton){
        self.present(menu, animated: true, completion: {})
    }
    private func setupMenu(){
        let controller = MenuViewController.instantiate()
        controller.delegate = self
        controller.selectedOption = .TimeSheet
        menu = SideMenuNavigationController(rootViewController:controller)
        menu.navigationBar.isHidden = true
        menu.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView:view)
        SideMenuManager.default.leftMenuNavigationController = menu
        
    }
    func setData(){
        logoutView.isHidden = true
        lblusername.text = "\(Defaults.shared.currentUser?.empFirstname ?? "") \(Defaults.shared.currentUser?.empLastname ?? "")"
        
        self.approveMainview.alpha = 0.5
        self.exportMainView.alpha = 0.5
    }
    func setTableView(){
        //self.tblview.register(EmployeeCell.self, forCellWithReuseIdentifier: "EmployeeCell")
        tblview.delegate = self
        tblview.dataSource = self
    }
    @IBAction func rightBarButtonClicked(sender:UIButton){
        if logoutView.isHidden == true{
            logoutView.isHidden = false
        }else{
            logoutView.isHidden = true
        }
    }
    @IBAction func logoutClicked(sender:UIButton){
        Defaults.shared.currentUser = nil
        Utility.setRootScreen(isShowAnimation: true)
        logoutView.isHidden = true
    }
    func fetchTimesheetList(){
        
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0,
             "payperiod_id":"\(selectedPayPeriod?.payperiodId ?? 0)",
            "limit":"100",
            "offset":"0",
            "sort_column":"emp_firstname",
            "sort_type":"asc",
        ] as [String : Any]

        
        print(parameters)
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.fetchTimesheetsById(), param: parameters, header: Defaults.shared.header ?? ["":""]){ success, response, error in
            if let res = response{
               // print(res)
                let data = Mapper<TimesheetData>().map(JSONObject:res)
               self.timesheetList = data?.timesheets ?? [PayPeriodTimesheet]()
                self.tblview.reloadData()
                
            }else if let err = error{
                print(err)
            }
        }
      
    }
    private func fetchpayperiod(){
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0
        ] as [String : Any]

      
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.fetchAllPayPeriods(), param: parameters, header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                print(res)
                let data = Mapper<EmployeeTimeReportData>().map(JSONObject:res)
                self.payPeriodsData = data?.payperiods ?? [Payperiods]()
                self.selectedPayPeriod = self.payPeriodsData.first
                self.selectedPayPeriodIndex = 0
                let str = "\(self.selectedPayPeriod?.payperiodFrom1 ?? "") - \(self.selectedPayPeriod?.payperiodTo1 ?? "")"
                self.selectedPayperiodLabel.text = str
               //call timesheet by id
                self.fetchTimesheetList()
            }else if let err = error{
                print(err)
            }
        }
    }
    @IBAction func selectPayperiodButton(sender:UIButton){
        
        let pickerArray = createPickerArray(payPereods:self.payPeriodsData )
        PickerView.sharedInstance.addPicker(self, onTextField:txtselectedPayperiod, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                // self.txtselectedPayperiod.text = value
                 print(value)
                 self.selectedPayperiodLabel.text = value
                 self.selectedPayPeriod = self.payPeriodsData[index]
                 self.selectedPayPeriodIndex = index
                let str = "\(self.selectedPayPeriod?.payperiodFrom1 ?? "") - \(self.selectedPayPeriod?.payperiodTo1 ?? "")"
                self.selectedPayperiodLabel.text = str
               //call timesheet by id
                self.fetchTimesheetList()
                print(self.selectedPayPeriod?.toJSON() ?? "")
             }
           // self.txtselectedPayperiod.isUserInteractionEnabled = false
            self.txtselectedPayperiod.resignFirstResponder()
        }
        
    }
    func createPickerArray(payPereods:[Payperiods])->[String]{
    
        var pickerArray = [String]()
        for payPeriod in payPereods{
            let str = "\(payPeriod.payperiodFrom1 ?? "") - \(payPeriod.payperiodTo1 ?? "")"
            pickerArray.append(str)
        }
        return pickerArray
        
    }
    @IBAction func unaprooveClick(sender:UIButton){
        self.changeStatusAPI(status:TimesheetStatus.unapproved)
    }
    @IBAction func aprooveClick(sender:UIButton){
        self.changeStatusAPI(status:TimesheetStatus.approved)
    }
    @IBAction func exportClick(sender:UIButton){
        
    }
    
    func changeStatusAPI(status:TimesheetStatus){
        let array: Array = selectedTimesheetList.map(){"\($0.empId ?? 0)"}
        let joinedString: String  = array.joined(separator:",")
        print(joinedString)
        let employeeIDs = joinedString
      //  let ids = "\(self.selectedTimesheetList.first?.empId ?? 0)"
        let message = (status == TimesheetStatus.unapproved) ? "The selected timesheets were successfully approved" : "The selected timesheets were successfully unapproved"
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0,
            "status":status.rawValue,
            "ids":employeeIDs
        ] as [String : Any]

        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.changeStatus(), param: parameters, header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                print(res)
                if let status = res["status"] as? Int{
                    if status == 1{
                        self.fetchTimesheetList()
                        AlertMesage.show(.success, message:message)
                    }else{
                        AlertMesage.show(.success, message:message)
                    }
                }
               
                
            }else if let err = error{
                print(err)
                AlertMesage.show(.error, message: err.localizedDescription)
            }
        }
    }
}
extension TimesheetListVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timesheetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblview.dequeueReusableCell(withIdentifier: TimesheetDetailsCell.reuseIdentifier, for: indexPath as IndexPath) as! TimesheetDetailsCell
        let employee = self.timesheetList[indexPath.row]
        cell.lblName.text = (employee.empFirstname ?? "") + " " + (employee.empLastname ?? "")
        cell.lbltotal.text = (employee.total ?? "")
        if employee.payperiodStatus ?? "" == "U"{
            cell.lblapprove.text = "Unapprove"
            cell.lblapprove.textColor = UIColor.Color.appYellowColor
        }else if employee.payperiodStatus ?? "" == "A"{
            cell.lblapprove.text = "Approve"
            cell.lblapprove.textColor = UIColor.Color.appGreenColor
        }
        cell.btnCheck.isSelected = false
        cell.btnCheck.addTarget(self, action:#selector(self.checkClicked(sender:)), for: .touchUpInside)
        cell.btnCheck.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EmployeeTimeReportVC.instantiate()
        vc.selectedEmployeeID = timesheetList[indexPath.row].empId?.stringValue ?? ""
        self.pushVC(controller:vc)
    }
    @objc func checkClicked(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            self.selectedTimesheetList.append(timesheetList[sender.tag])
           
        }else{
            self.selectedTimesheetList = self.selectedTimesheetList.filter({$0.empId != timesheetList[sender.tag].empId})
        }
        if selectedTimesheetList.count > 0{
            self.approveMainview.alpha = 1.0
            self.exportMainView.alpha = 1.0
        }else{
            self.approveMainview.alpha = 0.5
            self.exportMainView.alpha = 0.5
        }
        print( self.selectedTimesheetList.count)
    }
    
    
}
extension TimesheetListVC:MenuItemDelegate {
    func MenuItemClicked(menuName: String) {
        print(menuName)
        if menuName == Menuname.settings{
            let vc = SettingsVC.instantiate()
            self.pushVC(controller:vc)
        }else  if menuName == Menuname.logout{
            Defaults.shared.currentUser = nil
            Utility.setRootScreen(isShowAnimation: true)
            logoutView.isHidden = true
        }else  if menuName == Menuname.employee{
            let vc = EmployeesVC.instantiate()
            self.pushVC(controller:vc)
        }else  if menuName == Menuname.timeSheet{
            let vc = TimesheetListVC.instantiate()
            self.pushVC(controller:vc)
        }else  if menuName == Menuname.timeClock{
            let vc = DashBoardVC.instantiate()
            self.pushVC(controller:vc)
        }
    }
}
