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
    @IBOutlet weak var tblEvents: UITableView!
  
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtjobtitle: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
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
    
    //Selection VIew
    @IBOutlet var employeeProfileSelectionView: UIView!
    
    
    @IBOutlet weak var passwordValidationView: UIView!
    
    @IBOutlet weak var imgvwminimumCharacter: UIImageView!
    @IBOutlet weak var imgvwLowercaseLetter: UIImageView!
    @IBOutlet weak var imgvwCapitalLetter: UIImageView!
    @IBOutlet weak var imgvwNumber: UIImageView!
    @IBOutlet weak var imgvwSpecialCharacter: UIImageView!
    @IBOutlet weak var constTopEditTooltip: NSLayoutConstraint!
    
    @IBOutlet weak var viewUsername: UIView!
    
    @IBOutlet weak var customNavView: UIView!
    
    var menuV : CustomMenuView!
    
    var isPasswordValidTotalCount : Bool = false
    var isPasswordValidCapitalChar : Bool = false
    var isPasswordValidSmallChar : Bool = false
    var isPasswordValidSpecialChar : Bool = false
    var isPasswordValidNumberChar : Bool = false
    
    var isFromEmployee = false
    var isFromTimesheet = false
    var isForUserAccount = false
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
    var isEditMode : Bool = false
    var btnApproveUnApprove : UIButton?
    var approvalFooterView : UIView?
    var isForAdminProfile : Bool = false
    
    @IBOutlet weak var picker: MyDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        setTableview()
        setupMenu()

        if isFromEmployee{
            self.employeeProfileSelectionView.isHidden = false
            self.userinformationView.isHidden = true
            self.timereportView.isHidden = true
            editView.isHidden = true
        }
        else if isFromTimesheet{
            self.employeeProfileSelectionView.isHidden = true
            self.userinformationView.isHidden = true
            self.timereportView.isHidden = false
            editView.isHidden = false
        }
        else if isForUserAccount{
            self.employeeProfileSelectionView.isHidden = true
            self.userinformationView.isHidden = false
            self.timereportView.isHidden = true
            editView.isHidden = false
        }
        else{
            self.employeeProfileSelectionView.isHidden = false
            self.userinformationView.isHidden = true
            self.timereportView.isHidden = true
            editView.isHidden = true
        }
        
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtEmail.delegate = self
        self.txtjobtitle.delegate = self
        self.txtPassword.delegate = self
        self.txtUsername.delegate = self
        
        tblEvents.addObserver(self, forKeyPath: #keyPath(UITableView.contentSize), options: [NSKeyValueObservingOptions.new], context: &myContext)
//        collectionViewEvents.addObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize), options: [NSKeyValueObservingOptions.new], context: &collectionviewContext)
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
//        if context == &collectionviewContext,
//            keyPath == #keyPath(UITextView.contentSize),
//            let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
//            print("contentSize:", contentSize)
//            eventCollectionviewHeightConstraint.constant = collectionViewEvents.contentSize.height
//        }
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
        self.view.layoutSubviews()
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
                menuV.swipedRight()
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                menuV.swipedLeft()
            default:
                break
            }
        }
    }
   
    func setupTableViewHeightWithReload(){
        eventTableHeightConstraint.constant = CGFloat.greatestFiniteMagnitude
        tblEvents.reloadData()
        tblEvents.layoutIfNeeded()
//        eventTableHeightConstraint.constant = tblEvents.contentSize.height
        self.updateViewConstraints()
    }
    
    func setApproveUnApproveTableFooterView(){
        approvalFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblEvents.frame.width, height: 90))
        approvalFooterView?.backgroundColor = UIColor.clear
        btnApproveUnApprove = UIButton(frame: CGRect(x: 15, y: 30, width: tblEvents.frame.width - 30, height: 40))
        btnApproveUnApprove?.roundCorners(UIRectCorner.allCorners, radius: 8.0)
        setTitleForApproveUnApproveBtn(isForApprove: true)
        btnApproveUnApprove?.addTarget(self, action: #selector(btnApproveUnApproveTapped), for: .touchUpInside)
        approvalFooterView?.addSubview(btnApproveUnApprove!)
    }
    
    func setTitleForApproveUnApproveBtn(isForApprove : Bool){
        if !isForApprove{
            btnApproveUnApprove!.setTitle("Approve Timesheet", for: .normal)
            btnApproveUnApprove!.setBackgroundColor(UIColor.Color.appGreenColor, forState: .normal)
        }
        else{
            btnApproveUnApprove!.setTitle("Unapprove Timesheet", for: .normal)
            btnApproveUnApprove!.setBackgroundColor(UIColor.Color.appYellowColor, forState: .normal)
        }
    }
    
    @objc func btnApproveUnApproveTapped(_ sender: UIButton!) {
        print("Button tapped")
        if selectedPayPeriodIndex == 0 {
            self.showAlert(alertType:.validation, message: "Status of currunt pay period can't be changed.")
        }
        else{
            if self.selectedPayPeriod?.payperiodStatus == "A"{
                changeStatusAPI(payperiodStatus: TimesheetStatus.unapproved)
            }
            else{
                changeStatusAPI(payperiodStatus: TimesheetStatus.approved)
            }
        }
    }
    
    func changeStatusAPI(payperiodStatus:TimesheetStatus){
        let payperiodId = "\(self.selectedPayPeriod?.payperiodEmpId ?? 0)"
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0,
            "status":payperiodStatus.rawValue,
            "ids":payperiodId
        ] as [String : Any]
        
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.changeStatus(), param: parameters, header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                print(res)
                if let status = res["status"] as? Int{
                    if status == 1{
                        var isApproved = false
                        if payperiodStatus == .approved{
                            isApproved = true
                        }
                        self.selectedPayPeriod?.payperiodStatus = payperiodStatus.rawValue
                        self.tblEvents.reloadData()
                        self.setTitleForApproveUnApproveBtn(isForApprove: isApproved)
                    }
                }
            }
            else if let err = error{
                print(err)
                self.showAlert(alertType:.validation, message: err.localizedDescription)
                
            }
        }
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
//        tblEvents.reloadRows(at: [indexpathCell], with: .none)
        self.setupTableViewHeightWithReload()
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
//        collectionViewEvents.reloadItems(at: [indexpathCVCell])
        
        
        let indexpathHeader = IndexPath(row:0, section: sender.weekIndex)
