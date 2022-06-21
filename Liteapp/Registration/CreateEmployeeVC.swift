//
//  CreateEmployeeVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 15/06/22.
//

import UIKit
import SideMenu
import ObjectMapper
import Alamofire
import SwiftUI


struct CustomDate{
    var date:Date?
    var datestringForDisplay:String?
    var datestring:String?
    var dayName:String?
}
class CreateEmployeeVC:BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.merchant.rawValue, bundle: nil)
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
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtjobtitle: UITextField!
    @IBOutlet weak var btnDeleteEmployee: UIButton!
    
    @IBOutlet weak var userinformationView: UIView!
    @IBOutlet weak var timereportView: UIView!
    
    @IBOutlet weak var selectedPayperiodLabel: UILabel!
    @IBOutlet weak var txtselectedPayperiod: UITextField!
  
    @IBOutlet weak var picker: MyDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var eventTableHeightConstraint: NSLayoutConstraint!
    var weekDates = [CustomDate]()
    var selectedWeekIndex = 0
    var selectedSettings:Settings = .userInfo
    @IBOutlet weak var saveView: UIView!
    var payPeriodsData = [Payperiods]()
    var selectedPayPeriod:Payperiods?
    var selectedPayPeriodIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setData()
        setTableview()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchpayperiod()
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        eventTableHeightConstraint.constant = tblEvents.contentSize.height
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
    func setData(){
        logoutView.isHidden = true
        lblusername.text = "\(Defaults.shared.currentUser?.empFirstname ?? "") \(Defaults.shared.currentUser?.empLastname ?? "")"
        self.saveView.isHidden = false
        
        self.userinformationView.isHidden = false
        self.timereportView.isHidden = true
        
    }
    func setTableview(){
        tblEvents.register(cellType: TimeSheetCell.self)
     
        tblEvents.register(cellType: TimesheetHeaderCell.self)
     
        let TimeReportFooterCellnib = UINib(nibName: "TimeSheetCell", bundle: nil)
        tblEvents.register(TimeReportFooterCellnib, forHeaderFooterViewReuseIdentifier: "TimesheetHeaderCell")
       // tblEvents.estimatedRowHeight = 150.0
        tblEvents.rowHeight = UITableView.automaticDimension
        tblEvents.delegate = self
        tblEvents.dataSource = self
        tblEvents.separatorStyle = .none

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
    
    @IBAction func selectSettingType(sender:UIButton){
        
        let pickerArray = ["User Information","Timesheets"]
        
        PickerView.sharedInstance.addPicker(self, onTextField: txtselectedPayperiod, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                
                 print(value)
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
    @IBAction func saveClick(sender:UIButton){
        self.createEmployeeDetails()
        saveEmployeeDetails()

    }
    @IBAction func cancelClick(sender:UIButton){
        saveView.isHidden = true
    }
    @IBAction func weekDaySelected(sender:UIButton){
     
        for obj in (self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet ?? [Timesheet]()){
            if obj.date == weekDates[sender.tag - 1].datestring ?? ""{
                AlertMesage.show(.error, message: "This day already added")
                return
            }
            
        }
       // print(weekDates[sender.tag - 1])
        let timesheet = Timesheet().addEventsForDay(date: weekDates[sender.tag - 1])
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet?.append(timesheet)
        
       // self.selectedPayPeriod?.weeks?[self.selectedWeekIndex].timesheet?.append(timesheet)
        self.tblEvents.reloadData()
        
        self.weekDaysPopupView.isHidden = true
       
    }
    @IBAction func backClickFromWeekPopup(sender:UIButton){
        self.weekDaysPopupView.isHidden = true
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
    func createEmployeeDetails(){
        var employee = CreateEmployee()
        employee.empFirstname = txtFirstName.text!
        employee.empLastname = txtLastName.text!
        employee.empJobTitle = txtjobtitle.text!
        employee.empWorkEmail = txtEmail.text!
        employee.timezone = Defaults.shared.currentUser?.merchantTimezone ?? ""
        employee.timesheet = ""
    }
    func createEmployeeAPI(employee:CreateEmployee){
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.saveEmployeesByManager(), param: employee.getParam(), header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                print(res)
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
                self.tblEvents.reloadData()
            }else if let err = error{
                print(err)
            }
        }
    }
    @objc func addTimesheetClicked(sender:UIButton) {
        let selectedWeek = selectedPayPeriod?.weeks?[sender.tag]
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = kDateGetFormat
        let fromDate = dateFormatter.date(from:selectedWeek?.weekFrom ??
                                          "") ?? Date()
        let toDate = dateFormatter.date(from:selectedWeek?.weekTo ??
        "") ?? Date()
        let dates = (Date.dates(from:fromDate, to: toDate))
        print(dates)
        self.setWeekDays(days:dates)
        selectedWeekIndex = sender.tag
    }
    @objc func approvedClicked(sender:UIButton) {
        
    }
    @objc func moreOptionClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeSheetCell
        cell.mainView.isHidden = true
        cell.addshiftMainView.isHidden = false
    }
    
    @objc func addShiftClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeSheetCell
        cell.mainView.isHidden = false
        cell.addshiftMainView.isHidden = true
        
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].addShiftForDay()
        self.tblEvents.reloadRows(at:[indexpath], with: .none)
    }
    @objc func addBreakClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeSheetCell
        cell.mainView.isHidden = false
        cell.addshiftMainView.isHidden = true
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].addBreaksForDay()
       
        self.tblEvents.reloadRows(at:[indexpath], with: .none)
    }
    @objc func deleteSheetClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeSheetCell
      //  cell.mainView.isHidden = false
        cell.addshiftMainView.isHidden = true
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?.remove(at:sender.timeSheetIndex)
       
        self.tblEvents.reloadData()
    }
    @objc func addShiftMainViewBack(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeSheetCell
        cell.mainView.isHidden = false
        cell.addshiftMainView.isHidden = true
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
        picker.addTarget(self, action: #selector(timesheetTimeChange(sender:)), for: UIControl.Event.valueChanged)
  
        picker.preferredDatePickerStyle = .wheels
        let dateFormatter = DateFormatter()
      
        dateFormatter.dateFormat = kMMddYYYYhhmmss
        picker.setDate(dateFormatter.date(from:time) ?? Date(), animated: true)
        picker.eventIndex = sender.eventIndex
        picker.timeSheetIndex = sender.timeSheetIndex
        picker.weekIndex = sender.weekIndex
        self.datePickerView.isHidden = false
      //  self.view.addSubview(picker)
        
       
    }
   
    func checkValidation()->Bool{
        if txtFirstName.text!.count < 3{
            AlertMesage.show(.error, message: "Please enter first name")
            return false
        }
        if txtLastName.text!.count < 3{
            AlertMesage.show(.error, message: "Please enter valid last name")
            return false
        }
        if txtjobtitle.text!.count < 3{
            AlertMesage.show(.error, message: "Please enter valid job title")
            return false
        }
        if txtPassword.text!.count < 8{
            AlertMesage.show(.error, message: "Please enter valid password")
            return false
        }
        if txtEmail.text!.isEmail == false{
            AlertMesage.show(.error, message: "Please enter valid email.")
            return false
        }
        
        return true
    }
    
    func saveEmployeeDetails(){
        var employee = UpdateEmployee()
        var editedTimeSheet = [Weeks]()
       
        for (i,week) in (self.selectedPayPeriod?.weeks ?? [Weeks]()).enumerated(){
            for (j,_) in (week.timesheet ?? [Timesheet]()).enumerated(){
                let events = self.selectedPayPeriod?.weeks?[i].timesheet?[i].events?.filter({$0.timelineTime != ""})
                self.selectedPayPeriod?.weeks?[i].timesheet?[j].events = events
                print(self.selectedPayPeriod?.weeks?[i].timesheet?[i].events?.toJSON() ?? "")
            }
        }
        if let weeks = self.selectedPayPeriod?.weeks{
            editedTimeSheet = weeks
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: editedTimeSheet.toJSON(), options: [])
                if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(jsonString)
                    employee.timesheet = "\(jsonString)"
                    //employee.timesheet = "[]"
                    
                }
            } catch {
                print(error)
            }
        }
 
        employee.empFirstname = txtFirstName.text!
        employee.empLastname = txtLastName.text!
        employee.empJobTitle = txtjobtitle.text!
        employee.empWorkEmail = txtEmail.text!
        employee.empPassword = txtPassword.text!
        employee.empID = ""
        employee.timezone = Defaults.shared.currentUser?.merchantTimezone ?? ""
      
        saveEmployeeAPI(employee:employee)
    }
    func saveEmployeeAPI(employee:UpdateEmployee){
        print(employee.getParam())
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.saveEmployeesByManager(), param: employee.getParam(), header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                if let status = res["status"] as? Int{
                    if status == 0{
                        self.saveView.isHidden = false
                        if let message =  res["message"] as? String{
                            AlertMesage.show(.error, message: message)
                        }
                      
                    }else{
                        self.saveView.isHidden = true
                        if let message =  res["message"] as? String{
                            AlertMesage.show(.success, message: message)
                            self.popVC()
                        }
                    }
                }
                print(res)
               
            }else if let err = error{
                print(err)
            }
        }
    }
    @IBAction func datePickerCancelClick(){
        self.datePickerView.isHidden = true
    }
    @IBAction func datePickerDoneClick(){
        self.timesheetTimeChange(sender:picker)
        self.datePickerView.isHidden = true
    }
    @objc func timesheetTimeChange(sender:MyDatePicker){
        self.datePickerView.isHidden = true
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = kMMddYYYYhhmmss
        print(dateFormatter.string(from: sender.date))
        dateFormatter.dateFormat = timeFormat
        let timeLineTime = dateFormatter.string(from: sender.date)
      
        
        if self.timeValidation(time:timeLineTime,weekIndex:sender.weekIndex,timeSheetIndex:sender.timeSheetIndex,eventIndex:sender.eventIndex){
            //do after everything is fine
            self.setUpdatedTimesheetData(date:sender.date,weekIndex:sender.weekIndex,timeSheetIndex:sender.timeSheetIndex,eventIndex:sender.eventIndex)
        }
        
       
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
        self.selectedPayPeriod = self.payPeriodsData[selectedPayPeriodIndex]
        event = self.selectedPayPeriod?.weeks?[weekIndex].timesheet?[timeSheetIndex].events?[eventIndex]
        
        let indexpath = IndexPath(row:timeSheetIndex + 1, section: weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeSheetCell
        for subview in cell.allSubViewsOf(type:UILabel.self){
            if subview.tag == eventIndex{
                subview.text = event?.timelineValue
            }
        }
        let indexpathHeader = IndexPath(row:timeSheetIndex + 1, section: weekIndex)
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
                        AlertMesage.show(.error, message: "Please choose a different time for Start Shift")
                       
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.Endbreak.rawValue{
                    let flag = compareDates(date1:time, date2: event.timelineValue ?? "")
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for Start Shift")
                       
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.loggedOut.rawValue{
                    let flag = compareDates(date1:time, date2: event.timelineValue ?? "")
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for Start Shift")
                       
                        return false
                    }
                }
            }
        }else if currentEventType == UserStatus.loggedOut.rawValue{
            for event in timesheet?.events ?? [Events](){
                if event.timelineEvent ?? "" == UserStatus.loggedIN.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for End Shift")
                        
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.Endbreak.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for End Shift")
                       
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.Inbreak.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for End Shift")
                        
                        return false
                    }
                }
            }
            
        }else if currentEventType == UserStatus.Inbreak.rawValue{
            for event in timesheet?.events ?? [Events](){
                if event.timelineEvent ?? "" == UserStatus.loggedIN.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for Lunch Start")
                       
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.Endbreak.rawValue{
                    let flag = compareDates(date1:time, date2: event.timelineValue ?? "")
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for Lunch Start")
                       
                        return false
                    }
                }else if event.timelineEvent ?? "" == UserStatus.loggedOut.rawValue{
                    let flag = compareDates(date1:time, date2: event.timelineValue ?? "")
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for Lunch Start")
                       
                        return false
                    }
                }
            }
            
        }else if currentEventType == UserStatus.Endbreak.rawValue{
            for event in timesheet?.events ?? [Events](){
                if event.timelineEvent == UserStatus.loggedIN.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for Lunch End")
                       
                        return false
                    }
                }else if event.timelineEvent == UserStatus.Inbreak.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for Lunch End")
                      
                        return false
                    }
                }else if event.timelineEvent == UserStatus.loggedOut.rawValue{
                    let flag = compareDates(date1:event.timelineValue ?? "", date2: time)
                    if flag{
                        AlertMesage.show(.error, message: "Please choose a different time for Lunch End")
                        
                        return false
                    }
                }
            }
        }
      return true
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
            let workTime = totalWorkTime - breakTime
            TotalWorkTime = TotalWorkTime + workTime
           
        }
        let tuple = minutesToHoursAndMinutes(TotalWorkTime)
        return (tuple.hours, tuple.leftMinutes ,TotalWorkTime)
       
    }
}
extension CreateEmployeeVC: UITableViewDelegate, UITableViewDataSource {
    
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
                let cell: TimesheetHeaderCell = tableView.dequeueReusableCell(for: indexPath)
                let weekFrom = "\(week?.weekFrom ?? "")".toDate()
                let weekTo = "\(week?.weekTo ?? "")".toDate()
                let startweek =  weekFrom.getString(formatter:DateTimeFormat.MMM_dd_yyyy.rawValue)
                let endweek =  weekTo.getString(formatter:DateTimeFormat.MMM_dd_yyyy.rawValue)
                cell.timeLabel.text = "\(startweek) - \(endweek)"
                
