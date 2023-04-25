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
import IQKeyboardManagerSwift

struct CustomDate{
    var date:Date?
    var datestringForDisplay:String?
    var datestring:String?
    var dayName:String?
}
private var myContext = 0
class CreateEmployeeVC:BaseViewController, StoryboardSceneBased{
    
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
    
    @IBOutlet weak var passwordValidationView: UIView!
    
    @IBOutlet weak var imgvwminimumCharacter: UIImageView!
    @IBOutlet weak var imgvwLowercaseLetter: UIImageView!
    @IBOutlet weak var imgvwCapitalLetter: UIImageView!
    @IBOutlet weak var imgvwNumber: UIImageView!
    @IBOutlet weak var imgvwSpecialCharacter: UIImageView!
    @IBOutlet weak var eventCollectionviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewEvents: UICollectionView!
    @IBOutlet weak var eventTableHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var employeeProfileSelectionView: UIView!
    
    @IBOutlet weak var customNavView: UIView!
    
    var menuV : CustomMenuView!
    @IBOutlet weak var btnMenu: UIButton!
    
    var weekDates = [CustomDate]()
    var selectedWeekIndex = 0
    var selectedSettings:Settings = .userInfo
    @IBOutlet weak var saveView: UIView!
    var payPeriodsData = [Payperiods]()
    var selectedPayPeriod:Payperiods?
    var selectedPayPeriodIndex:Int = 0
    
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var lblUserInfoTitle: UILabel!
    @IBOutlet weak var lblUserInfoDesc: UILabel!
    @IBOutlet weak var lblTimesheetTitle: UILabel!
    @IBOutlet weak var lblTimesheetDesc: UILabel!
    @IBOutlet weak var lblUserDetails: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblTimeSheet: UILabel!
    @IBOutlet weak var lblPayPeriod: UILabel!
    @IBOutlet weak var requirementTitleLabel: UILabel!
    @IBOutlet weak var requirementLabel1: UILabel!
    @IBOutlet weak var requirementLabel2: UILabel!
    @IBOutlet weak var requirementLabel3: UILabel!
    @IBOutlet weak var requirementLabel4: UILabel!
    @IBOutlet weak var requirementLabel5: UILabel!
    @IBOutlet weak var saveViewCancelButton: UIButton!
    @IBOutlet weak var saveViewSaveButton: UIButton!
    @IBOutlet weak var lblSelectDate: UILabel!
    @IBOutlet weak var dateViewCancelButton: UIButton!
    @IBOutlet weak var datePickerCancelButton: UIButton!
    @IBOutlet weak var datePickerClearButton: UIButton!
    @IBOutlet weak var datePickerDoneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblProfile.text = NSLocalizedString("PROFILE", comment: "lblProfile")
        lblUserInfoTitle.text = NSLocalizedString("User Information", comment: "lblUserInfoTitle")
        lblUserInfoDesc.text = NSLocalizedString("General employee information", comment: "lblUserInfoDesc")
        lblTimesheetTitle.text = NSLocalizedString("Timesheets", comment: "lblTimesheetTitle")
        lblTimesheetDesc.text = NSLocalizedString("Employee clock history", comment: "lblTimesheetDesc")
        lblUserDetails.text = NSLocalizedString("User Information", comment: "lblUserDetails")
        lblFirstName.text = NSLocalizedString("First Name", comment: "firstNameLabel")
        lblLastName.text = NSLocalizedString("Last Name", comment: "lastNameLabel")
        lblEmail.text = NSLocalizedString("Email Address", comment: "emailLabel")
        lblJobTitle.text = NSLocalizedString("Job Title", comment: "jobTitleLabel")
        lblPassword.text = NSLocalizedString("Password", comment: "passwordLabel")
        lblTimeSheet.text = NSLocalizedString("Timesheet", comment: "lblTimeSheet")
        lblPayPeriod.text = NSLocalizedString("Pay Period", comment: "lblPayPeriod")
        requirementTitleLabel.text = NSLocalizedString("Please complete all the requirements.", comment: "requirementTitleLabel")
        requirementLabel1.text = NSLocalizedString("Minimum 8 characters", comment: "requirementLabel1")
        requirementLabel2.text = NSLocalizedString("Lowercase Letter", comment: "requirementLabel2")
        requirementLabel3.text = NSLocalizedString("Capital Letter", comment: "requirementLabel3")
        requirementLabel4.text = NSLocalizedString("Number", comment: "requirementLabel4")
        requirementLabel5.text = NSLocalizedString("Special Character", comment: "requirementLabel5")
        saveViewCancelButton.setTitle(NSLocalizedString("Cancel", comment: "saveViewCancelButton"), for: .normal)
        saveViewSaveButton.setTitle(NSLocalizedString("Save", comment: "saveViewSaveButton"), for: .normal)
        lblSelectDate.text = NSLocalizedString("Select Date", comment: "lblSelectDate")
        dateViewCancelButton.setTitle(NSLocalizedString("Cancel", comment: "dateViewCancelButton"), for: .normal)
        datePickerCancelButton.setTitle(NSLocalizedString("Cancel", comment: "datePickerCancelButton"), for: .normal)
        datePickerClearButton.setTitle(NSLocalizedString("Clear", comment: "datePickerClearButton"), for: .normal)
        datePickerDoneButton.setTitle(NSLocalizedString("Done", comment: "datePickerDoneButton"), for: .normal)
        