//        tblEvents.reloadRows(at: [indexpathHeader], with: .none)
        self.setupTableViewHeightWithReload()
    }
    func setData(){
        lblusername.text = Utility.getNameInitials()

//        txtFirstName.isUserInteractionEnabled = false
//        txtLastName.isUserInteractionEnabled = false
//        txtEmail.isUserInteractionEnabled = false
//        txtjobtitle.isUserInteractionEnabled = false
//        tblEvents.isUserInteractionEnabled = false
       
//        userinforStackview.alpha = 0.5
        changeEmployeeAccountTextfieldsAppearance(toEdit: false)
        tblEvents.tableFooterView = nil
        
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
                self.txtPassword.text = "\(self.employeeDetails?.empPassword ?? "")"
                self.txtUsername.text = "\(self.employeeDetails?.empUsername ?? "")"
                
                //Show/Hide Username and Delete option based on user type
                if self.employeeDetails?.empType == "S"{
                    //Show Username and Hide Delete
                    self.isForAdminProfile = true
                    self.viewUsername.isHidden = false
                    self.btnDeleteEmployee.isHidden = true
                }
                else{
                    //Hide Username and Show Delete
                    self.isForAdminProfile = false
                    self.viewUsername.isHidden = true
                    self.btnDeleteEmployee.isHidden = false
                }
                
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
//        self.tblEvents.reloadData()
        self.setupTableViewHeightWithReload()
//        self.collectionViewEvents.reloadData()
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
        txtPassword.isUserInteractionEnabled = true
        txtUsername.isUserInteractionEnabled = true
        tblEvents.isUserInteractionEnabled = true
       
        txtFirstName.alpha = 1.0
        txtLastName.alpha = 1.0
        txtEmail.alpha = 1.0
        txtjobtitle.alpha = 1.0
        txtPassword.alpha = 1.0
        txtUsername.alpha = 1.0
//        userinforStackview.alpha = 1.0
        changeEmployeeAccountTextfieldsAppearance(toEdit: true)
        
        
        saveView.isHidden = false
        editView.isUserInteractionEnabled = false
        editView.alpha = 0.5
//        tblEvents.reloadData()
        tblEvents.tableFooterView = self.approvalFooterView
        self.setupTableViewHeightWithReload()
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
                
                var isPayperiodApproved = false
                if self.selectedPayPeriod?.payperiodStatus == "A"{
                    isPayperiodApproved = true
                }
                self.setTitleForApproveUnApproveBtn(isForApprove: isPayperiodApproved)
                
//                self.tblEvents.reloadData()
                self.setupTableViewHeightWithReload()
//                self.collectionViewEvents.reloadData()
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
        tblEvents.bounces = false
        tblEvents.bouncesZoom = false
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
        
        setApproveUnApproveTableFooterView()
        
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
                var isPayperiodApproved = false
                if self.selectedPayPeriod?.payperiodStatus == "A"{
                    isPayperiodApproved = true
                }
                self.setTitleForApproveUnApproveBtn(isForApprove: isPayperiodApproved)
//                self.tblEvents.reloadData()
                self.setupTableViewHeightWithReload()
                self.collectionViewEvents.reloadData()
            }else if let err = error{
                print(err)
            }
        }
    }
    
    func validateSettings() -> Bool{
        let isValidated = true
        if txtFirstName.text!.count < 1{
            self.showAlert(alertType:.validation, message: "Please Enter First Name")
            return false
        }
        if txtFirstName.text!.hasNumbers{
            self.showAlert(alertType:.validation, message: "Name can only contain alphabets.")
            return false
        }
        
        if txtLastName.text!.count < 1{
            self.showAlert(alertType:.validation, message: "Please Enter Last Name")
            return false
        }
        if txtLastName.text!.hasNumbers{
            self.showAlert(alertType:.validation, message: "Name can only contain alphabets.")
            return false
        }
        if txtEmail.text!.count < 1{
            self.showAlert(alertType:.validation, message: "Please Enter Email")
            return false
        }
        if let email = txtEmail.text{
            if !(email.count > 0 && email.isEmail){
//                self.showAlert(alertType:.validation, message: "Please Enter Valid Email")
                self.showAlert(alertType:.validation, message: "Invalid E-Mail. Please Try Again.")
                return false
            }
        }
        if self.isForAdminProfile && txtUsername.text!.count < 1{
            self.showAlert(alertType:.validation, message: "Please Enter Username")
            return false
        }
        if txtPassword.text!.count < 1{
            self.showAlert(alertType:.validation, message: "Please Enter Password")
            return false
        }
        return isValidated
    }
    
    func changeEmployeeAccountTextfieldsAppearance(toEdit mode: Bool){
        isEditMode = mode
        if mode{
            txtFirstName.backgroundColor = UIColor.white
            txtLastName.backgroundColor = UIColor.white
            txtjobtitle.backgroundColor = UIColor.white
            txtEmail.backgroundColor = UIColor.white
            txtPassword.backgroundColor = UIColor.white
            txtUsername.backgroundColor = UIColor.white
            btnDeleteEmployee.isEnabled = true
            btnDeleteEmployee.alpha = 1.0
        }
        else{
            txtFirstName.backgroundColor = UIColor.Color.appThemeBGColor
            txtLastName.backgroundColor = UIColor.Color.appThemeBGColor
            txtjobtitle.backgroundColor = UIColor.Color.appThemeBGColor
            txtEmail.backgroundColor = UIColor.Color.appThemeBGColor
            txtPassword.backgroundColor = UIColor.Color.appThemeBGColor
            txtUsername.backgroundColor = UIColor.Color.appThemeBGColor
            btnDeleteEmployee.isEnabled = false
            btnDeleteEmployee.alpha = 0.5
        }
//        tblEvents.reloadData()
        self.setupTableViewHeightWithReload()
        collectionViewEvents.reloadData()
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
            txtUsername.isUserInteractionEnabled = true
            txtPassword.isUserInteractionEnabled = true
            tblEvents.isUserInteractionEnabled = true
            
            txtFirstName.alpha = 1.0
            txtLastName.alpha = 1.0
            txtEmail.alpha = 1.0
            txtjobtitle.alpha = 1.0
            txtUsername.alpha = 1.0
            txtPassword.alpha = 1.0
//            userinforStackview.alpha = 1.0
            changeEmployeeAccountTextfieldsAppearance(toEdit: true)
            saveView.isHidden = false
            editView.isUserInteractionEnabled = false
            editView.alpha = 0.5
            tblEvents.tableFooterView = self.approvalFooterView
            
        }else{
//            txtFirstName.isUserInteractionEnabled = false
//            txtLastName.isUserInteractionEnabled = false
//            txtEmail.isUserInteractionEnabled = false
//            txtjobtitle.isUserInteractionEnabled = false
//            tblEvents.isUserInteractionEnabled = false
            if validateSettings(){
                txtFirstName.alpha = 0.5
                txtLastName.alpha = 0.5
                txtEmail.alpha = 0.5
                txtjobtitle.alpha = 0.5
                txtUsername.alpha = 0.5
                txtPassword.alpha = 0.5
                //            userinforStackview.alpha = 0.5
                changeEmployeeAccountTextfieldsAppearance(toEdit: false)
                tblEvents.tableFooterView = nil
                saveView.isHidden = true
                editView.isUserInteractionEnabled = true
                editView.alpha = 1.0
                updateEmployeeDetails()
            }
        }

    }
    @IBAction func cancelClick(sender:UIButton){
//        txtFirstName.isUserInteractionEnabled = false
//        txtLastName.isUserInteractionEnabled = false
//        txtEmail.isUserInteractionEnabled = false
//        txtjobtitle.isUserInteractionEnabled = false
//        tblEvents.isUserInteractionEnabled = false
//        userinforStackview.alpha = 0.5
        changeEmployeeAccountTextfieldsAppearance(toEdit: false)
        tblEvents.tableFooterView = nil
        saveView.isHidden = true
        editView.isUserInteractionEnabled = true
        editView.alpha = 1.0
    }
    func updateEmployeeDetails(){
        var employee = UpdateEmployee()
        
        for (i,week) in (self.selectedPayPeriod?.weeks ?? [Weeks]()).enumerated(){
            for (j,_) in (week.timesheet ?? [Timesheet]()).enumerated(){
//                let events = self.selectedPayPeriod?.weeks?[i].timesheet?[i].events?.filter({$0.timelineTime != ""})
                let events = self.selectedPayPeriod?.weeks?[i].timesheet?[j].events?.filter({$0.timelineTime != ""})
                self.selectedPayPeriod?.weeks?[i].timesheet?[j].events = events
                print(self.selectedPayPeriod?.weeks?[i].timesheet?[j].events?.toJSON() ?? "")
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
        employee.empUsername = txtUsername.text!
        employee.empJobTitle = txtjobtitle.text!
        employee.empPassword = txtPassword.text!
        employee.empWorkEmail = txtEmail.text!
        employee.empID = self.employeeDetails?.empId?.stringValue ?? ""
        employee.timezone = Defaults.shared.currentUser?.merchantTimezone ?? ""
//        employee.empPassword =  self.employeeDetails?.empPassword ?? ""
        updateEmployeeAPI(employee:employee)
    }
    
    func updateEmployeeAPI(employee:UpdateEmployee){
        print(employee.getParam())
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.updateEmployees(), param: employee.getParam(), header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                print(res)
                if let status = res["status"] as? Int , status == 1{
                    SucessPopupVC.showSuccessPopup(prevVC: self,titleStr: "Success" , strSubTitle: "Your changes were saved!") { done in
                        self.fetchEmployeeDetails()
                }
                    
                }
            }else if let err = error{
                print(err)
            }
        }
    }
    
    func deleteEmployeeAPI(){
        var employee = DeleteEmployee()
        employee.empID = self.employeeDetails?.empId?.stringValue ?? ""
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.deleteEmployees(), param: employee.getParam(), header: Defaults.shared.header ?? ["":""]) { success, response, error in
            
            if let res = response{
                if let status = res["status"] as? Int{
                    if status == 0{
                        //Fail
                        self.showAlert(alertType:.validation, message: "There was some error while deleting employee, Please try again.")
                    }else{
                        //Success
                        SucessPopupVC.showSuccessPopup(prevVC: self,titleStr: "Success!" , strSubTitle: "Employee was deleted successfully.") { done in
                            //Go to previous scree
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
        if self.isEditMode == true{
            let timesheet = Timesheet().addEventsForDay(date:nil)
            self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.tag].timesheet?.append(timesheet)
            
            //        self.tblEvents.reloadData()
            self.setupTableViewHeightWithReload()
            self.collectionViewEvents.reloadData()
            selectedWeekIndex = sender.tag
        }
    }
    @objc func changeDateSelected(sender:MyButton) {

        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
//        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
        cell.weekDaysPopupView.isHidden = false
        cell.isChangeDate = true

//        item.weekDaysPopupView.isHidden = false
//        item.isChangeDate = true
    }
    @objc func moreOptionClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
//        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
       // cell.mainView.isHidden = true
        cell.addshiftMainView.isHidden = false
//        item.addshiftMainView.isHidden = false
    }
    
    @objc func addShiftClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
//        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
      //  cell.mainView.isHidden = false
        cell.addshiftMainView.isHidden = true
//        item.addshiftMainView.isHidden = true
        
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].addShiftForDay()
//        self.tblEvents.reloadRows(at:[indexpath], with: .none)
        self.setupTableViewHeightWithReload()
//        collectionViewEvents.reloadItems(at: [indexpathCVCell])
    }
    @objc func addBreakClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
