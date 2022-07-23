//
//  EmployeeTimeReportVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 15/06/22.
//

import UIKit
import SideMenu
import ObjectMapper
import Alamofire
import SwiftUI
import IQKeyboardManagerSwift
import MKToolTip

class MyButton : UIButton {
    var weekIndex : Int = -1
    var timeSheetIndex = -1
    var eventIndex : Int = -1

}
class MyDatePicker:UIDatePicker{
    var weekIndex : Int = -1
    var timeSheetIndex = -1
    var eventIndex : Int = -1
}
class DatePickerTextField : UIButton {
    var weekIndex : Int = -1
    var timeSheetIndex = -1
    var eventIndex : Int = -1

}
private var myContext = 0
private var collectionviewContext = 0
class EmployeeTimeReportVC:BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
    var menu:SideMenuNavigationController!
    
    @IBOutlet weak var lblweekDay1: UILabel!
    @IBOutlet weak var lblweekDayDate1: UILabel!
    @IBOutlet weak var btnWeekDay1: UIButton!
    
    @IBOutlet weak var lblweekDay2: UILabel!
    @IBOutlet weak var lblweekDayDate2: UILabel!
    @IBOutlet weak var btnWeekDay2: UIButton!
    
    @IBOutlet weak var lblweekDay3: UILabel!
    @IBOutlet weak var lblweekDayDate3: UILabel!
    @IBOutlet weak var btnWeekDay3: UIButton!
    
    
    @IBOutlet weak var lblweekDay4: UILabel!
    @IBOutlet weak var lblweekDayDate4: UILabel!
    @IBOutlet weak var btnWeekDay4: UIButton!
    
    @IBOutlet weak var lblweekDay5: UILabel!
    @IBOutlet weak var lblweekDayDate5: UILabel!
    @IBOutlet weak var btnWeekDay5: UIButton!
    
    @IBOutlet weak var lblweekDay6: UILabel!
    @IBOutlet weak var lblweekDayDate6: UILabel!
    @IBOutlet weak var btnWeekDay6: UIButton!
    
    @IBOutlet weak var lblweekDay7: UILabel!
    @IBOutlet weak var lblweekDayDate7: UILabel!
    @IBOutlet weak var btnWeekDay7: UIButton!
   
    @IBOutlet weak var weekDaysPopupView: UIView!
    
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var tblEvents: UITableView!
  
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtjobtitle: UITextField!
    @IBOutlet weak var btnDeleteEmployee: UIButton!
    
    @IBOutlet weak var userinformationView: UIView!
    @IBOutlet weak var timereportView: UIView!
    
    @IBOutlet weak var editTooltipView: UIView!
    
    @IBOutlet weak var selectedPayperiodLabel: UILabel!
    @IBOutlet weak var txtselectedPayperiod: UITextField!
    @IBOutlet weak var eventTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventCollectionviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewEvents: UICollectionView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var userinforStackview: UIView!
    
    var isFromEmployee = false
    var weekDates = [CustomDate]()
    var selectedWeekIndex = 0
    var selectedSettings:Settings = .userInfo
    var timesheetList = [Timesheet]()
    var payPeriodsData = [Payperiods]()
    var merchantData:Merchant?
    var selectedEmployeeID:String = ""
    var employeeDetails:EmployeeDetails?
    var selectedPayPeriod:Payperiods?
    var selectedPayPeriodIndex:Int = 0
    var editedTimeSheet = [Weeks]()
    @IBOutlet weak var picker: MyDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setTableview()
        setupMenu()
        if isFromEmployee{
            self.selectedSettings = .userInfo
            self.userinformationView.isHidden = false
            self.timereportView.isHidden = true
        }else{
            self.selectedSettings = .timeSheet
            self.userinformationView.isHidden = true
            self.timereportView.isHidden = false
        }
        
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtEmail.delegate = self
        self.txtjobtitle.delegate = self
        
        tblEvents.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [NSKeyValueObservingOptions.new], context: &myContext)
        collectionViewEvents.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [NSKeyValueObservingOptions.new], context: &collectionviewContext)
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchEmployeeDetails()
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &myContext,
            keyPath == #keyPath(UITextView.contentSize),
            let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
            print("contentSize:", contentSize)
            eventTableHeightConstraint.constant = tblEvents.contentSize.height
        }
        if context == &collectionviewContext,
            keyPath == #keyPath(UITextView.contentSize),
            let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
            print("contentSize:", contentSize)
            eventCollectionviewHeightConstraint.constant = collectionViewEvents.contentSize.height
        }
    }
    
    deinit {
        tblEvents.removeObserver(self, forKeyPath: #keyPath(UITextView.contentSize))
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
       
    }
    override func updateViewConstraints() {
        eventTableHeightConstraint.constant = tblEvents.contentSize.height
        super.updateViewConstraints()
    }
    private func setupMenu(){
        let controller = MenuViewController.instantiate()
        controller.delegate = self
        controller.selectedOption = .Employee
        menu = SideMenuNavigationController(rootViewController:controller)
        menu.navigationBar.isHidden = true
        menu.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView:view)
        SideMenuManager.default.leftMenuNavigationController = menu
        
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
    @IBAction func menuClicked(sender:UIButton){
        self.present(menu, animated: true, completion: {})
    }
    @IBAction func datePickerCancelClick(){
        self.datePickerView.isHidden = true
    }
    @IBAction func datePickerDoneClick(){
        self.timesheetTimeChange(sender:picker)
        self.datePickerView.isHidden = true
    }
    @IBAction func datePickerClearClick(){
        self.clearDate(sender:picker)
        self.datePickerView.isHidden = true
    }
    @objc func clearDate(sender:MyDatePicker){
        self.payPeriodsData[selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].events?[sender.eventIndex].timelineValue = ""
        self.payPeriodsData[selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].events?[sender.eventIndex].timelineTime = ""
       
        let indexpathCell = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        tblEvents.reloadRows(at: [indexpathCell], with: .none)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        collectionViewEvents.reloadItems(at: [indexpathCVCell])
        
        
        let indexpathHeader = IndexPath(row:0, section: sender.weekIndex)
        tblEvents.reloadRows(at: [indexpathHeader], with: .none)
    }
    func setData(){
        logoutView.isHidden = true
        lblusername.text = "\(Defaults.shared.currentUser?.empFirstname ?? "") \(Defaults.shared.currentUser?.empLastname ?? "")"

//        txtFirstName.isUserInteractionEnabled = false
//        txtLastName.isUserInteractionEnabled = false
//        txtEmail.isUserInteractionEnabled = false
//        txtjobtitle.isUserInteractionEnabled = false
//        tblEvents.isUserInteractionEnabled = false
       
        userinforStackview.alpha = 0.5
        
        saveView.isHidden = true
        editView.isUserInteractionEnabled = true
        editView.alpha = 1.0
    }
    private func fetchEmployeeDetails(){
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0,
           // "emp_id":"124",
            "empID":selectedEmployeeID
        ] as [String : Any]

      
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.fetchEmployees(), param: parameters, header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                print(res)
                let data = Mapper<EmployeeDetailsData>().map(JSONObject:res)
                self.employeeDetails = data?.employees?.first
                self.lblname.text = "\(self.employeeDetails?.empFirstname ?? "") \(self.employeeDetails?.empLastname ?? "")"
                self.txtFirstName.text = "\(self.employeeDetails?.empFirstname ?? "")"
                self.txtLastName.text = "\(self.employeeDetails?.empLastname ?? "")"
                self.txtEmail.text = "\(self.employeeDetails?.empWorkEmail ?? "")"
                self.txtjobtitle.text = "\(self.employeeDetails?.empJobTitle ?? "")"
                self.fetchEmployeeTimesheet()
            }else if let err = error{
                print(err)
            }
        }
    }
    @IBAction func weekDaySelected(sender:UIButton){
     
        for obj in (self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet ?? [Timesheet]()){
            if obj.date == weekDates[sender.tag - 1].datestring ?? ""{
                self.showAlert(alertType:.validation, message: "This day already added")
              
                return
            }
            
        }
       // print(weekDates[sender.tag - 1])
        let timesheet = Timesheet().addEventsForDay(date: weekDates[sender.tag - 1])
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet?.append(timesheet)
        
       // self.selectedPayPeriod?.weeks?[self.selectedWeekIndex].timesheet?.append(timesheet)
        self.tblEvents.reloadData()
        self.collectionViewEvents.reloadData()
        self.weekDaysPopupView.isHidden = true
       
    }
    @IBAction func backClickFromWeekPopup(sender:UIButton){
        self.weekDaysPopupView.isHidden = true
    }
    @IBAction func editClick(sender:UIButton){
        
        
        txtFirstName.isUserInteractionEnabled = true
        txtLastName.isUserInteractionEnabled = true
        txtEmail.isUserInteractionEnabled = true
        txtjobtitle.isUserInteractionEnabled = true
        tblEvents.isUserInteractionEnabled = true
       
        txtFirstName.alpha = 1.0
        txtLastName.alpha = 1.0
        txtEmail.alpha = 1.0
        txtjobtitle.alpha = 1.0
        userinforStackview.alpha = 1.0
        
        
        saveView.isHidden = false
        editView.isUserInteractionEnabled = false
        editView.alpha = 0.5
    }
    @IBAction func selectSettingType(sender:UIButton){
        
        let pickerArray = ["User Information","Timesheets"]
        IQKeyboardManager.shared.enable = false
        PickerView.sharedInstance.addPicker(self, onTextField: txtselectedPayperiod, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                 print(value)
                IQKeyboardManager.shared.enable = true
                if value == Settings.userInfo.rawValue{
                    self.selectedSettings = .userInfo
                    self.userinformationView.isHidden = false
                    self.timereportView.isHidden = true
                }else if value == Settings.timeSheet.rawValue{
                    self.selectedSettings = .timeSheet
                    self.userinformationView.isHidden = true
                    self.timereportView.isHidden = false
                }
             }
            self.txtFirstName.resignFirstResponder()
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
                self.selectedPayperiodLabel.text = str
                self.tblEvents.reloadData()
                self.collectionViewEvents.reloadData()
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
    func setTableview(){
        tblEvents.register(cellType: TimeReportCell.self)
     
        tblEvents.register(cellType: TimeReportHeaderCell.self)
     
        let TimeReportFooterCellnib = UINib(nibName: "TimeReportFooterCell", bundle: nil)
        tblEvents.register(TimeReportFooterCellnib, forHeaderFooterViewReuseIdentifier: "TimeReportFooterCell")
        tblEvents.estimatedRowHeight = 150.0
        tblEvents.rowHeight = UITableView.automaticDimension
        tblEvents.delegate = self
        tblEvents.dataSource = self
        tblEvents.separatorStyle = .none
        
        
        tblEvents.register(cellType: TimeReportCell.self)
        
        collectionViewEvents.delegate = self
        collectionViewEvents.dataSource = self
        collectionViewEvents.register(cellType: TimeReportCVCell.self)
        collectionViewEvents.register(cellType: TimeReportCVHeaderCell.self)
        let TimeReportVCFooterCellnib = UINib(nibName: "TimeReportFooterCell", bundle: nil)
    //    collectionViewEvents.register(TimeReportVCFooterCellnib, forCellWithReuseIdentifier: "TimeReportFooterCell")
        let numberOfColumn = 3
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical //depending upon direction of collection view

        self.collectionViewEvents?.setCollectionViewLayout(layout, animated: true)
        
     //   Utility.setupCollectionHorizontalUi(collection:collectionViewEvents, cellHeight: 350.0,numberofColumn:3.0,scrollDirection: UICollectionView.ScrollDirection.vertical.rawValue)
        
        
       

        
    }
    func fetchEmployeeTimesheet(){
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0,
           // "emp_id":"124",
            "empID":selectedEmployeeID
        ] as [String : Any]

        print(parameters)
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.timeReport(), param: parameters, header: Defaults.shared.header ?? ["":""]){ success, response, error in
            if let res = response{
                print(res)
                let data = Mapper<EmployeeTimeReportData>().map(JSONObject:res)
                self.payPeriodsData = data?.payperiods ?? [Payperiods]()
                self.merchantData = data?.merchant?.first
                self.selectedPayPeriod = self.payPeriodsData.first
                self.selectedPayPeriodIndex = 0
                let str = "\(self.selectedPayPeriod?.payperiodFrom1 ?? "") - \(self.selectedPayPeriod?.payperiodTo1 ?? "")"
                self.selectedPayperiodLabel.text = str
                self.tblEvents.reloadData()
                self.collectionViewEvents.reloadData()
            }else if let err = error{
                print(err)
            }
        }
    }
    @IBAction func saveClick(sender:UIButton){

//        txtFirstName.isUserInteractionEnabled = false
//        txtLastName.isUserInteractionEnabled = false
//        txtEmail.isUserInteractionEnabled = false
//        txtjobtitle.isUserInteractionEnabled = false
//        tblEvents.isUserInteractionEnabled = false

      
       //call save api
        var validationSucceess = true
        for week in self.selectedPayPeriod?.weeks ?? [Weeks](){
            for timeLine in week.timesheet ?? [Timesheet](){
                for event in timeLine.events ?? [Events](){
                    if self.submitTimeValidation(currentEvent:event, timesheet: timeLine){
                        validationSucceess = true
                    }else{
                        validationSucceess = false
                        break
                    }
                }
            }
        }
        if validationSucceess == false{
            txtFirstName.isUserInteractionEnabled = true
            txtLastName.isUserInteractionEnabled = true
            txtEmail.isUserInteractionEnabled = true
            txtjobtitle.isUserInteractionEnabled = true
            tblEvents.isUserInteractionEnabled = true
            
            txtFirstName.alpha = 1.0
            txtLastName.alpha = 1.0
            txtEmail.alpha = 1.0
            txtjobtitle.alpha = 1.0
            userinforStackview.alpha = 1.0
            saveView.isHidden = false
            editView.isUserInteractionEnabled = false
            editView.alpha = 0.5
            
        }else{
//            txtFirstName.isUserInteractionEnabled = false
//            txtLastName.isUserInteractionEnabled = false
//            txtEmail.isUserInteractionEnabled = false
//            txtjobtitle.isUserInteractionEnabled = false
//            tblEvents.isUserInteractionEnabled = false
            
            txtFirstName.alpha = 0.5
            txtLastName.alpha = 0.5
            txtEmail.alpha = 0.5
            txtjobtitle.alpha = 0.5
            userinforStackview.alpha = 0.5
            saveView.isHidden = true
            editView.isUserInteractionEnabled = true
            editView.alpha = 1.0
            updateEmployeeDetails()
        }

    }
    @IBAction func cancelClick(sender:UIButton){
//        txtFirstName.isUserInteractionEnabled = false
//        txtLastName.isUserInteractionEnabled = false
//        txtEmail.isUserInteractionEnabled = false
//        txtjobtitle.isUserInteractionEnabled = false
//        tblEvents.isUserInteractionEnabled = false
        userinforStackview.alpha = 0.5
        saveView.isHidden = true
        editView.isUserInteractionEnabled = true
        editView.alpha = 1.0
    }
    func updateEmployeeDetails(){
        var employee = UpdateEmployee()
        
        for (i,week) in (self.selectedPayPeriod?.weeks ?? [Weeks]()).enumerated(){
            for (j,_) in (week.timesheet ?? [Timesheet]()).enumerated(){
                let events = self.selectedPayPeriod?.weeks?[i].timesheet?[i].events?.filter({$0.timelineTime != ""})
                self.selectedPayPeriod?.weeks?[i].timesheet?[j].events = events
                print(self.selectedPayPeriod?.weeks?[i].timesheet?[i].events?.toJSON() ?? "")
            }
        }
        if let weeks = self.selectedPayPeriod?.weeks{
            self.editedTimeSheet = weeks
        }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self.editedTimeSheet.toJSON(), options: [])
            if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(jsonString)
                employee.timesheet = "\(jsonString)"
                //employee.timesheet = "[]"
            }
        } catch {
            print(error)
        }
        
        
        
        employee.empFirstname = txtFirstName.text!
        employee.empLastname = txtLastName.text!
        employee.empJobTitle = txtjobtitle.text!
        employee.empWorkEmail = txtEmail.text!
        employee.empID = self.employeeDetails?.empId?.stringValue ?? ""
        employee.timezone = Defaults.shared.currentUser?.merchantTimezone ?? ""
        employee.empPassword =  self.employeeDetails?.empPassword ?? ""
        updateEmployeeAPI(employee:employee)
    }
    
    func updateEmployeeAPI(employee:UpdateEmployee){
        print(employee.getParam())
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.updateEmployees(), param: employee.getParam(), header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                print(res)
            }else if let err = error{
                print(err)
            }
        }
    }
    func setWeekDays(days:[CustomDate]){
        self.weekDates = days
        for (i,weekDay) in days.enumerated(){
            switch i {
            case 0:
                self.lblweekDay1.text = weekDay.dayName ?? ""
                self.lblweekDayDate1.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay1.tag = 1
                break
            case 1:
                self.lblweekDay2.text = weekDay.dayName ?? ""
                self.lblweekDayDate2.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay2.tag = 2
                break
            case 2:
                self.lblweekDay3.text = weekDay.dayName ?? ""
                self.lblweekDayDate3.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay3.tag = 3
                break
            case 3:
                self.lblweekDay4.text = weekDay.dayName ?? ""
                self.lblweekDayDate4.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay4.tag = 4
                break
            case 4:
                self.lblweekDay5.text = weekDay.dayName ?? ""
                self.lblweekDayDate5.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay5.tag = 5
                break
            case 5:
                self.lblweekDay6.text = weekDay.dayName ?? ""
                self.lblweekDayDate6.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay6.tag = 6
                break
            case 6:
                self.lblweekDay7.text = weekDay.dayName ?? ""
                self.lblweekDayDate7.text = weekDay.datestring ?? ""
                self.btnWeekDay7.tag = 7
                break
            default:
                break
            }
        }
        self.weekDaysPopupView.isHidden = false
  
    }
    @objc func addTimesheetClicked(sender:UIButton) {

        let timesheet = Timesheet().addEventsForDay(date:nil)
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.tag].timesheet?.append(timesheet)
        
        self.tblEvents.reloadData()
        self.collectionViewEvents.reloadData()
        selectedWeekIndex = sender.tag
    }
    @objc func changeDateSelected(sender:MyButton) {

        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
        cell.weekDaysPopupView.isHidden = false
        cell.isChangeDate = true

        item.weekDaysPopupView.isHidden = false
        item.isChangeDate = true
    }
    @objc func moreOptionClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
       // cell.mainView.isHidden = true
        cell.addshiftMainView.isHidden = false
        item.addshiftMainView.isHidden = false
    }
    
    @objc func addShiftClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
      //  cell.mainView.isHidden = false
        cell.addshiftMainView.isHidden = true
        item.addshiftMainView.isHidden = true
        
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].addShiftForDay()
        self.tblEvents.reloadRows(at:[indexpath], with: .none)
        collectionViewEvents.reloadItems(at: [indexpathCVCell])
    }
    @objc func addBreakClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
      //  cell.mainView.isHidden = false
        cell.addshiftMainView.isHidden = true
        item.addshiftMainView.isHidden = true
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].addBreaksForDay()
       
        self.tblEvents.reloadRows(at:[indexpath], with: .none)
        collectionViewEvents.reloadItems(at: [indexpathCVCell])
    }
    @objc func deleteSheetClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
        cell.addshiftMainView.isHidden = true
        item.addshiftMainView.isHidden = true
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?.remove(at:sender.timeSheetIndex)
       
        self.tblEvents.reloadData()
        collectionViewEvents.reloadData()
    }
    @objc func addShiftMainViewBack(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell

        cell.addshiftMainView.isHidden = true
        
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
        item.addshiftMainView.isHidden = true
    }
    @objc func selectWeekdayViewBack(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        if let cell = tblEvents.cellForRow(at: indexpath) as? TimeReportCell{
            cell.weekDaysPopupView.isHidden = true
            if cell.isChangeDate == false{
                self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet?.remove(at:sender.timeSheetIndex)
                
            }
            self.tblEvents.reloadData()
        }
      
        
        
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        if let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as? TimeReportCVCell{
            item.weekDaysPopupView.isHidden = true
            
           
            
            if item.isChangeDate == false{
                self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet?.remove(at:sender.timeSheetIndex)
            }
            
          
            collectionViewEvents.reloadData()
        }
       
       
    }
    @objc func weekDaySelectClicked(sender:MyButton){
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        if let cell = tblEvents.cellForRow(at: indexpath) as? TimeReportCell{
            self.weekDates = cell.weekDates
            if cell.isChangeDate{
                self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].date = weekDates[sender.tag - 1].datestring ?? ""
                let events = self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].events ?? [Events]()
                
                for (i,_) in events.enumerated(){
                    events[i].timelineDate = weekDates[sender.tag - 1].datestring ?? ""
                }
                self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].events = events
                print(self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].events ?? [Events]())
                cell.weekDaysPopupView.isHidden = true
                self.tblEvents.reloadRows(at: [indexpath], with: .none)
                return
            }
        }
        guard let cell = tblEvents.cellForRow(at: indexpath) as? TimeReportCell else {return}
        self.weekDates = cell.weekDates
        for obj in (self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet ?? [Timesheet]()){
            if obj.date == weekDates[sender.tag - 1].datestring ?? ""{
               
                self.showAlert(alertType:.validation, message: "This day already added")
                return
            }
            
        }
     
        let timesheet = Timesheet().addEventsForDay(date: weekDates[sender.tag - 1])
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet?[sender.timeSheetIndex] = timesheet
    
        self.tblEvents.reloadData()
        self.collectionViewEvents.reloadData()
        self.weekDaysPopupView.isHidden = true
       
    }
    @IBAction func editTooltipOkClicked(){
        self.editTooltipView.isHidden = true
    }
}