                let tuple = self.calculateTotalTimeForWeek(sectionIndex:indexPath.section)
               // print("Total Time \(tuple.hours).\(tuple.leftMinutes) hrs")
                cell.totalTimeLabel.text = "\(tuple.hours).\(tuple.leftMinutes) hrs"
                cell.regularHoursLabel.text = "\(tuple.hours).\(tuple.leftMinutes) hrs"
                
                cell.btnAddTimesheet.addTarget(self, action:#selector(self.addTimesheetClicked(sender:)), for: .touchUpInside)
                cell.btnAddTimesheet.tag = indexPath.section
               
                
                cell.button.addTarget(self, action:#selector(self.approvedClicked(sender:)), for: .touchUpInside)
                cell.button.tag = indexPath.section
               
               
                
                cell.selectionStyle = .none
                return cell

            }else{
                let cell:TimeSheetCell = tableView.dequeueReusableCell(for: indexPath)
                let timesheet =  selectedPayPeriod?.weeks?[indexPath.section].timesheet?[indexPath.row - 1]
                let timesheetDate = (timesheet?.date ?? "").replacingOccurrences(of:"/", with: "-")
                let date = timesheetDate.toDate()
                let weekday = date.getTodayWeekDay()
                let dateString = date.getString()
                cell.dateLabel.text = dateString
                cell.dayLabel.text = weekday
                
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
                
                
                var startTime:Date!
                var breakstartTime:Date!
                var breakEndTime:Date!
                var endTime:Date!
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
                      startTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
                    
                  }else if timeLineEvent == "O"{
                      timeReportViewNew.titleLabel.text = "Shift End:"
                      timeReportViewNew.barView.backgroundColor = UIColor.endShiftColor
                      endTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
                  }else if timeLineEvent == "B"{
                      timeReportViewNew.titleLabel.text = "Break Start:"
                      timeReportViewNew.barView.backgroundColor = UIColor.breakStartColor
                      breakstartTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
                  }else if timeLineEvent == "S"{
                      timeReportViewNew.titleLabel.text = "Break End:"
                      timeReportViewNew.barView.backgroundColor = UIColor.breakEndColor
                      breakEndTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
                  }
                 timeReportViewNew.btnTimeEdit.addTarget(self, action:#selector(self.changeTimeClick(sender:)), for: .touchUpInside)
                 timeReportViewNew.btnTimeEdit.timeSheetIndex = indexPath.row - 1
                 timeReportViewNew.btnTimeEdit.weekIndex = indexPath.section
                 timeReportViewNew.btnTimeEdit.eventIndex = i
                 timeReportViewNew.timeLabel.text = event.timelineValue
                if timeReportViewNew.timeLabel.text == ""{
                    timeReportViewNew.timeLabel.text = "--:-- --"
                }
                 timeReportViewNew.timeLabel.tag = i
                }
                var breakTime = 0
                var totalWorkTime = 0
                if breakstartTime != nil && breakEndTime != nil{
                    breakTime = self.differenceBetweenDates(from:breakstartTime, toDate: breakEndTime)
                }
                if startTime != nil && endTime != nil{
                  //  print(startTime)
                 //   print(endTime)
                    totalWorkTime = self.differenceBetweenDates(from:startTime, toDate: endTime)
                }
                let workTime = totalWorkTime - breakTime
                let tuple = minutesToHoursAndMinutes(workTime)
              
                cell.totalTimeLabel.text = "\(tuple.hours).\((tuple.leftMinutes * 100)/60 ) hrs"
                cell.regularHoursLabel.text = "\(tuple.hours).\((tuple.leftMinutes * 100)/60 ) hrs"
           
                
                cell.selectionStyle = .none
                return cell
            }
       
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [CustomDate] {
        var dates: [CustomDate] = []
        var date = fromDate
        
        while date <= toDate {
            let dateFormatter = DateFormatter()
            //2022-03-30 06:00:00
            dateFormatter.dateFormat = DateTimeFormat.MM_DD_YYYY.rawValue
            let dateString = dateFormatter.string(from:date)
            dateFormatter.dateFormat = DateTimeFormat.EEEE.rawValue
            let dayString = dateFormatter.string(from:date)
            
            dateFormatter.dateFormat = DateTimeFormat.yyyy_MM_dd.rawValue
            let str = dateFormatter.string(from:date)

         
            let customDate = CustomDate(date: date, datestringForDisplay: dateString, datestring: str, dayName: dayString)
            dates.append(customDate)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        
        return dates
    }
}
extension CreateEmployeeVC {
    
    func datesBetweenTwoDays(){
        
    }
}
extension CreateEmployeeVC:MenuItemDelegate {
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
extension CreateEmployeeVC{
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

   
}