//        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
      //  cell.mainView.isHidden = false
        cell.addshiftMainView.isHidden = true
//        item.addshiftMainView.isHidden = true
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex].addBreaksForDay()
       
//        self.tblEvents.reloadRows(at:[indexpath], with: .none)
        self.setupTableViewHeightWithReload()
//        collectionViewEvents.reloadItems(at: [indexpathCVCell])
    }
    @objc func deleteSheetClicked(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell
//        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
        cell.addshiftMainView.isHidden = true
//        item.addshiftMainView.isHidden = true
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?.remove(at:sender.timeSheetIndex)
       
//        self.tblEvents.reloadData()
        self.setupTableViewHeightWithReload()
//        collectionViewEvents.reloadData()
    }
    @objc func addShiftMainViewBack(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell

        cell.addshiftMainView.isHidden = true
        
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
//        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
//        item.addshiftMainView.isHidden = true
    }
    
    @objc func addShiftMainViewCancel(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        let cell = tblEvents.cellForRow(at: indexpath) as! TimeReportCell

        cell.addshiftMainView.isHidden = true
        
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
//        let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as! TimeReportCVCell
//        item.addshiftMainView.isHidden = true
    }
    
    @objc func selectWeekdayViewBack(sender:MyButton) {
        let indexpath = IndexPath(row:sender.timeSheetIndex + 1, section: sender.weekIndex)
        if let cell = tblEvents.cellForRow(at: indexpath) as? TimeReportCell{
            cell.weekDaysPopupView.isHidden = true
            if cell.isChangeDate == false{
//                self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet?.remove(at:sender.timeSheetIndex)
                self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?.remove(at:sender.timeSheetIndex)
            }
//            self.tblEvents.reloadData()
            self.setupTableViewHeightWithReload()
        }
      
        
        
        let indexpathCVCell = IndexPath(item: sender.timeSheetIndex + 1, section: sender.weekIndex)
//        if let item = collectionViewEvents.cellForItem(at: indexpathCVCell) as? TimeReportCVCell{
//            item.weekDaysPopupView.isHidden = true
//
//
//
//            if item.isChangeDate == false{
//                self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet?.remove(at:sender.timeSheetIndex)
//            }
//
//
//            collectionViewEvents.reloadData()
//        }
       
       
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
//                self.tblEvents.reloadRows(at: [indexpath], with: .none)
                self.setupTableViewHeightWithReload()
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
//        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[self.selectedWeekIndex].timesheet?[sender.timeSheetIndex] = timesheet
        self.payPeriodsData[self.selectedPayPeriodIndex].weeks?[sender.weekIndex].timesheet?[sender.timeSheetIndex] = timesheet

//        self.tblEvents.reloadData()
        self.setupTableViewHeightWithReload()
//        self.collectionViewEvents.reloadData()
        self.weekDaysPopupView.isHidden = true
       
    }
    @IBAction func editTooltipOkClicked(){
        self.editTooltipView.isHidden = true
    }
    
    //SelectionButtons
    @IBAction func btnBackProfileSelectionTapped(_ sender: Any) {
        if employeeProfileSelectionView.isHidden == false{
            self.popVC()
        }
        else{
            editView.isHidden =  true
            employeeProfileSelectionView.isHidden = false
            userinformationView.isHidden = true
            timereportView.isHidden = true
        }
        
    }
    
    @IBAction func btnUserInfoTapped(_ sender: Any) {
        editView.isHidden = false
        employeeProfileSelectionView.isHidden = true
        userinformationView.isHidden = false
        timereportView.isHidden = true
    }
    
    @IBAction func btnTimesheetTapped(_ sender: Any) {
        editView.isHidden = false
        employeeProfileSelectionView.isHidden = true
        userinformationView.isHidden = true
        timereportView.isHidden = false
    }
    
    @IBAction func btnDeleteEmployeeTapped(_ sender: Any) {
        DeleteEmployeePopupVC.showDeleteEmployeePopup(prevVC: self) { isDeleteTapped in
            if isDeleteTapped{
                //Call Delete API
                self.deleteEmployeeAPI()
            }
        }
    }
}