        setupMenu()
        setData()
        setTableview()
        txtPassword.delegate = self
        tblEvents.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [NSKeyValueObservingOptions.new], context: &myContext)
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchpayperiod()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &myContext,
            keyPath == #keyPath(UITextView.contentSize),
            let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
            print("contentSize:", contentSize)
            eventTableHeightConstraint.constant = tblEvents.contentSize.height
        }
    }
    deinit {
        tblEvents.removeObserver(self, forKeyPath: #keyPath(UITextView.contentSize))
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
       // eventTableHeightConstraint.constant = tblEvents.contentSize.height
    }
    override func updateViewConstraints() {
      //  eventTableHeightConstraint.constant = tblEvents.contentSize.height
        super.updateViewConstraints()
    }
    private func setupMenu(){
//        let controller = MenuViewController.instantiate()
//        controller.delegate = self
//        controller.selectedOption = .Employee
//        menu = SideMenuNavigationController(rootViewController:controller)
//        menu.navigationBar.isHidden = true
//        menu.leftSide = true
//        menu.menuWidth = Utility.getMenuWidth()
//        SideMenuManager.default.addPanGestureToPresent(toView:view)
//        SideMenuManager.default.leftMenuNavigationController = menu
        
        let topMargin = self.customNavView.frame.origin.y + self.customNavView.frame.size.height
        menuV = CustomMenuView.init(frame: CGRect.init(x: 0, y: topMargin, width: self.view.frame.width, height: self.view.frame.height - topMargin))
        menuV.isHidden = true
        menuV.delegate = self
        menuV.selectedOption = .Employee
        self.view.addSubview(menuV)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                if self.menuV.isHidden == true{
                    self.btnMenu.isHidden = true
                }
                menuV.swipedRight()
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                menuV.swipedLeft()
            default:
                break
            }
        }
    }
    
    func setData(){
        lblusername.text = Utility.getNameInitials()
        self.saveView.isHidden = true
        
        self.userinformationView.isHidden = true
        self.timereportView.isHidden = true
        self.employeeProfileSelectionView.isHidden = false
        
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
        if menuV.isHidden == false{
            return
        }
        PopupMenuVC.showPopupMenu(prevVC: self) { selectedItem in
            if let menuItem = selectedItem{
                if menuItem == .logout{
                    print("Logout")
                    Defaults.shared.currentUser = nil
                    Utility.setRootScreen(isShowAnimation: true)
                }
                else{
                    //Account
                    print("Account")
                    let vc = EmployeeTimeReportVC.instantiate()
                    vc.isForUserAccount = true
                    if let empId = Defaults.shared.currentUser?.empId{
                        vc.selectedEmployeeID = "\(empId)"
                        self.pushVC(controller:vc)
                    }
                }
            }
        }
    }
    @IBAction func menuClicked(sender:UIButton){
//        self.present(menu, animated: true, completion: {})
        menuV.showHideMenu()
        btnMenu.isHidden = true
    }
    
    @IBAction func selectSettingType(sender:UIButton){
        
        let pickerArray = ["User Information","Timesheets"]
        IQKeyboardManager.shared.enable = false
        PickerView.sharedInstance.addPicker(self, onTextField: txtselectedPayperiod, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                IQKeyboardManager.shared.enable = true
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
        IQKeyboardManager.shared.enable = false
        PickerView.sharedInstance.addPicker(self, onTextField:txtselectedPayperiod, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                // self.txtselectedPayperiod.text = value
                IQKeyboardManager.shared.enable = true
                 print(value)
                 self.selectedPayperiodLabel.text = value
                 self.selectedPayPeriod = self.payPeriodsData[index]
                 self.selectedPayPeriodIndex = index
                let str = "\(self.selectedPayPeriod?.payperiodFrom1 ?? "") - \(self.selectedPayPeriod?.payperiodTo1 ?? "")"
                self.selectedPayperiodLabel.text = str
                
             }
           // self.txtselectedPayperiod.isUserInteractionEnabled = false
            self.txtselectedPayperiod.resignFirstResponder()
            self.tblEvents.reloadData()
        }
        
    }
    
    @IBAction func btnUserInfoTapped(_ sender: Any) {
        self.saveView.isHidden = false
        
        self.userinformationView.isHidden = false
        self.timereportView.isHidden = true
        self.employeeProfileSelectionView.isHidden = true
    }
    
    @IBAction func btnTimesheetsTapped(_ sender: Any) {
        self.saveView.isHidden = false
        
        self.userinformationView.isHidden = true
        self.timereportView.isHidden = false
        self.employeeProfileSelectionView.isHidden = true
    }
    
    @IBAction func btnBackToSelectionTapped(_ sender: Any) {
        if employeeProfileSelectionView.isHidden == false{
            self.popVC()
        }
        else{
            self.saveView.isHidden = true
            self.userinformationView.isHidden = true
            self.timereportView.isHidden = true
            self.employeeProfileSelectionView.isHidden = false
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
        
        var validationSucceess = true
        if txtEmail.text!.isEmail == false{
            validationSucceess = false
            AlertMesage.show(.warning, title: "Invalid Email", message: nil)
            return
        }
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
        if validationSucceess{
            self.createEmployeeDetails()
             saveEmployeeDetails()
        }
    }
    @IBAction func cancelClick(sender:UIButton){
        saveView.isHidden = true
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: EmployeesVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
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
        
        self.weekDaysPopupView.isHidden = true
       
    }
    @objc func backClickFromWeekPopup(sender:UIButton){
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
      //  self.weekDaysPopupView.isHidden = false
  
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

        let timesheet = Timesheet().addEventsForDay(date:nil)
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.tag].timesheet?.append(timesheet)
        
        self.tblEvents.reloadData()
        selectedWeekIndex = sender.tag
    }
    @objc func changeDateSelected(sender:MyButton) {

        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeSheetCell
        cell.weekDaysPopupView.isHidden = false
        cell.isChangeDate = true

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
    @objc func selectWeekdayViewBack(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeSheetCell
        cell.mainView.isHidden = false
        cell.weekDaysPopupView.isHidden = true
        if cell.isChangeDate == false{
            self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet?.remove(at:sender.timeSheetIndex)
        }
        self.tblEvents.reloadData()
    }
    
    @objc func weekDaySelectClicked(sender:MyButton){
     
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        if let cell = tblEvents.cellForRow(at: indexpath) as? TimeSheetCell{
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
        guard let cell = tblEvents.cellForRow(at: indexpath) as? TimeSheetCell else {return}
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
        
        self.weekDaysPopupView.isHidden = true
       
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
    //    picker.addTarget(self, action: #selector(timesheetTimeChange(sender:)), for: UIControl.Event.valueChanged)
  
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
            self.showAlert(alertType:.validation, message: "Please enter first name")
           
            return false
        }
        if txtLastName.text!.count < 3{
            self.showAlert(alertType:.validation, message: "Please enter valid last name")
            
            return false
        }
        if txtjobtitle.text!.count < 3{
            self.showAlert(alertType:.validation, message: "Please enter valid job title")
            
            return false
        }
        if txtPassword.text!.count < 8{
            self.showAlert(alertType:.validation, message: "Please enter valid password")
            
            return false
        }
        if txtEmail.text!.isEmail == false{
            self.showAlert(alertType:.validation, message: "Please enter valid email.")
           
            return false
        }
        
        return true
    }
    
    func saveEmployeeDetails(){
        var employee = UpdateEmployee()
        var editedTimeSheet = [Weeks]()
       
        for (i,week) in (self.selectedPayPeriod?.weeks ?? [Weeks]()).enumerated(){
            for (j,_) in (week.timesheet ?? [Timesheet]()).enumerated(){
//                let events = self.selectedPayPeriod?.weeks?[i].timesheet?[i].events?.filter({$0.timelineTime != ""})
                let events = self.selectedPayPeriod?.weeks?[i].timesheet?[j].events?.filter({$0.timelineTime != ""})
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
                            self.showAlert(alertType:.validation, message: message)
                           
                        }
                      
                    }else{
                        self.saveView.isHidden = true
                        if let message =  res["message"] as? String{
                            AlertMesage.show(.success, message: message)
                           // self.showAlert(alertType:.validation, message: message)
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
    @IBAction func datePickerClearClick(){
        self.clearDate(sender:picker)
        self.datePickerView.isHidden = true
    }
    @objc func clearDate(sender:MyDatePicker){
        
        self.payPeriodsData[selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].events?[sender.eventIndex].timelineValue = ""
        self.payPeriodsData[selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].events?[sender.eventIndex].timelineTime = ""
      
        let indexpathCell = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        tblEvents.reloadRows(at: [indexpathCell], with: .none)
        
        let indexpathHeader = IndexPath(row:0, section: sender.weekIndex)
        tblEvents.reloadRows(at: [indexpathHeader], with: .none)
    }
    @objc func timesheetTimeChange(sender:MyDatePicker){
        self.datePickerView.isHidden = true
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = kMMddYYYYhhmmss
        print(dateFormatter.string(from: sender.date))
        dateFormatter.dateFormat = timeFormat
       
      
        
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
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeSheetCell
        for subview in cell.allSubViewsOf(type:UILabel.self){
            if subview.tag == eventIndex{
                subview.text = event?.timelineValue
            }
        }
        let indexpathCell = IndexPath(row:timeSheetIndex + 1, section: weekIndex)
        tblEvents.reloadRows(at: [indexpathCell], with: .none)
        
        let indexpathHeader = IndexPath(row:0, section: weekIndex)
        tblEvents.reloadRows(at: [indexpathHeader], with: .none)
        
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
                let startweek =  weekFrom.getString(formatter:DateTimeFormat.MMMM_dd_yyyy.rawValue)
                let endweek =  weekTo.getString(formatter:DateTimeFormat.MMMM_dd_yyyy.rawValue)
                cell.timeLabel.text = "\(startweek) - \(endweek)"
                
                let tuple = self.calculateTotalTimeForWeek(sectionIndex:indexPath.section)
               // print("Total Time \(tuple.hours).\(tuple.leftMinutes) hrs")
               
                cell.totalTimeLabel.text = "\(tuple.hours)." + String(format: "%02d hrs", tuple.leftMinutes)
                cell.regularHoursLabel.text = "\(tuple.hours)." + String(format: "%02d hrs", tuple.leftMinutes)
                
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
                
                
                cell.btnDate.addTarget(self, action:#selector(self.changeDateSelected(sender:)), for: .touchUpInside)
                cell.btnDate.timeSheetIndex = indexPath.row - 1
                cell.btnDate.weekIndex = indexPath.section
                
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
                if timeReportViewNew.timeLabel.text == ""{
                    timeReportViewNew.timeLabel.text = "--:-- --"
                }
                 timeReportViewNew.timeLabel.tag = i
                }
               
                let workTime = self.calculateTotalTime(events:timesheet?.events ?? [Events]())
                let tuple = minutesToHoursAndMinutes(workTime)
              
                
                cell.totalTimeLabel.text = "\(tuple.hours)." + String(format: "%02d hrs", ((tuple.leftMinutes * 100)/60 ))
                cell.regularHoursLabel.text = "\(tuple.hours)." + String(format: "%02d hrs", ((tuple.leftMinutes * 100)/60 ))
           
                cell.mainView.backgroundColor = .clear
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
                cell.weekDates = dates
                self.weekDates = dates
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
                if timesheet?.date == ""{
                    cell.weekDaysPopupView.isHidden = false
                    
                }else{
                    
                    cell.weekDaysPopupView.isHidden = true
                }
                return cell
            }
       
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
        self.viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}
extension CreateEmployeeVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPassword{
            self.updatePasswordValidation(str:textField.text!)
            self.passwordValidationView.isHidden = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPassword{
            self.updatePasswordValidation(str:textField.text!)
            self.passwordValidationView.isHidden = true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPassword{
            
            if let char = string.cString(using: String.Encoding.utf8) {
                   let isBackSpace = strcmp(char, "\\b")
                   if (isBackSpace == -92) {
                       print("Backspace was pressed")
                       self.updatePasswordValidation(str:String(textField.text?.dropLast() ?? ""))
                   }else{
                       self.updatePasswordValidation(str:textField.text! + string)
                   }
            }else{
                self.updatePasswordValidation(str:textField.text! + string)
            }
           
        }
        return true
    }
    func updatePasswordValidation(str:String){
            if str == ""{
                imgvwminimumCharacter.image = UIImage.unselectedImage
                imgvwCapitalLetter.image = UIImage.unselectedImage
                imgvwLowercaseLetter.image = UIImage.unselectedImage
                imgvwNumber.image = UIImage.unselectedImage
                imgvwSpecialCharacter.image = UIImage.unselectedImage
            }
         
            if str.count >= 8{
                imgvwminimumCharacter.image = UIImage.selectedImage
            }else{
                imgvwminimumCharacter.image = UIImage.unselectedImage
            }
           let capitalLetterRegEx  = ".*[A-Z]+.*"
           let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
            if texttest.evaluate(with: str){
                imgvwCapitalLetter.image = UIImage.selectedImage
            }else{
                imgvwCapitalLetter.image = UIImage.unselectedImage
            }
          
            let lowercaseLetterRegEx  = ".*[a-z]+.*"
            let texttest3 = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegEx)
             if texttest3.evaluate(with: str){
                 imgvwLowercaseLetter.image = UIImage.selectedImage
             }else{
                 imgvwLowercaseLetter.image = UIImage.unselectedImage
             }

           let numberRegEx  = ".*[0-9]+.*"
           let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            if texttest1.evaluate(with: str){
                imgvwNumber.image = UIImage.selectedImage
            }else{
                imgvwNumber.image = UIImage.unselectedImage
            }

           let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
           let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            if texttest2.evaluate(with: str){
                imgvwSpecialCharacter.image = UIImage.selectedImage
            }else{
                imgvwSpecialCharacter.image = UIImage.unselectedImage
            }
        
    }
}
extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [CustomDate] {
        var dates: [CustomDate] = []
        var date = fromDate
        
        while date <= toDate {
            var cal = Calendar.gregorian
            cal.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
            let order = Calendar.current.compare(now, to: date, toGranularity: .day)
            if order != .orderedAscending{
                
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
            }
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        
        return dates
    }
    
    static func dates(from fromDate: Date, to toDate: Date , excludeDates : [Date]) -> [CustomDate] {
        var dates: [CustomDate] = []
        var date = fromDate
        
        while date <= toDate {
            var needToAdd : Bool = true
            for eDate in excludeDates {
                if date == eDate {
                    needToAdd = false
                    break
                }

                var cal = Calendar.gregorian
                cal.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
                let order = cal.compare(Date.now, to: date, toGranularity: .day)
                if order == .orderedAscending{
                    needToAdd = false
                    break
                }
                
            }
            if needToAdd{
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
            }
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        
        return dates
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

extension CreateEmployeeVC: CustomMenuItemDelegate {
    func customMenuItemClicked(menuName: String) {
        print(menuName)
        if menuName == Menuname.settings{
            let vc = EmployeeTimeReportVC.instantiate()
            vc.isForUserAccount = true
            if let empId = Defaults.shared.currentUser?.empId{
                vc.selectedEmployeeID = "\(empId)"
            }
            self.pushVC(controller:vc)
        }else  if menuName == Menuname.logout{
            Defaults.shared.currentUser = nil
            Utility.setRootScreen(isShowAnimation: true)
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
    func customMenuDidHide(){
        self.btnMenu.isHidden = false
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

extension Date {
    var onlyDate: Date {
        get {
            let calender = Calendar.current
            let dateComponents = calender.dateComponents([.year, .month, .day], from: self)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy:MM:dd"
            let date = calender.date(from: dateComponents)
            let stringDate = dateFormatter.string(from: date!)
            print(stringDate)
            print(dateFormatter.date(from: stringDate))
            return dateFormatter.date(from: stringDate)!
        }
    }
}
