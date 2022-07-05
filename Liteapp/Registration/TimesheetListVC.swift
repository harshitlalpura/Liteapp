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
import IQKeyboardManagerSwift

enum TimesheetStatus:String{
    case approved = "A"
    case unapproved = "U"
}
enum Sort:String{
   // asc / desc
    case defaultShort = ""
    case ascending = "asc"
    case decending = "desc"
}
enum CurrentSortType:Int{
   // asc / desc
    case none = 0
    case name = 1
    case total = 2
    case approval = 3
}
extension UIImage{
    static let checkImage = UIImage(named:"ic_check_box")
    static let uncheckImage = UIImage(named:"ic_uncheck_box")
    
    static let checkGreyImage = UIImage(named:"ic_check_grey")
    static let uncheckGreyImage = UIImage(named:"ic_uncheck_grey")
    
    static let sortAsc = UIImage(named:"iconsortAsc")
    static let sortDesc = UIImage(named:"iconsortDesc")
    static let sortDefault = UIImage(named:"iconsortDefault")
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
    
    @IBOutlet weak var nameSortImageview: UIImageView!
    @IBOutlet weak var totalSortImageview: UIImageView!
    @IBOutlet weak var approvalSortImageview: UIImageView!
    
    @IBOutlet weak var btnCheckAll: UIButton!
    
    var sortNameType = Sort.defaultShort
    var sortTotalType = Sort.defaultShort
    var sortApprovalType = Sort.defaultShort
    var currentSortType = CurrentSortType.none
    
    var sortType = ""
    var sortColumn = ""
    
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
        btnCheckAll.setImage(UIImage.checkGreyImage, for: .selected)
        btnCheckAll.setImage(UIImage.uncheckGreyImage, for: .normal)
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
        