extension EmployeeTimeReportVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if editView.alpha == 1.0{
            editTooltipView.isHidden = false
            textField.resignFirstResponder()
        }
        else{
            if textField == txtPassword{
                self.updatePasswordValidation(str:textField.text!)
                self.passwordValidationView.isHidden = false
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPassword{
            self.updatePasswordValidation(str:textField.text!)
            self.passwordValidationView.isHidden = true
        }
        textField.resignFirstResponder()
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if editView.alpha == 1.0{
            //show tooltip
            return false
        }
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
                isPasswordValidTotalCount = true
            }else{
                imgvwminimumCharacter.image = UIImage.unselectedImage
                isPasswordValidTotalCount = false
            }
           let capitalLetterRegEx  = ".*[A-Z]+.*"
           let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
            if texttest.evaluate(with: str){
                imgvwCapitalLetter.image = UIImage.selectedImage
                isPasswordValidCapitalChar = true
            }else{
                imgvwCapitalLetter.image = UIImage.unselectedImage
                isPasswordValidCapitalChar = false
            }
          
            let lowercaseLetterRegEx  = ".*[a-z]+.*"
            let texttest3 = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegEx)
             if texttest3.evaluate(with: str){
                 imgvwLowercaseLetter.image = UIImage.selectedImage
                 isPasswordValidSmallChar = true
             }else{
                 imgvwLowercaseLetter.image = UIImage.unselectedImage
                 isPasswordValidSmallChar = false
             }

           let numberRegEx  = ".*[0-9]+.*"
           let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            if texttest1.evaluate(with: str){
                imgvwNumber.image = UIImage.selectedImage
                isPasswordValidNumberChar = true
            }else{
                imgvwNumber.image = UIImage.unselectedImage
                isPasswordValidNumberChar = false
            }

           let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
           let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            if texttest2.evaluate(with: str){
                imgvwSpecialCharacter.image = UIImage.selectedImage
                isPasswordValidSpecialChar = true
            }else{
                imgvwSpecialCharacter.image = UIImage.unselectedImage
                isPasswordValidSpecialChar = false
            }
        
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
            let weekToBefore = Calendar.current.date(byAdding: .day, value: -1, to: weekTo)!
            let startweek =  weekFrom.getString(formatter:DateTimeFormat.MMM_dd_yyyy.rawValue)
            let endweek =  weekToBefore.getString(formatter:DateTimeFormat.MMM_dd_yyyy.rawValue)
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
//            cell.btnAddTimesheet.tag = indexPath.section
//            cell.btnAddTimesheet.addTarget(self, action:#selector(self.addTimesheetClicked(sender:)), for: .touchUpInside)
            
            cell.weeklyOverTimeView.isHidden = true