extension EmployeeTimeReportVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if editView.alpha == 1.0{
            editTooltipView.isHidden = false
            textField.resignFirstResponder()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if editView.alpha == 1.0{
            //show tooltip
            return false
        }
        return true
        
    }
    
}
extension EmployeeTimeReportVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let weeks = self.selectedPayPeriod?.weeks{
            let count = weeks.count
           
            return count
            
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  (selectedPayPeriod?.weeks?[section].timesheet?.count ?? 0) + 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0{
            return CGSize(width: (self.collectionViewEvents.width ), height: 270.0)
        }else{
            return CGSize(width: (self.collectionViewEvents.width / 3.0 ) - 8.0, height: 425.0)
            if indexPath.item == 6{
               
            }else{
                return CGSize(width: (self.collectionViewEvents.width / 3.0 ) - 5, height: 425.0)
            }
           
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0{
            let week =  self.selectedPayPeriod?.weeks?[indexPath.section]
            let cell: TimeReportCVHeaderCell = collectionViewEvents.dequeueReusableCell(for: indexPath)
            let weekFrom = "\(week?.weekFrom ?? "")".toDate()
            let weekTo = "\(week?.weekTo ?? "")".toDate()
            let startweek =  weekFrom.getString(formatter:DateTimeFormat.MMM_dd_yyyy.rawValue)
            let endweek =  weekTo.getString(formatter:DateTimeFormat.MMM_dd_yyyy.rawValue)
            cell.timeLabel.text = "\(startweek) - \(endweek)"
            
            cell.overTimeLabel.text = "0.00 hrs"
            let tuple = self.calculateTotalTimeForWeek(sectionIndex:indexPath.section)
           // print("Total Time \(tuple.hours).\(tuple.leftMinutes) hrs")
        
            
            cell.totalTimeLabel.text = "\(tuple.hours)." + String(format: "%02d hrs", ((tuple.leftMinutes * 100)/60 ))
            let totalWeeklyMinutes:Int = (self.merchantData?.merchantWeeklyOvertime as! Int * 60)
           
            //regular Hours
            if tuple.totalMinutes > totalWeeklyMinutes{
                //overtime
                let overtimeMinutes = tuple.totalMinutes - totalWeeklyMinutes
                let overtimetuple = minutesToHoursAndMinutes(overtimeMinutes)
                cell.overTimeLabel.text = "\(overtimetuple.hours)." + String(format: "%02d hrs", ((overtimetuple.leftMinutes * 100)/60 ))
                
                //regularhours
                let regularMinutes = tuple.totalMinutes - overtimeMinutes
                let regulartuple = minutesToHoursAndMinutes(regularMinutes)
                
                cell.regularHoursLabel.text = "\(regulartuple.hours)." + String(format: "%02d hrs", ((regulartuple.leftMinutes * 100)/60 ))
               
            }else{
                //regularhours
                let regularMinutes = tuple.totalMinutes
                let regulartuple = minutesToHoursAndMinutes(regularMinutes)
                cell.regularHoursLabel.text =  "\(regulartuple.hours)." + String(format: "%02d hrs", ((regulartuple.leftMinutes * 100)/60 ))
               
            }
            cell.btnAddTimesheet.addTarget(self, action:#selector(self.addTimesheetClicked(sender:)), for: .touchUpInside)
            cell.btnAddTimesheet.tag = indexPath.section
            if merchantData?.merchantWeeklyOvertimeEnabled ?? "" == "Y"{
                cell.weeklyOverTimeView.isHidden = false
            }else{
                cell.weeklyOverTimeView.isHidden = true
            }
           
           
            return cell

        }else{
            let cell: TimeReportCVCell = collectionViewEvents.dequeueReusableCell(for: indexPath)
            let timesheet =  selectedPayPeriod?.weeks?[indexPath.section].timesheet?[indexPath.row - 1]
          
            let date = (timesheet?.date ?? "").toDate()
            let weekday = date.getTodayWeekDay()
            let dateString = date.getString()
            cell.dateLabel.text = dateString
            cell.dayLabel.text = weekday
            
            cell.btnDate.addTarget(self, action:#selector(self.changeDateSelected(sender:)), for: .touchUpInside)
            cell.btnDate.timeSheetIndex = indexPath.row - 1
            cell.btnDate.weekIndex = indexPath.section
            
           
            for subview in cell.stackView.subviews{
                subview.removeFromSuperview()
            }
           
            for (i,event) in (timesheet?.events ?? [Events]()).enumerated(){
                let timeReportViewNew = TimesheetView()
                
                cell.stackView.addArrangedSubview(timeReportViewNew)
                timeReportViewNew.translatesAutoresizingMaskIntoConstraints = false
                let heightConstraint = NSLayoutConstraint(item: timeReportViewNew, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
                timeReportViewNew.addConstraints([heightConstraint])
              
              
              let timeLineEvent = event.timelineEvent ?? ""
              
                
              if timeLineEvent == "I"{
                  timeReportViewNew.titleLabel.text = "Shift Start:"
                  timeReportViewNew.barView.backgroundColor = UIColor.startShiftColor
                  
                
              }else if timeLineEvent == "O"{
                  timeReportViewNew.titleLabel.text = "Shift End:"
                  timeReportViewNew.barView.backgroundColor = UIColor.endShiftColor
                 
              }else if timeLineEvent == "B"{
                  timeReportViewNew.titleLabel.text = "Break Start:"
                  timeReportViewNew.barView.backgroundColor = UIColor.breakStartColor
                
              }else if timeLineEvent == "S"{
                  timeReportViewNew.titleLabel.text = "Break End:"
                  timeReportViewNew.barView.backgroundColor = UIColor.breakEndColor
                 
              }
             timeReportViewNew.btnTimeEdit.addTarget(self, action:#selector(self.changeTimeClick(sender:)), for: .touchUpInside)
             timeReportViewNew.btnTimeEdit.timeSheetIndex = indexPath.row - 1
             timeReportViewNew.btnTimeEdit.weekIndex = indexPath.section
             timeReportViewNew.btnTimeEdit.eventIndex = i
             timeReportViewNew.timeLabel.text = event.timelineValue
             timeReportViewNew.timeLabel.tag = i
            if timeReportViewNew.timeLabel.text == ""{
                timeReportViewNew.timeLabel.text = "--:-- --"
            }
         }
            
            let workTime = self.calculateTotalTime(events:timesheet?.events ?? [Events]())
            let tuple = minutesToHoursAndMinutes(workTime)
            
            cell.totalTimeLabel.text = "\(tuple.hours)." + String(format: "%02d hrs", ((tuple.leftMinutes * 100)/60 ))
            
            //regular Hours
            let totalDailyMinutes:Int = (self.merchantData?.merchantDailyOvertime as! Int * 60)
            if merchantData?.merchantDailyOvertimeEnabled ?? "" == "Y"{
            }else{
                
            }
            cell.regularHoursLabel.text = "0.00 hrs"
            cell.overTimeLabel.text = "0.00 hrs"
           
            if workTime > totalDailyMinutes{
                //overtime
                if merchantData?.merchantDailyOvertimeEnabled ?? "" == "Y"{
                    let overtimeMinutes = workTime - totalDailyMinutes
                    let overtimetuple = minutesToHoursAndMinutes(overtimeMinutes)
                   
                    cell.overTimeLabel.text =  "\(overtimetuple.hours)." + String(format: "%02d hrs", ((overtimetuple.leftMinutes * 100)/60 ))
                    
                    let regularMinutes = workTime - overtimeMinutes
                    let regulartuple = minutesToHoursAndMinutes(regularMinutes)
                   
                    cell.regularHoursLabel.text =  "\(regulartuple.hours)." + String(format: "%02d hrs", ((regulartuple.leftMinutes * 100)/60 ))
                }else{
                    let regularMinutes = workTime
                    let regulartuple = minutesToHoursAndMinutes(regularMinutes)
                    
                    cell.regularHoursLabel.text = "\(regulartuple.hours)." + String(format: "%02d hrs", ((regulartuple.leftMinutes * 100)/60 ))
                }
                
            }else{
                let regularMinutes = workTime
                let regulartuple = minutesToHoursAndMinutes(regularMinutes)
                
                cell.regularHoursLabel.text = "\(regulartuple.hours)." + String(format: "%02d hrs", ((regulartuple.leftMinutes * 100)/60 ))
            }
            
            cell.btnMore.addTarget(self, action:#selector(self.moreOptionClicked(sender:)), for: .touchUpInside)
            cell.btnMore.timeSheetIndex = indexPath.row - 1
            cell.btnMore.weekIndex = indexPath.section
            
            cell.btnAddShift.addTarget(self, action:#selector(self.addShiftClicked(sender:)), for: .touchUpInside)
            cell.btnAddShift.tag = indexPath.section
            cell.btnAddShift.timeSheetIndex = indexPath.row - 1
            cell.btnAddShift.weekIndex = indexPath.section
            
            cell.btnAddbreak.addTarget(self, action:#selector(self.addBreakClicked(sender:)), for: .touchUpInside)
            cell.btnAddbreak.tag = indexPath.section
            cell.btnAddbreak.timeSheetIndex = indexPath.row - 1
            cell.btnAddbreak.weekIndex = indexPath.section
            
            cell.btnDeleteTimesheet.addTarget(self, action:#selector(self.deleteSheetClicked(sender:)), for: .touchUpInside)
            cell.btnDeleteTimesheet.tag = indexPath.section
            cell.btnDeleteTimesheet.timeSheetIndex = indexPath.row - 1
            cell.btnDeleteTimesheet.weekIndex = indexPath.section
            
            cell.btnBack.addTarget(self, action:#selector(self.addShiftMainViewBack(sender:)), for: .touchUpInside)
            cell.btnBack.tag = indexPath.section
            cell.btnBack.timeSheetIndex = indexPath.row - 1
            cell.btnBack.weekIndex = indexPath.section
            
            cell.btncloseWeekday.addTarget(self, action:#selector(self.selectWeekdayViewBack(sender:)), for: .touchUpInside)
            cell.btncloseWeekday.tag = indexPath.section
            cell.btncloseWeekday.timeSheetIndex = indexPath.row - 1
            cell.btncloseWeekday.weekIndex = indexPath.section
            
            cell.btnBackWeekday.addTarget(self, action:#selector(self.selectWeekdayViewBack(sender:)), for: .touchUpInside)
            cell.btnBackWeekday.tag = indexPath.section
            cell.btnBackWeekday.timeSheetIndex = indexPath.row - 1
            cell.btnBackWeekday.weekIndex = indexPath.section
            
            
            
            let selectedWeek = selectedPayPeriod?.weeks?[indexPath.section]
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = kDateGetFormat
            let fromDate = dateFormatter.date(from:selectedWeek?.weekFrom ??
                                              "") ?? Date()
            let toDate = dateFormatter.date(from:selectedWeek?.weekTo ??
            "") ?? Date()
            let dates = (Date.dates(from:fromDate, to: toDate))
            print(dates)
            cell.setWeekDays(days:dates)
            self.weekDates = dates
            cell.weekDates = dates
            if timesheet?.date == ""{
                cell.weekDaysPopupView.isHidden = false
            }else{
                cell.weekDaysPopupView.isHidden = true
            }
            cell.btnWeekDay1.timeSheetIndex = indexPath.row - 1
            cell.btnWeekDay1.weekIndex = indexPath.section
           
            cell.btnWeekDay2.timeSheetIndex = indexPath.row - 1
            cell.btnWeekDay2.weekIndex = indexPath.section
           
            cell.btnWeekDay3.timeSheetIndex = indexPath.row - 1
            cell.btnWeekDay3.weekIndex = indexPath.section
           
            cell.btnWeekDay4.timeSheetIndex = indexPath.row - 1
            cell.btnWeekDay4.weekIndex = indexPath.section
           
            cell.btnWeekDay5.timeSheetIndex = indexPath.row - 1
            cell.btnWeekDay5.weekIndex = indexPath.section
           
            cell.btnWeekDay6.timeSheetIndex = indexPath.row - 1
            cell.btnWeekDay6.weekIndex = indexPath.section
           
            cell.btnWeekDay7.timeSheetIndex = indexPath.row - 1
            cell.btnWeekDay7.weekIndex = indexPath.section
           
            
            cell.btnWeekDay1.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
            cell.btnWeekDay2.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
            cell.btnWeekDay3.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
            cell.btnWeekDay4.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
            cell.btnWeekDay5.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
            cell.btnWeekDay6.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
            cell.btnWeekDay7.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
            if merchantData?.merchantDailyOvertimeEnabled ?? "" == "Y"{
                cell.dailyOverTimeView.isHidden = false
            }else{
                cell.dailyOverTimeView.isHidden = true
            }
           // cell.backgroundColor = .green
            return cell
        }
        
    
    }
    
}
extension EmployeeTimeReportVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblEvents{
            if let weeks = self.selectedPayPeriod?.weeks{
                let count = weeks.count
               
                return count
                
            }else{
                return 0
            }
        }else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (selectedPayPeriod?.weeks?[section].timesheet?.count ?? 0) + 1
    }
   
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            if indexPath.row == 0{
                let week =  self.selectedPayPeriod?.weeks?[indexPath.section]
                let cell: TimeReportHeaderCell = tableView.dequeueReusableCell(for: indexPath)
                let weekFrom = "\(week?.weekFrom ?? "")".toDate()
                let weekTo = "\(week?.weekTo ?? "")".toDate()
                let startweek =  weekFrom.getString(formatter:DateTimeFormat.MMM_dd_yyyy.rawValue)
                let endweek =  weekTo.getString(formatter:DateTimeFormat.MMM_dd_yyyy.rawValue)
                cell.timeLabel.text = "\(startweek) - \(endweek)"
                
                cell.overTimeLabel.text = "0.00 hrs"
                let tuple = self.calculateTotalTimeForWeek(sectionIndex:indexPath.section)
               // print("Total Time \(tuple.hours).\(tuple.leftMinutes) hrs")
            
                
                cell.totalTimeLabel.text = "\(tuple.hours)." + String(format: "%02d hrs", ((tuple.leftMinutes * 100)/60 ))
                let totalWeeklyMinutes:Int = (self.merchantData?.merchantWeeklyOvertime as! Int * 60)
               
                //regular Hours
                if tuple.totalMinutes > totalWeeklyMinutes{
                    //overtime
                    let overtimeMinutes = tuple.totalMinutes - totalWeeklyMinutes
                    let overtimetuple = minutesToHoursAndMinutes(overtimeMinutes)
                    cell.overTimeLabel.text = "\(overtimetuple.hours)." + String(format: "%02d hrs", ((overtimetuple.leftMinutes * 100)/60 ))
                    
                    //regularhours
                    let regularMinutes = tuple.totalMinutes - overtimeMinutes
                    let regulartuple = minutesToHoursAndMinutes(regularMinutes)
                    
                    cell.regularHoursLabel.text = "\(regulartuple.hours)." + String(format: "%02d hrs", ((regulartuple.leftMinutes * 100)/60 ))
                   
                }else{
                    //regularhours
                    let regularMinutes = tuple.totalMinutes
                    let regulartuple = minutesToHoursAndMinutes(regularMinutes)
                    cell.regularHoursLabel.text =  "\(regulartuple.hours)." + String(format: "%02d hrs", ((regulartuple.leftMinutes * 100)/60 ))
                   
                }
                cell.btnAddTimesheet.addTarget(self, action:#selector(self.addTimesheetClicked(sender:)), for: .touchUpInside)
                cell.btnAddTimesheet.tag = indexPath.section
                if merchantData?.merchantWeeklyOvertimeEnabled ?? "" == "Y"{
                    cell.weeklyOverTimeView.isHidden = false
                }else{
                    cell.weeklyOverTimeView.isHidden = true
                }
               
                cell.selectionStyle = .none
                return cell

            }else{
                let cell: TimeReportCell = tableView.dequeueReusableCell(for: indexPath)
                let timesheet =  selectedPayPeriod?.weeks?[indexPath.section].timesheet?[indexPath.row - 1]
              
                let date = (timesheet?.date ?? "").toDate()
                let weekday = date.getTodayWeekDay()
                let dateString = date.getString()
                cell.dateLabel.text = dateString
                cell.dayLabel.text = weekday
                
                cell.btnDate.addTarget(self, action:#selector(self.changeDateSelected(sender:)), for: .touchUpInside)
                cell.btnDate.timeSheetIndex = indexPath.row - 1
                cell.btnDate.weekIndex = indexPath.section
                
               
                for subview in cell.stackView.subviews{
                    subview.removeFromSuperview()
                }
               
                for (i,event) in (timesheet?.events ?? [Events]()).enumerated(){
                    let timeReportViewNew = TimesheetView()
                    
                    cell.stackView.addArrangedSubview(timeReportViewNew)
                    timeReportViewNew.translatesAutoresizingMaskIntoConstraints = false
                    let heightConstraint = NSLayoutConstraint(item: timeReportViewNew, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
                    timeReportViewNew.addConstraints([heightConstraint])
                  
                  
                  let timeLineEvent = event.timelineEvent ?? ""
                  
                    
                  if timeLineEvent == "I"{
                      timeReportViewNew.titleLabel.text = "Shift Start:"
                      timeReportViewNew.barView.backgroundColor = UIColor.startShiftColor
                      
                    
                  }else if timeLineEvent == "O"{
                      timeReportViewNew.titleLabel.text = "Shift End:"
                      timeReportViewNew.barView.backgroundColor = UIColor.endShiftColor
                     
                  }else if timeLineEvent == "B"{
                      timeReportViewNew.titleLabel.text = "Break Start:"
                      timeReportViewNew.barView.backgroundColor = UIColor.breakStartColor
                    
                  }else if timeLineEvent == "S"{
                      timeReportViewNew.titleLabel.text = "Break End:"
                      timeReportViewNew.barView.backgroundColor = UIColor.breakEndColor
                     
                  }
                 timeReportViewNew.btnTimeEdit.addTarget(self, action:#selector(self.changeTimeClick(sender:)), for: .touchUpInside)
                 timeReportViewNew.btnTimeEdit.timeSheetIndex = indexPath.row - 1
                 timeReportViewNew.btnTimeEdit.weekIndex = indexPath.section
                 timeReportViewNew.btnTimeEdit.eventIndex = i
                 timeReportViewNew.timeLabel.text = event.timelineValue
                 timeReportViewNew.timeLabel.tag = i
                if timeReportViewNew.timeLabel.text == ""{
                    timeReportViewNew.timeLabel.text = "--:-- --"
                }
             }
                
                let workTime = self.calculateTotalTime(events:timesheet?.events ?? [Events]())
                let tuple = minutesToHoursAndMinutes(workTime)
                
                cell.totalTimeLabel.text = "\(tuple.hours)." + String(format: "%02d hrs", ((tuple.leftMinutes * 100)/60 ))
                
                //regular Hours
                let totalDailyMinutes:Int = (self.merchantData?.merchantDailyOvertime as! Int * 60)
                if merchantData?.merchantDailyOvertimeEnabled ?? "" == "Y"{
                }else{
                    
                }
                cell.regularHoursLabel.text = "0.00 hrs"
                cell.overTimeLabel.text = "0.00 hrs"
               
                if workTime > totalDailyMinutes{
                    //overtime
                    if merchantData?.merchantDailyOvertimeEnabled ?? "" == "Y"{
                        let overtimeMinutes = workTime - totalDailyMinutes
                        let overtimetuple = minutesToHoursAndMinutes(overtimeMinutes)
                       
                        cell.overTimeLabel.text =  "\(overtimetuple.hours)." + String(format: "%02d hrs", ((overtimetuple.leftMinutes * 100)/60 ))
                        
                        let regularMinutes = workTime - overtimeMinutes
                        let regulartuple = minutesToHoursAndMinutes(regularMinutes)
                       
                        cell.regularHoursLabel.text =  "\(regulartuple.hours)." + String(format: "%02d hrs", ((regulartuple.leftMinutes * 100)/60 ))
                    }else{
                        let regularMinutes = workTime
                        let regulartuple = minutesToHoursAndMinutes(regularMinutes)
                        
                        cell.regularHoursLabel.text = "\(regulartuple.hours)." + String(format: "%02d hrs", ((regulartuple.leftMinutes * 100)/60 ))
                    }
                    
                }else{
                    let regularMinutes = workTime
                    let regulartuple = minutesToHoursAndMinutes(regularMinutes)
                    
                    cell.regularHoursLabel.text = "\(regulartuple.hours)." + String(format: "%02d hrs", ((regulartuple.leftMinutes * 100)/60 ))
                }
                
                cell.btnMore.addTarget(self, action:#selector(self.moreOptionClicked(sender:)), for: .touchUpInside)
                cell.btnMore.timeSheetIndex = indexPath.row - 1
                cell.btnMore.weekIndex = indexPath.section
                
                cell.btnAddShift.addTarget(self, action:#selector(self.addShiftClicked(sender:)), for: .touchUpInside)
                cell.btnAddShift.tag = indexPath.section
                cell.btnAddShift.timeSheetIndex = indexPath.row - 1
                cell.btnAddShift.weekIndex = indexPath.section
                
                cell.btnAddbreak.addTarget(self, action:#selector(self.addBreakClicked(sender:)), for: .touchUpInside)
                cell.btnAddbreak.tag = indexPath.section
                cell.btnAddbreak.timeSheetIndex = indexPath.row - 1
                cell.btnAddbreak.weekIndex = indexPath.section
                
                cell.btnDeleteTimesheet.addTarget(self, action:#selector(self.deleteSheetClicked(sender:)), for: .touchUpInside)
                cell.btnDeleteTimesheet.tag = indexPath.section
                cell.btnDeleteTimesheet.timeSheetIndex = indexPath.row - 1
                cell.btnDeleteTimesheet.weekIndex = indexPath.section
                
                cell.btnBack.addTarget(self, action:#selector(self.addShiftMainViewBack(sender:)), for: .touchUpInside)
                cell.btnBack.tag = indexPath.section
                cell.btnBack.timeSheetIndex = indexPath.row - 1
                cell.btnBack.weekIndex = indexPath.section
                
                cell.btncloseWeekday.addTarget(self, action:#selector(self.selectWeekdayViewBack(sender:)), for: .touchUpInside)
                cell.btncloseWeekday.tag = indexPath.section
                cell.btncloseWeekday.timeSheetIndex = indexPath.row - 1
                cell.btncloseWeekday.weekIndex = indexPath.section
                
                cell.btnBackWeekday.addTarget(self, action:#selector(self.selectWeekdayViewBack(sender:)), for: .touchUpInside)
                cell.btnBackWeekday.tag = indexPath.section
                cell.btnBackWeekday.timeSheetIndex = indexPath.row - 1
                cell.btnBackWeekday.weekIndex = indexPath.section
                
                cell.selectionStyle = .none
                
                let selectedWeek = selectedPayPeriod?.weeks?[indexPath.section]
                let dateFormatter = DateFormatter()

                dateFormatter.dateFormat = kDateGetFormat
                let fromDate = dateFormatter.date(from:selectedWeek?.weekFrom ??
                                                  "") ?? Date()
                let toDate = dateFormatter.date(from:selectedWeek?.weekTo ??
                "") ?? Date()
                let dates = (Date.dates(from:fromDate, to: toDate))
                print(dates)
                cell.setWeekDays(days:dates)
                self.weekDates = dates
                cell.weekDates = dates
                if timesheet?.date == ""{
                    cell.weekDaysPopupView.isHidden = false
                }else{
                    cell.weekDaysPopupView.isHidden = true
                }
                cell.btnWeekDay1.timeSheetIndex = indexPath.row - 1
                cell.btnWeekDay1.weekIndex = indexPath.section
               
                cell.btnWeekDay2.timeSheetIndex = indexPath.row - 1
                cell.btnWeekDay2.weekIndex = indexPath.section
               
                cell.btnWeekDay3.timeSheetIndex = indexPath.row - 1
                cell.btnWeekDay3.weekIndex = indexPath.section
               
                cell.btnWeekDay4.timeSheetIndex = indexPath.row - 1
                cell.btnWeekDay4.weekIndex = indexPath.section
               
                cell.btnWeekDay5.timeSheetIndex = indexPath.row - 1
                cell.btnWeekDay5.weekIndex = indexPath.section
               
                cell.btnWeekDay6.timeSheetIndex = indexPath.row - 1
                cell.btnWeekDay6.weekIndex = indexPath.section
               
                cell.btnWeekDay7.timeSheetIndex = indexPath.row - 1
                cell.btnWeekDay7.weekIndex = indexPath.section
               
                
                cell.btnWeekDay1.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
                cell.btnWeekDay2.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
                cell.btnWeekDay3.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
                cell.btnWeekDay4.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
                cell.btnWeekDay5.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
                cell.btnWeekDay6.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
                cell.btnWeekDay7.addTarget(self, action: #selector(self.weekDaySelectClicked(sender:)), for: .touchUpInside)
                if merchantData?.merchantDailyOvertimeEnabled ?? "" == "Y"{
                    cell.dailyOverTimeView.isHidden = false
                }else{
                    cell.dailyOverTimeView.isHidden = true
                }
                return cell
            }
       
    }
    func calculateTotalTimeForWeek(sectionIndex:Int)->(hours: Int , leftMinutes: Int , totalMinutes:Int ){
      
        let week =  selectedPayPeriod?.weeks?[sectionIndex]
        var TotalWorkTime = 0
        for timesheet in week?.timesheet ?? [Timesheet](){
            
            var startTime:Date!
            var breakstartTime:Date!
            var breakEndTime:Date!
            var endTime:Date!
            
            for event in timesheet.events ?? [Events](){
                    
                     let timeLineEvent = event.timelineEvent ?? ""
                     if timeLineEvent == "I"{
                        startTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
                    }else if timeLineEvent == "O"{
                        endTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
                    }else if timeLineEvent == "B"{
                        breakstartTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
                    }else if timeLineEvent == "S"{
                        breakEndTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
                    }
               
            }
            var breakTime = 0
            var totalWorkTime = 0
            if breakstartTime != nil && breakEndTime != nil{
                breakTime = self.differenceBetweenDates(from:breakstartTime, toDate: breakEndTime)
            }
            if startTime != nil && endTime != nil{
                totalWorkTime = self.differenceBetweenDates(from:startTime, toDate: endTime)
            }
           // let workTime = totalWorkTime - breakTime
            let workTime = self.calculateTotalTime(events:timesheet.events ?? [Events]())
            TotalWorkTime = TotalWorkTime + workTime
           
        }
        let tuple = minutesToHoursAndMinutes(TotalWorkTime)
        return (tuple.hours, tuple.leftMinutes ,TotalWorkTime)
       
    }
    func calculateTotalTime(events:[Events])->Int{
        var totalMinutes = 0
        for (i,event) in events.enumerated(){
            if events.count > i + 1{
                if (events[i + 1].timelineTime != "") {
                    if (((events[i].timelineEvent ?? "") == "I" && (events[i + 1].timelineEvent ?? "") == "B") ||
                        ((events[i].timelineEvent ?? "") == "S" && (events[i + 1].timelineEvent ?? "") == "O") ||
                        ((events[i].timelineEvent ?? "") == "S" && (events[i + 1].timelineEvent ?? "") == "B") ||
                        ((events[i].timelineEvent ?? "") == "I" && (events[i + 1].timelineEvent ?? "") == "O")) {
                        
                        if (event.timelineTime != "") {

                            let start = event.timelineValue ?? ""
                            let end = events[i + 1].timelineValue ?? ""
                          //  let startDate = start.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
                          //  let endDate = end.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
                            let startDate = start.toDate(dateFormat:DateTimeFormat.time.rawValue)
                            let endDate = end.toDate(dateFormat:DateTimeFormat.time.rawValue)
                            let duration = self.differenceBetweenDates(from:startDate, toDate: endDate)
                            totalMinutes = totalMinutes + duration
                        }
                        
                    }
                }
            }
        }
        return totalMinutes
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      //  self.viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    @objc func changeTimeClick(sender:MyButton) {
        
        if saveView.isHidden{
            return
        }
        let week = self.selectedPayPeriod?.weeks?[sender.weekIndex]
        let timesheet = week?.timesheet?[sender.timeSheetIndex]
        let event = timesheet?.events?[sender.eventIndex]
        
        let time = "\(event?.timelineTime ?? "")"
      
        picker.datePickerMode = UIDatePicker.Mode.time
    
        let dateFormatter = DateFormatter()
      
        dateFormatter.dateFormat = kMMddYYYYhhmmss
        picker.setDate(dateFormatter.date(from:time) ?? Date(), animated: true)
        picker.eventIndex = sender.eventIndex
        picker.timeSheetIndex = sender.timeSheetIndex
        picker.weekIndex = sender.weekIndex
        self.datePickerView.isHidden = false
 
    }
  

    @objc func timesheetTimeChange(sender:MyDatePicker){
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = kMMddYYYYhhmmss
        print(dateFormatter.string(from: sender.date))
        dateFormatter.dateFormat = timeFormat
      

        self.datePickerView.isHidden = true
        
      /*  if self.timeValidation(time:timeLineTime,weekIndex:sender.weekIndex,timeSheetIndex:sender.timeSheetIndex,eventIndex:sender.eventIndex){
            //do after everything is fine
           
        } */
        self.setUpdatedTimesheetData(date:sender.date,weekIndex:sender.weekIndex,timeSheetIndex:sender.timeSheetIndex,eventIndex:sender.eventIndex)
        
       
    }
    func setUpdatedTimesheetData(date:Date,weekIndex:Int,timeSheetIndex:Int,eventIndex:Int){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = kMMddYYYYhhmmss
        print(dateFormatter.string(from: date))
        let week = self.selectedPayPeriod?.weeks?[weekIndex]
        let timesheet = week?.timesheet?[timeSheetIndex]
        var event = timesheet?.events?[eventIndex]
        print(event?.timelineValue ?? "")
        let timeLineTime = dateFormatter.string(from: date)
        dateFormatter.dateFormat = timeFormat
        let timeLineValue = dateFormatter.string(from: date)
        print(event?.toJSON() ?? "")
       
        self.payPeriodsData[selectedPayPeriodIndex].weeks?[weekIndex].timesheet?[timeSheetIndex].events?[eventIndex].timelineValue = timeLineValue
        self.payPeriodsData[selectedPayPeriodIndex].weeks?[weekIndex].timesheet?[timeSheetIndex].events?[eventIndex].timelineTime = timeLineTime
       
        event = self.selectedPayPeriod?.weeks?[weekIndex].timesheet?[timeSheetIndex].events?[eventIndex]
        
        let eventArray = self.payPeriodsData[selectedPayPeriodIndex].weeks?[weekIndex].timesheet?[timeSheetIndex].events ?? [Events]()
        
        let emptyArray = eventArray.filter{$0.timelineValue == ""}
        let filledArray = eventArray.filter{$0.timelineValue != ""}
        let timesortedArray = filledArray.sorted { ($0.timelineValue ?? "").toFullTime().localizedStandardCompare(($1.timelineValue ?? "").toFullTime()) == .orderedAscending }
        
        var finalEvents:[Events] = timesortedArray
        finalEvents.append(contentsOf:emptyArray)
        
        self.payPeriodsData[selectedPayPeriodIndex].weeks?[weekIndex].timesheet?[timeSheetIndex].events = finalEvents
        
        self.selectedPayPeriod = self.payPeriodsData[selectedPayPeriodIndex]
        
        let indexpath = IndexPath(row:timeSheetIndex + 1, section: weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
        for subview in cell.allSubViewsOf(type:UILabel.self){
            if subview.tag == eventIndex{
                subview.text = event?.timelineValue
            }
        }
        let indexpathCell = IndexPath(row:timeSheetIndex + 1, section: weekIndex)
        let indexpathCVCell = IndexPath(item: timeSheetIndex + 1, section: weekIndex)
        tblEvents.reloadRows(at: [indexpathCell], with: .none)
        collectionViewEvents.reloadItems(at: [indexpathCVCell])
        
        let indexpathHeader = IndexPath(row:0, section: weekIndex)
        tblEvents.reloadRows(at: [indexpathHeader], with: .none)
        
    }
    func timeValidation(time:String,weekIndex:Int,timeSheetIndex:Int,eventIndex:Int)->Bool{

        let week = self.selectedPayPeriod?.weeks?[weekIndex]
        let timesheet = week?.timesheet?[timeSheetIndex]
        let event = timesheet?.events?[eventIndex]
        let currentEventType = event?.timelineEvent ?? ""

        if currentEventType == UserStatus.loggedIN.rawValue{
            
            for event in timesheet?.events ?? [Events](){
                if event.timelineEvent ?? "" == UserStatus.Inbreak.rawValue{
                    let flag = compareDates(date1:time, date2: event.timelineValue ?? "")
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for Start Shift")
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.Endbreak.rawValue{
                    let flag = compareDates(date1:time, date2: event.timelineValue ?? "")
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for Start Shift")
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.loggedOut.rawValue{
                    let flag = compareDates(date1:time, date2: event.timelineValue ?? "")
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for Start Shift")
                       
                        return false
                    }
                }
            }
        }else if currentEventType == UserStatus.loggedOut.rawValue{
            for event in timesheet?.events ?? [Events](){
                if event.timelineEvent ?? "" == UserStatus.loggedIN.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for End Shift")
                       
                        
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.Endbreak.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for End Shift")
                     
                       
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.Inbreak.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for End Shift")
                       
                        
                        return false
                    }
                }
            }
            
        }else if currentEventType == UserStatus.Inbreak.rawValue{
            for event in timesheet?.events ?? [Events](){
                if event.timelineEvent ?? "" == UserStatus.loggedIN.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for Lunch Start")
                     
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.Endbreak.rawValue{
                    let flag = compareDates(date1:time, date2: event.timelineValue ?? "")
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for Lunch Start")
                       
                       
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.loggedOut.rawValue{
                    let flag = compareDates(date1:time, date2: event.timelineValue ?? "")
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for Lunch Start")
                       
                       
                        return false
                    }
                }
            }
            
        }else if currentEventType == UserStatus.Endbreak.rawValue{
            for event in timesheet?.events ?? [Events](){
                if event.timelineEvent == UserStatus.loggedIN.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for Lunch End")
                      
                       
                        return false
                    }
                }else if event.timelineEvent == UserStatus.Inbreak.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for Lunch End")
                       
                      
                        return false
                    }
                }else if event.timelineEvent == UserStatus.loggedOut.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        self.showAlert(alertType:.validation, message: "Please choose a different time for Lunch End")
                      
                        
                        return false
                    }
                }
            }
        }
      return true
    }
    func getEventTypeMessage(eventType:String)->String{
        var eventTypeMessage = ""
        switch eventType {
        case UserStatus.loggedIN.rawValue:
            eventTypeMessage = "Shift Start"
            break
        case UserStatus.loggedOut.rawValue:
            eventTypeMessage = "Shift End"
            break
        case UserStatus.Inbreak.rawValue:
            eventTypeMessage = "Lunch Start"
            break
        case UserStatus.Endbreak.rawValue:
            eventTypeMessage = "Lunch End"
            break
        default:
            break
        }
        return eventTypeMessage
    }
    func submitTimeValidation(currentEvent:Events,timesheet:Timesheet?)->Bool{

        var currentEventType = currentEvent.timelineEvent ?? ""
     
        let events = timesheet?.events ?? [Events]()
        for (i,event) in events.enumerated(){
            currentEventType = event.timelineEvent ?? ""
            let currentEventTypeMessage = self.getEventTypeMessage(eventType: currentEventType)
            
           
            
            if events.last?.timelineTime ?? "" == ""{
                self.showAlert(alertType:.validation, message: "Please enter valid time")
               
                return false
              
            }
            if event == events.first{
                if event.timelineEvent ?? "" != UserStatus.loggedIN.rawValue{
                    self.showAlert(alertType:.validation, message: "First event must be Shift Start")
                   
                    return false
                }
            }else if event == events.last{
                if event.timelineEvent ?? "" != UserStatus.loggedOut.rawValue{
                    self.showAlert(alertType:.validation, message: "Last event must be Shift End")
                   
                    return false
                }
            }
            
            if events.count > i + 1{
                
                
                let eventTypeMessage = self.getEventTypeMessage(eventType: events[i+1].timelineEvent ?? "")
                
                
                
                if currentEventType == UserStatus.loggedIN.rawValue{
                    let nextEventType = events[i + 1].timelineEvent ?? ""
                    if nextEventType == UserStatus.loggedOut.rawValue || nextEventType == UserStatus.Inbreak.rawValue{
                       
                    }else{
                        self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage)")
                        
                        return false
                    }
                }else if currentEventType == UserStatus.loggedOut.rawValue{
                    let nextEventType = events[i + 1].timelineEvent ?? ""
                    if nextEventType == UserStatus.loggedIN.rawValue{
                       
                    }else{
                        self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage)")
                       
                        return false
                    }
                }else if currentEventType == UserStatus.Inbreak.rawValue{
                    let nextEventType = events[i + 1].timelineEvent ?? ""
                    if nextEventType == UserStatus.Endbreak.rawValue{
                       
                    }else{
                        self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage)")
                       
                        return false
                    }
                }else if currentEventType == UserStatus.Endbreak.rawValue{
                    let nextEventType = events[i + 1].timelineEvent ?? ""
                    if nextEventType == UserStatus.loggedOut.rawValue {
                       
                    }else{
                        self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage)")
                      
                        return false
                    }
                }
            }
        }
        return true
       
    }
   
}
extension EmployeeTimeReportVC:MenuItemDelegate {
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
extension String{
    func toDate(dateFormat:String = DateTimeFormat.yyyy_MM_dd.rawValue)->Date{
        let dateFormatter = DateFormatter()
        //2022-03-30 06:00:00
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self) ?? Date()
        return date
    }
    func toDateFromFull()->Date{
        let dateFormatter = DateFormatter()
        //2022-03-30 06:00:00
        dateFormatter.dateFormat = DateTimeFormat.wholeWithZ.rawValue
        let date = dateFormatter.date(from: self) ?? Date()
        return date
    }
}
extension Date{
    func getTodayWeekDay()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: self)
        return weekDay
    }
    func getString(formatter:String = DateTimeFormat.MM_DD_YYYY.rawValue)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        let date = dateFormatter.string(from: self)
        return date
    }
}
extension String {
    var condensedWhitespace: String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }

    func allowNumberOnly() -> String {
        let okayChars = CharacterSet(charactersIn: "1234567890")
        return String(self.unicodeScalars.filter { okayChars.contains($0) || $0.properties.isEmoji })
    }
}
extension DateComponentsFormatter {
    func difference(from fromDate: Date, to toDate: Date) -> String? {
        self.allowedUnits = [.minute]
        self.maximumUnitCount = 2
        self.unitsStyle = .positional
        return self.string(from: fromDate, to: toDate)
    }
}
extension EmployeeTimeReportVC{
    
    func fullTimeToDate(time:String)->Date{
        let dateFormatter = DateFormatter()
        //2022-03-30 06:00:00
        dateFormatter.dateFormat = DateTimeFormat.hh_mm_ss.rawValue
        let date = dateFormatter.date(from: time) ?? Date()
       
        return date
    }
    func DateToShortTime(time:Date)->String{
        let dateFormatter = DateFormatter()
        //2022-03-30 06:00:00
        dateFormatter.dateFormat = DateTimeFormat.time.rawValue
        let date = dateFormatter.string(from:time)
        
        return date
    }
    func differenceBetweenDates(from:Date,toDate:Date)->Int{
        let dateComponentsFormatter = DateComponentsFormatter()
        print( dateComponentsFormatter.difference(from:from, to: toDate) ?? "")
        return Int((dateComponentsFormatter.difference(from:from, to: toDate) ?? "0").allowNumberOnly()) ?? 0
    }
    func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    func compareDates(date1:String,date2:String)->Bool{

        let f = DateFormatter()
        f.dateFormat = "hh:mm a"

        if let d1 = f.date(from: date1),let d2 = f.date(from: date2){
            let flag = d1 > d2  // true
            return flag
        }else{
            return false
        }
 
    }
   
}
extension String{

    func toFullTime()->String{
        let f = DateFormatter()
        f.dateFormat = "hh:mm a"
        let date = f.date(from: self) ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from:date)
    }
   
}