        nameSortImageview.image = UIImage.sortDefault
        totalSortImageview.image = UIImage.sortDefault
        approvalSortImageview.image = UIImage.sortDefault
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
            "sort_column":self.sortColumn,
            "sort_type":self.sortType,
        ] as [String : Any]

        self.timesheetList =  [PayPeriodTimesheet]()
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
               self.compareDate("\(self.selectedPayPeriod?.payperiodTo1 ?? "")")
                self.selectedPayperiodLabel.text = str
               //call timesheet by id
                self.fetchTimesheetList()
            }else if let err = error{
                print(err)
            }
        }
    }
    func compareDate(_ dateString:String){
        let formatter = DateFormatter()
        formatter.dateFormat = MMMMddYYYY
        let date = formatter.date(from:dateString)
      
        if Date() < date ?? Date()  {
             print("date1 is earlier than date2")
            self.approveMainview.isUserInteractionEnabled = false
            self.approveMainview.alpha = 0.5
        }else{
            self.approveMainview.isUserInteractionEnabled = true
            self.approveMainview.alpha = 1.0
        }
    }
    @IBAction func selectPayperiodButton(sender:UIButton){
        
        let pickerArray = createPickerArray(payPereods:self.payPeriodsData )
        IQKeyboardManager.shared.enable = false
        PickerView.sharedInstance.addPicker(self, onTextField:txtselectedPayperiod, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                // self.txtselectedPayperiod.text = value
                 print(value)
                IQKeyboardManager.shared.enable = true
                 self.selectedPayperiodLabel.text = value
                 self.selectedPayPeriod = self.payPeriodsData[index]
                 self.selectedPayPeriodIndex = index
                let str = "\(self.selectedPayPeriod?.payperiodFrom1 ?? "") - \(self.selectedPayPeriod?.payperiodTo1 ?? "")"
                self.compareDate("\(self.selectedPayPeriod?.payperiodTo1 ?? "")")
                self.selectedPayperiodLabel.text = str
              
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
    @IBAction func sortNameClicked(sender:UIButton){
        sortColumn = ""
        
        nameSortImageview.image = UIImage.sortDefault
        totalSortImageview.image = UIImage.sortDefault
        approvalSortImageview.image = UIImage.sortDefault
        
        if sortNameType == Sort.decending{
            currentSortType = CurrentSortType.none
            sortType = Sort.defaultShort.rawValue
            sortColumn = "emp_firstname"
            sortNameType = Sort.defaultShort
        }else if sortNameType == Sort.defaultShort{
            currentSortType = CurrentSortType.name
            sortType = Sort.ascending.rawValue
            sortColumn = "emp_firstname"
            sortNameType = Sort.ascending
            nameSortImageview.image = UIImage.sortAsc
        }else if sortNameType == Sort.ascending{
            currentSortType = CurrentSortType.name
            sortType = Sort.decending.rawValue
            sortColumn = "emp_firstname"
            sortNameType = Sort.decending
            nameSortImageview.image = UIImage.sortDesc
        }
        self.fetchTimesheetList()
    }
    @IBAction func sortTotalClicked(sender:UIButton){
        sortColumn = ""
        nameSortImageview.image = UIImage.sortDefault
        totalSortImageview.image = UIImage.sortDefault
        approvalSortImageview.image = UIImage.sortDefault
        if sortTotalType == Sort.decending{
            currentSortType = CurrentSortType.none
            sortType = Sort.defaultShort.rawValue
            sortColumn = "total"
            sortTotalType = Sort.defaultShort
        }else if sortTotalType == Sort.defaultShort{
            currentSortType = CurrentSortType.total
            sortType = Sort.ascending.rawValue
            sortColumn = "total"
            sortTotalType = Sort.ascending
           totalSortImageview.image = UIImage.sortAsc
        }else if sortTotalType == Sort.ascending{
            currentSortType = CurrentSortType.total
            sortType = Sort.decending.rawValue
            sortColumn = "total"
            sortTotalType = Sort.decending
            totalSortImageview.image = UIImage.sortDesc
        }
        self.fetchTimesheetList()
    }
    @IBAction func sortApprovalClicked(sender:UIButton){
        sortColumn = ""
        nameSortImageview.image = UIImage.sortDefault
        totalSortImageview.image = UIImage.sortDefault
        approvalSortImageview.image = UIImage.sortDefault
        if sortApprovalType == Sort.decending{
            currentSortType = CurrentSortType.none
            sortType = Sort.defaultShort.rawValue
            sortColumn = "payperiod_status"
            sortApprovalType = Sort.defaultShort
        }else if sortApprovalType == Sort.defaultShort{
            currentSortType = CurrentSortType.approval
            sortType = Sort.ascending.rawValue
            sortColumn = "payperiod_status"
            sortApprovalType = Sort.ascending
            approvalSortImageview.image = UIImage.sortAsc
        }else if sortApprovalType == Sort.ascending{
            currentSortType = CurrentSortType.approval
            sortType = Sort.decending.rawValue
            sortColumn = "payperiod_status"
            sortApprovalType = Sort.decending
            approvalSortImageview.image = UIImage.sortDesc
        }
        self.fetchTimesheetList()
    }
    @IBAction func checkAllClicked(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.selectedTimesheetList.append(contentsOf:timesheetList)
        }else{
            self.selectedTimesheetList.removeAll()
        }
        if selectedTimesheetList.count > 0{
            self.approveMainview.alpha = 1.0
            self.exportMainView.alpha = 1.0
            self.approveMainview.isUserInteractionEnabled = true
            self.compareDate("\(self.selectedPayPeriod?.payperiodTo1 ?? "")")
        }else{
            self.approveMainview.alpha = 0.5
            self.exportMainView.alpha = 0.5
            self.approveMainview.isUserInteractionEnabled = false
        }
       
        tblview.reloadData()
    }
    func changeStatusAPI(status:TimesheetStatus){
        let array: Array = selectedTimesheetList.map(){"\($0.empId ?? 0)"}
        let joinedString: String  = array.joined(separator:",")
        print(joinedString)
        let employeeIDs = joinedString
      //  let ids = "\(self.selectedTimesheetList.first?.empId ?? 0)"
        let message = (status == TimesheetStatus.unapproved) ? "The selected timesheets were successfully unapproved" : "The selected timesheets were successfully approved"
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
                        self.showAlert(alertType:.validation, message: message)
                       
                    }else{
                        self.showAlert(alertType:.validation, message: message)
                       
                    }
                }
               
                
            }else if let err = error{
                print(err)
                self.showAlert(alertType:.validation, message: err.localizedDescription)
               
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
        cell.btnCheck.isSelected = btnCheckAll.isSelected
       
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EmployeeTimeReportVC.instantiate()
        vc.isFromEmployee = false
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
            self.approveMainview.isUserInteractionEnabled = true
            self.compareDate("\(self.selectedPayPeriod?.payperiodTo1 ?? "")")
        }else{
            self.approveMainview.alpha = 0.5
            self.exportMainView.alpha = 0.5
            self.approveMainview.isUserInteractionEnabled = false
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