//            if merchantData?.merchantWeeklyOvertimeEnabled ?? "" == "Y"{
//                cell.weeklyOverTimeView.isHidden = false
//            }else{
//                cell.weeklyOverTimeView.isHidden = true
//            }
           
           
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
            
//            cell.btncloseWeekday.addTarget(self, action:#selector(self.selectWeekdayViewBack(sender:)), for: .touchUpInside)
//            cell.btncloseWeekday.tag = indexPath.section
//            cell.btncloseWeekday.timeSheetIndex = indexPath.row - 1
//            cell.btncloseWeekday.weekIndex = indexPath.section
//
//            cell.btnBackWeekday.addTarget(self, action:#selector(self.selectWeekdayViewBack(sender:)), for: .touchUpInside)
//            cell.btnBackWeekday.tag = indexPath.section
//            cell.btnBackWeekday.timeSheetIndex = indexPath.row - 1
//            cell.btnBackWeekday.weekIndex = indexPath.section
            
            
            
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
                let weekToBefore = Calendar.current.date(byAdding: .day, value: -1, to: weekTo)!
                let startweek =  weekFrom.getString(formatter:DateTimeFormat.MMMM_dd_yyyy.rawValue)
                let endweek =  weekToBefore.getString(formatter:DateTimeFormat.MMMM_dd_yyyy.rawValue)
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
//                cell.btnAddTimesheet.tag = indexPath.section
//                cell.btnAddTimesheet.addTarget(self, action:#selector(self.addTimesheetClicked(sender:)), for: .touchUpInside)
                cell.weeklyOverTimeView.isHidden = true
//                if merchantData?.merchantWeeklyOvertimeEnabled ?? "" == "Y"{
//                    cell.weeklyOverTimeView.isHidden = false
//                }else{
//                    cell.weeklyOverTimeView.isHidden = true
//                }
//                cell.showAddDayOption(needToShow: isEditMode)
                cell.showAddDayOption(needToShow: false)
                cell.button.tag = indexPath.section
                cell.button.addTarget(self, action:#selector(self.addTimesheetClicked(sender:)), for: .touchUpInside)
                if self.isEditMode == true{
                    cell.button.setBackgroundColor(UIColor.Color.appBlueColor2, forState: .normal)
                }
                else{
                    cell.button.setBackgroundColor(UIColor.init(hex: "B6C2D0"), forState: .normal)
                }
//                if self.selectedPayPeriod?.payperiodStatus == "A" {
//                    cell.button.setTitle("APPROVED", for: .normal)
//                }
//                else{
//                    cell.button.setTitle("UNAPPROVED", for: .normal)
//                }
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
                cell.setMoreButtonStatus(needToEnable: self.isEditMode)
                
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
                
                cell.btnCancel.addTarget(self, action:#selector(self.addShiftMainViewCancel(sender:)), for: .touchUpInside)
                cell.btnCancel.tag = indexPath.section
                cell.btnCancel.timeSheetIndex = indexPath.row - 1
                cell.btnCancel.weekIndex = indexPath.section
                
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
                dateFormatter.timeZone = TimeZone.current
                let fromDate = dateFormatter.date(from:selectedWeek?.weekFrom ??
                                                  "") ?? Date()
                let toDate = dateFormatter.date(from:selectedWeek?.weekTo ??
                "") ?? Date()
                
                var excludeDates : [Date] = []
                for timesheet in selectedWeek?.timesheet ?? [] {
                    let addedDate = dateFormatter.date(from:timesheet.date ??
                                                      "") ?? Date()
                    excludeDates.append(addedDate)
                }
                
                let dates = (Date.dates(from:fromDate, to: toDate))
                let datesWithExcluded = (Date.dates(from:fromDate, to: toDate ,excludeDates: excludeDates))
                print("AAA:",datesWithExcluded)
                cell.setWeekDays(days:datesWithExcluded)
                self.weekDates = datesWithExcluded
                cell.weekDates = datesWithExcluded
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
    
    func getPendingDaysOfWeek(){
        
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
      
        let eventDate = event?.timelineDate?.toDate()
        
        picker.datePickerMode = UIDatePicker.Mode.time
    
        let dateFormatter = DateFormatter()
      
        dateFormatter.dateFormat = kMMddYYYYhhmmss
        picker.setDate(dateFormatter.date(from:time) ?? eventDate!, animated: true)
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
        let cal = Calendar.gregorian
        let order = cal.compare(Date.now, to: date, toGranularity: .minute)
        if order == .orderedAscending{
            self.showAlert(alertType:.validation, message: "Time cannot be in future.")
        }
        else{
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
                    if subview.text != "Select Date"{
                        subview.text = event?.timelineValue
                        
                    }
                }
            }
            let indexpathCell = IndexPath(row:timeSheetIndex + 1, section: weekIndex)
            let indexpathCVCell = IndexPath(item: timeSheetIndex + 1, section: weekIndex)
            //        tblEvents.reloadRows(at: [indexpathCell], with: .none)
            self.setupTableViewHeightWithReload()
            //        collectionViewEvents.reloadItems(at: [indexpathCVCell])
            
            let indexpathHeader = IndexPath(row:0, section: weekIndex)
            //        tblEvents.reloadRows(at: [indexpathHeader], with: .none)
            self.setupTableViewHeightWithReload()
        }
        
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
            
            let currentDate =  events.last?.timelineDate?.toDate()
            let strCurrentDate = currentDate?.toString(format: DateTimeFormat.MM_DD_YYYY.rawValue)
                
            
//            if events.last?.timelineTime ?? "" == ""{
//                if (strCurrentDate != nil){
//                    //                self.showAlert(alertType:.validation, message: "Please enter valid time")
//                    self.showAlert(alertType:.validation, message: "Please select events for date \(strCurrentDate ?? "")")
//                }
//                else{
//                    self.showAlert(alertType:.validation, message: "Please select events")
//                }
//                return false
//
//            }
            if event == events.first{
                if event.timelineEvent ?? "" != UserStatus.loggedIN.rawValue{
                    if (strCurrentDate != nil){
                        self.showAlert(alertType:.validation, message: "First event must be Shift Start on date : \(strCurrentDate ?? "")")
                    }
                    else{
                        self.showAlert(alertType:.validation, message: "First event must be Shift Start")
                    }
                   
                    return false
                }else {
                    if event.timelineTime ?? "" == ""{
                        if (strCurrentDate != nil){
                            self.showAlert(alertType:.validation, message: "Please select events for date \(strCurrentDate ?? "")")
                        }
                        else{
                            self.showAlert(alertType:.validation, message: "Please select events")
                        }
                        return false
                    }
                }
            }
            
            if event.timelineEvent ?? "" == UserStatus.loggedOut.rawValue && event.timelineTime ?? "" == ""{
                if (strCurrentDate != nil){
                    self.showAlert(alertType:.validation, message: "Please select events for date \(strCurrentDate ?? "")")
                }
                else{
                    self.showAlert(alertType:.validation, message: "Please select events")
                }
                return false
            }
//            else if event == events.last{
//                if event.timelineEvent ?? "" != UserStatus.loggedOut.rawValue{
//                    if (strCurrentDate != nil){
//                        self.showAlert(alertType:.validation, message: "Last event must be Shift End on date : \(strCurrentDate ?? "")")
//                    }
//                    else{
//                        self.showAlert(alertType:.validation, message: "Last event must be Shift End")
//                    }
//                    return false
//                }
//            }
            
            if events.count > i + 1{
                
                
                let eventTypeMessage = self.getEventTypeMessage(eventType: events[i+1].timelineEvent ?? "")
                
                
                
                if currentEventType == UserStatus.loggedIN.rawValue{
                    let nextEventType = events[i + 1].timelineEvent ?? ""
                    if nextEventType == UserStatus.loggedOut.rawValue || nextEventType == UserStatus.Inbreak.rawValue{
                       
                    }else{
                        if (strCurrentDate != nil){
                            self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage) on date : \(strCurrentDate ?? "")")
                        }
                        else{
                            self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage)")
                        }
                        
                        return false
                    }
                }else if currentEventType == UserStatus.loggedOut.rawValue{
                    let nextEventType = events[i + 1].timelineEvent ?? ""
                    if nextEventType == UserStatus.loggedIN.rawValue{
                       
                    }else{
                        if events[i + 1].timelineTime ?? "" != ""{
                            if (strCurrentDate != nil){
                                self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage) on date : \(strCurrentDate ?? "")")
                            }
                            else{
                                self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage)")
                            }
                            return false
                        }
                    }
                }else if currentEventType == UserStatus.Inbreak.rawValue{
                    let nextEventType = events[i + 1].timelineEvent ?? ""
                    if nextEventType == UserStatus.Endbreak.rawValue{
                       
                    }else{
                        if events[i + 1].timelineTime ?? "" != ""{
                            if (strCurrentDate != nil){
                                self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage) on date : \(strCurrentDate ?? "")")
                            }
                            else{
                                self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage)")
                            }
                            
                            return false
                        }
                    }
                }else if currentEventType == UserStatus.Endbreak.rawValue{
                    let nextEventType = events[i + 1].timelineEvent ?? ""
                    if nextEventType == UserStatus.loggedOut.rawValue {
                       
                    }else{
                        if events[i + 1].timelineTime ?? "" != ""{
                            if (strCurrentDate != nil){
                                self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage) on date : \(strCurrentDate ?? "")")
                            }
                            else{
                                self.showAlert(alertType:.validation, message: "\(eventTypeMessage) should not be after \(currentEventTypeMessage)")
                            }
                            
                            return false
                        }
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
extension EmployeeTimeReportVC: CustomMenuItemDelegate {
    func customMenuItemClicked(menuName: String) {
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

extension EmployeeTimeReportVC : UIScrollViewDelegate{
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print( scrollView.contentOffset.y)
         let scrollY = scrollView.contentOffset.y
         if scrollY > 65{
             constTopEditTooltip.constant = 0.0
         }
         else{
             constTopEditTooltip.constant = 65.0 - scrollY
         }
         
//
//        let delta =  scrollView.contentOffset.y - oldContentOffset.y
//
//        //we compress the top view
//        if delta > 0 && topConstraint.constant > topConstraintRange.start && scrollView.contentOffset.y > 0 {
//            topConstraint.constant -= delta
//            scrollView.contentOffset.y -= delta
//        }
//
//        //we expand the top view
//        if delta < 0 && topConstraint.constant < topConstraintRange.end && scrollView.contentOffset.y < 0{
//            topConstraint.constant -= delta
//            scrollView.contentOffset.y -= delta
//        }
//
//        oldContentOffset = scrollView.contentOffset
    }
}
