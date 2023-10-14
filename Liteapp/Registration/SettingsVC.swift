//
//  SettingsVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 12/06/22.
//

import UIKit
import SideMenu
import ObjectMapper
import Alamofire
import IQKeyboardManagerSwift

enum EditSelectedDay:Int{
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
}
enum EditDuration:Int{
    case weekly = 1
    case biWeekly = 2
}
enum Settings:String{
    case timeclock = "TimeClock Settings"
    case account = "Account Settings"
    case userInfo = "User Information"
    case timeSheet = "Timesheets"
}
class SettingsVC:BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
    var menu:SideMenuNavigationController!
    @IBOutlet weak var lblusername: UILabel!
    
    //Popups
    @IBOutlet weak var accountSettingView: UIView!
    @IBOutlet weak var timesheetSettingView: UIView!
    
    @IBOutlet weak var editPayPeriodStartDayView: UIView!
    @IBOutlet weak var editPayPeriodDurationView: UIView!
    @IBOutlet weak var editWeeklyOvertimeView: UIView!
    @IBOutlet weak var editdailyOvertimeView: UIView!
    
    @IBOutlet weak var btnSunday: UIButton!
    @IBOutlet weak var btnMonday: UIButton!
    @IBOutlet weak var btnTuesday: UIButton!
    @IBOutlet weak var btnWednesday: UIButton!
    @IBOutlet weak var btnThursday: UIButton!
    @IBOutlet weak var btnFriday: UIButton!
    @IBOutlet weak var btnSaturday: UIButton!
    
    @IBOutlet weak var btnWeekly: UIButton!
    @IBOutlet weak var btnBiWeekly: UIButton!
    
    @IBOutlet weak var selectCurrentPayWeek: UIView!
    @IBOutlet weak var btnWeek1: UIButton!
    @IBOutlet weak var btnWeek2: UIButton!
    
    @IBOutlet weak var switchWeeklyOvertime: UISwitch!
    @IBOutlet weak var switchDailyOvertime: UISwitch!
    @IBOutlet weak var switchSplitShift: UISwitch!
    
    @IBOutlet weak var continueButtonStep1: UIButton!
    @IBOutlet weak var continueButtonStep2: UIButton!
    
    @IBOutlet weak var txtEditPopupWeeklyOvertimeHours: UITextField!
    @IBOutlet weak var txtEditPopupDailyOvertimeHours: UITextField!
    
    @IBOutlet weak var continueButtonStep4: UIButton!
    @IBOutlet weak var skipEditWeeklyHours: UIButton!
    
    @IBOutlet weak var continueButtonStep3: UIButton!
    @IBOutlet weak var skipEditDailyHours: UIButton!
    
    //Congratulation & Success popup
    @IBOutlet weak var congratulationsPopup: UIView!
    @IBOutlet weak var successPopup: UIView!
    
    //MainView
    @IBOutlet weak var editWeeklyOvertimeHoursView: UIView!
    @IBOutlet weak var txteditWeeklyOvertimeHours: UITextField!
    
    @IBOutlet weak var editdailyOvertimeHoursView: UIView!
    @IBOutlet weak var txteditdailyOvertimeHours: UITextField!
    
    @IBOutlet weak var selectWeekStartdayView: UIView!
    @IBOutlet weak var txtselectWeekStartday: UITextField!
    @IBOutlet weak var btnselectWeekStartday: UIButton!
    
    @IBOutlet weak var selectPayPeriodView: UIView!
    @IBOutlet weak var txtselectPayPeriod: UITextField!
    @IBOutlet weak var btnselectPayPeriod: UIButton!
    
    @IBOutlet weak var blurOverlayView: UIView!
    
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editTooltipView: UIView!
    
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
    
   
    @IBOutlet weak var selectWeekView: UIView!
    
    @IBOutlet weak var timesheetStackView: UIStackView!
    @IBOutlet weak var accountStackView: UIStackView!
   
//    @IBOutlet weak var txtSelectSettings: UITextField!
    
    //Business Settings
    @IBOutlet var businessSettingsView: UIView!
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var txtBusinessTimezone: UITextField!
    @IBOutlet weak var txtBusinessWebsite: UITextField!
    @IBOutlet weak var txtTotalEmployee: UITextField!
    
    //Selection View
    @IBOutlet var viewSelection: UIView!
    @IBOutlet weak var tblSelection: UITableView!
    
    @IBOutlet weak var customNavView: UIView!
    var menuV : CustomMenuView!
    @IBOutlet weak var btnMenu: UIButton!
    
    @IBOutlet weak var viewBiweeklySelection: UIView!
    @IBOutlet weak var btnWeek1Option: UIButton!
    @IBOutlet weak var btnWeek2Option: UIButton!
    
    @IBOutlet weak var btnDeleteMyAccount: UIButton!
    
    @IBOutlet weak var lblSettings: UILabel!
    @IBOutlet weak var lblEdit: UILabel!
    @IBOutlet weak var lblAccountSettings: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblTimeClockSettings: UILabel!
    @IBOutlet weak var lblSplitShift: UILabel!
    @IBOutlet weak var lblSplitShiftDesc: UILabel!
    @IBOutlet weak var lblWeeklyOvertime: UILabel!
    @IBOutlet weak var lblWeeklyOvertimeDesc: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblHour1: UILabel!
    @IBOutlet weak var lblHour2: UILabel!
    @IBOutlet weak var lblDailyOvertime: UILabel!
    @IBOutlet weak var lblDailyOvertimeDesc: UILabel!
    @IBOutlet weak var lblPayPeriod: UILabel!
    @IBOutlet weak var lblPayPeriodDesc: UILabel!
    @IBOutlet weak var lblPayPeriodWeek: UILabel!
    @IBOutlet weak var lblPayPeriodWeekDesc: UILabel!
    @IBOutlet weak var lblPayPeriodStart: UILabel!
    @IBOutlet weak var lblPayPeriodStartDesc: UILabel!
    @IBOutlet weak var lblBusinessSettings: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var businessUrlLabel: UILabel!
    @IBOutlet weak var businessEmployeeCountLabel: UILabel!
    @IBOutlet weak var editModeTitleLabel: UILabel!
    @IBOutlet weak var editModeDescLabel: UILabel!
    @IBOutlet weak var editModeOkButton: UIButton!
    @IBOutlet weak var step1TitleLabel: UILabel!
    @IBOutlet weak var step1DecsLabel: UILabel!
    @IBOutlet weak var step2TitleLabel: UILabel!
    @IBOutlet weak var step2DecsLabel: UILabel!
    @IBOutlet weak var biWeeklySelectionLabel: UILabel!
    @IBOutlet weak var step3TitleLabel: UILabel!
    @IBOutlet weak var step3DecsLabel: UILabel!
    @IBOutlet weak var step4TitleLabel: UILabel!
    @IBOutlet weak var step4DecsLabel: UILabel!
    @IBOutlet weak var weeklyOvertimeAfterLabel: UILabel!
    @IBOutlet weak var dailyOvertimeAfterLabel: UILabel!
    @IBOutlet weak var saveViewCancelButton: UIButton!
    @IBOutlet weak var saveViewSaveButton: UIButton!
    @IBOutlet weak var successViewContinueButton: UIButton!
    @IBOutlet weak var successViewCloseButton: UIButton!
    @IBOutlet weak var successTitleLabel: UILabel!
    @IBOutlet weak var successDecsLabel: UILabel!
    @IBOutlet weak var congoContinueButton: UIButton!
    @IBOutlet weak var congoTitleLabel: UILabel!
    @IBOutlet weak var congoDecsLabel: UILabel!
    @IBOutlet weak var imgUserName:UIImageView!
    
    var setupMerchant:SetupMerchant!
    var merchantSettings:MerchantSettings?
    var editDaySelected:EditSelectedDay?
    var editDurationSelected:EditDuration?
    var setupProfile:Bool = false
    var isForAccountSettings : Bool = false
    var employeeDetails:EmployeeDetails?
    
    var weekDaysArray = [NSLocalizedString("Sunday", comment: "btnSunday"),NSLocalizedString("Monday", comment: "btnMonday"),NSLocalizedString("Tuesday", comment: "btnTuesday"),NSLocalizedString("Wednesday", comment: "btnWednesday"),NSLocalizedString("Thursday", comment: "btnThursday"),NSLocalizedString("Friday", comment: "btnFriday"),NSLocalizedString("Saturday", comment: "btnSaturday")]
    var durationOptions = [NSLocalizedString("Weekly", comment: "btnWeekly"),NSLocalizedString("Biweekly", comment: "btnBiweekly")]
    var arrNoOfEmps = ["1 - 4","5 - 19","20 - 99","100 - 499","100 - 499","500+"]
    var settingsArray = ["TimeClock Settings","Account Settings"]
    
    var selectedSettings:Settings = .timeclock
    var arrSettings : [[String : String]] = []
    
    var wasAppKilledWhenSettingsIncomplete : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblSettings.text = "\(self.employeeDetails?.empFirstname ?? "") \(self.employeeDetails?.empLastname ?? "")"
        lblEdit.text = NSLocalizedString("Edit", comment: "lblEdit")
        lblAccountSettings.text = NSLocalizedString("Account Settings", comment: "lblAccountSettings")
        lblFirstName.text = NSLocalizedString("First Name", comment: "firstNameLabel")
        lblLastName.text = NSLocalizedString("Last Name", comment: "lastNameLabel")
        lblEmail.text = NSLocalizedString("Email", comment: "emailLabel")
        lblUserName.text = NSLocalizedString("Username", comment: "userNameLabel")
        lblPassword.text = NSLocalizedString("Password", comment: "passwordLabel")
        btnChange.setTitle(NSLocalizedString("Change", comment: "btnChange"), for: .normal)
        lblTimeClockSettings.text = NSLocalizedString("TimeClock Settings", comment: "lblTimeClockSettings")
        lblSplitShift.text = NSLocalizedString("Split Shift", comment: "lblSplitShift")
        lblSplitShiftDesc.text = NSLocalizedString("Employees working past midnight will have their shifts split into pre- and post-midnight parts instead of automatically being clocked out at midnight.", comment: "lblSplitShiftDesc")
        lblWeeklyOvertime.text = NSLocalizedString("Weekly Overtime", comment: "lblWeeklyOvertime")
        lblWeeklyOvertimeDesc.text = NSLocalizedString("Define number of hours needed to work within a workweek before overtime accrual begins.", comment: "lblWeeklyOvertimeDesc")
        lblHour.text = NSLocalizedString("Hours", comment: "lblHour")
        lblHour1.text = NSLocalizedString("Hours", comment: "lblHour1")
        lblHour2.text = NSLocalizedString("Hours", comment: "lblHour2")
        lblDailyOvertime.text = NSLocalizedString("Daily Overtime", comment: "lblDailyOvertime")
        lblDailyOvertimeDesc.text = NSLocalizedString("Define number of hours needed to work within a workday before overtime accrual begins.", comment: "lblDailyOvertimeDesc")
        lblPayPeriod.text = NSLocalizedString("Pay Period", comment: "lblPayPeriod")
        lblPayPeriodDesc.text = NSLocalizedString("Defines the pay period. Options are weekly , biweekly.", comment: "lblPayPeriodDesc")
        lblPayPeriodWeek.text = NSLocalizedString("Current Pay Period Week", comment: "lblPayPeriodWeek")
        lblPayPeriodWeekDesc.text = NSLocalizedString("Define which week of the pay period you’re currently in.", comment: "lblPayPeriodWeekDesc")
        lblPayPeriodStart.text = NSLocalizedString("Pay Period Start Day", comment: "lblPayPeriodStart")
        lblPayPeriodStartDesc.text = NSLocalizedString("Define the day of the week the pay period begins.", comment: "lblPayPeriodStartDesc")
        lblBusinessSettings.text = NSLocalizedString("BUSINESS SETTINGS", comment: "lblBusinessSettings")
        businessNameLabel.text = NSLocalizedString("Business Name", comment: "businessNameLabel")
        txtBusinessName.placeholder = NSLocalizedString("Business Name", comment: "txtBusinessName")
        zipCodeLabel.text = NSLocalizedString("Zipcode", comment: "zipCodeLabel")
        txtZipCode.placeholder = NSLocalizedString("Zipcode", comment: "txtZipcode")
        timeZoneLabel.text = NSLocalizedString("Timezone", comment: "timeZoneLabel")
        txtBusinessTimezone.placeholder = NSLocalizedString("Select Timezone", comment: "txtTimezone")
        businessUrlLabel.text = NSLocalizedString("Business Website", comment: "businessUrlLabel")
        txtBusinessWebsite.placeholder = NSLocalizedString("Business Website", comment: "txtBusinessURL")
        businessEmployeeCountLabel.text = NSLocalizedString("How many people do you employ?", comment: "businessTitleLabel")
        txtTotalEmployee.placeholder = NSLocalizedString("Total Employees", comment: "txtTotalEmployee")
        editModeTitleLabel.text = NSLocalizedString("EDIT MODE", comment: "editModeTitleLabel")
        editModeDescLabel.text = NSLocalizedString("If you would like to make changes, please go into edit mode by selecting the edit button at the top of the page", comment: "editModeDescLabel")
        editModeOkButton.setTitle(NSLocalizedString("OK", comment: "editModeOkButton"), for: .normal)
        step1TitleLabel.text = NSLocalizedString("Step 1 of 3", comment: "step1TitleLabel")
        step1DecsLabel.text = NSLocalizedString("What day does your Pay Period start on?", comment: "step1DecsLabel")
        btnSunday.setTitle(NSLocalizedString("Sunday", comment: "btnSunday"), for: .normal)
        btnMonday.setTitle(NSLocalizedString("Monday", comment: "btnMonday"), for: .normal)
        btnTuesday.setTitle(NSLocalizedString("Tuesday", comment: "btnTuesday"), for: .normal)
        btnWednesday.setTitle(NSLocalizedString("Wednesday", comment: "btnWednesday"), for: .normal)
        btnThursday.setTitle(NSLocalizedString("Thursday", comment: "btnThursday"), for: .normal)
        btnFriday.setTitle(NSLocalizedString("Friday", comment: "btnFriday"), for: .normal)
        btnSaturday.setTitle(NSLocalizedString("Saturday", comment: "btnSaturday"), for: .normal)
        continueButtonStep1.setTitle(NSLocalizedString("Continue", comment: "continueButtonStep1"), for: .normal)
        step2TitleLabel.text = NSLocalizedString("Step 2 of 3", comment: "step2TitleLabel")
        step2DecsLabel.text = NSLocalizedString("What is your Pay Period Duration ?", comment: "step2DecsLabel")
        btnWeekly.setTitle(NSLocalizedString("Weekly", comment: "btnWeekly"), for: .normal)
        btnBiWeekly.setTitle(NSLocalizedString("Bi-Weekly", comment: "btnBiWeekly"), for: .normal)
        biWeeklySelectionLabel.text = NSLocalizedString("Which Pay Period are you currently in?", comment: "biWeeklySelectionLabel")
        btnWeek1.setTitle(NSLocalizedString("Week 1", comment: "btnWeek1"), for: .normal)
        btnWeek2.setTitle(NSLocalizedString("Week 2", comment: "btnWeek2"), for: .normal)
        btnWeek1Option.setTitle(NSLocalizedString("Week 1", comment: "btnWeek1"), for: .normal)
        btnWeek2Option.setTitle(NSLocalizedString("Week 2", comment: "btnWeek2"), for: .normal)
        continueButtonStep2.setTitle(NSLocalizedString("Continue", comment: "continueButtonStep2"), for: .normal)
        step3TitleLabel.text = NSLocalizedString("Step 3 of 5", comment: "step3TitleLabel")
        step3DecsLabel.text = NSLocalizedString("What is your weekly overtime hours ?", comment: "step3DecsLabel")
        skipEditWeeklyHours.setTitle(NSLocalizedString("Skip for right now", comment: "skipEditWeeklyHours"), for: .normal)
        continueButtonStep3.setTitle(NSLocalizedString("Continue", comment: "continueButtonStep3"), for: .normal)
        step4TitleLabel.text = NSLocalizedString("Step 3 of 3", comment: "step4TitleLabel")
        step4DecsLabel.text = NSLocalizedString("How do you calculate overtime?", comment: "step4DecsLabel")
        weeklyOvertimeAfterLabel.text = NSLocalizedString("Weekly overtime after:", comment: "weeklyOvertimeAfterLabel")
        dailyOvertimeAfterLabel.text = NSLocalizedString("Daily overtime after: (AK, CA, CO, NV)", comment: "dailyOvertimeAfterLabel")
        skipEditDailyHours.setTitle(NSLocalizedString("Skip for right now", comment: "skipEditDailyHours"), for: .normal)
        continueButtonStep4.setTitle(NSLocalizedString("Continue", comment: "continueButtonStep4"), for: .normal)
        saveViewCancelButton.setTitle(NSLocalizedString("Cancel", comment: "saveViewCancelButton"), for: .normal)
        saveViewSaveButton.setTitle(NSLocalizedString("Save", comment: "saveViewSaveButton"), for: .normal)
        successViewContinueButton.setTitle(NSLocalizedString("Continue", comment: "successViewContinueButton"), for: .normal)
        successViewCloseButton.setTitle(NSLocalizedString("Close", comment: "successViewCloseButton"), for: .normal)
        successTitleLabel.text = NSLocalizedString("Success!", comment: "successTitleLabel")
        successDecsLabel.text = NSLocalizedString("Your settings were saved. Let's add your employees now.", comment: "successDecsLabel")
        congoContinueButton.setTitle(NSLocalizedString("Continue", comment: "congoContinueButton"), for: .normal)
        congoTitleLabel.text = NSLocalizedString("Congratulations!", comment: "congoTitleLabel")
        congoDecsLabel.text = NSLocalizedString("Your account is complete. Let's understand your pay period and overtime settings", comment: "congoDecsLabel")
        btnDeleteMyAccount.setTitle(NSLocalizedString("Delete My Account", comment: "btnDeleteMyAccount"), for: .normal)
        txtEditPopupWeeklyOvertimeHours.textColor = UIColor.black
        txtEditPopupDailyOvertimeHours.textColor = UIColor.black
        setUI()
        setupMenu()
        
    }
    func setUI(){
        
        if let empType = Defaults.shared.currentUser?.empType{
            if empType == "S"{
                btnDeleteMyAccount.isHidden = false
            }
            else{
                btnDeleteMyAccount.isHidden = true
            }
        }
        
        editdailyOvertimeView.dropShadow()
        lblusername.text = Utility.getNameInitials()
        
        btnSunday.tag = 0
        btnMonday.tag = 1
        btnTuesday.tag = 2
        btnWednesday.tag = 3
        btnThursday.tag = 4
        btnFriday.tag = 5
        btnSaturday.tag = 6
        
        btnSunday.setBackgroundColor(.white, forState: .normal)
        btnSunday.setBackgroundColor(UIColor.Color.appBlueColor, forState: .selected)
        btnSunday.setTitleColor(.darkGray, for: .selected)
        btnSunday.setTitleColor(.white, for: .selected)
        
        btnMonday.setBackgroundColor(UIColor.Color.appBlueColor, forState: .selected)
        btnMonday.setBackgroundColor(.white, forState: .normal)
        btnMonday.setTitleColor(.darkGray, for: .selected)
        btnMonday.setTitleColor(.white, for: .selected)
        
        btnTuesday.setBackgroundColor(UIColor.Color.appBlueColor, forState: .selected)
        btnTuesday.setBackgroundColor(.white, forState: .normal)
        btnTuesday.setTitleColor(.darkGray, for: .selected)
        btnTuesday.setTitleColor(.white, for: .selected)
        
        btnWednesday.setBackgroundColor(UIColor.Color.appBlueColor, forState: .selected)
        btnWednesday.setBackgroundColor(.white, forState: .normal)
        btnWednesday.setTitleColor(.darkGray, for: .selected)
        btnWednesday.setTitleColor(.white, for: .selected)
        
        btnThursday.setBackgroundColor(UIColor.Color.appBlueColor, forState: .selected)
        btnThursday.setBackgroundColor(.white, forState: .normal)
        btnThursday.setTitleColor(.darkGray, for: .selected)
        btnThursday.setTitleColor(.white, for: .selected)
        
        btnFriday.setBackgroundColor(UIColor.Color.appBlueColor, forState: .selected)
        btnFriday.setBackgroundColor(.white, forState: .normal)
        btnFriday.setTitleColor(.darkGray, for: .selected)
        btnFriday.setTitleColor(.white, for: .selected)
        
        btnSaturday.setBackgroundColor(UIColor.Color.appBlueColor, forState: .selected)
        btnSaturday.setBackgroundColor(.white, forState: .normal)
        btnSaturday.setTitleColor(.darkGray, for: .selected)
        btnSaturday.setTitleColor(.white, for: .selected)
        
        
        btnWeekly.setBackgroundColor(UIColor.Color.appBlueColor, forState: .selected)
        btnWeekly.setBackgroundColor(.white, forState: .normal)
        btnWeekly.setTitleColor(.darkGray, for: .selected)
        btnWeekly.setTitleColor(.white, for: .selected)
        
        btnBiWeekly.setBackgroundColor(UIColor.Color.appBlueColor, forState: .selected)
        btnBiWeekly.setBackgroundColor(.white, forState: .normal)
        btnBiWeekly.setTitleColor(.darkGray, for: .selected)
        btnBiWeekly.setTitleColor(.white, for: .selected)
       
        btnWeek1.setBackgroundColor(UIColor.Color.appBlueColor2, forState: .selected)
        btnWeek1.setBackgroundColor(.white, forState: .normal)
        btnWeek1.setTitleColor(UIColor(hex:"#393F45"), for: .normal)
        btnWeek1.setTitleColor(UIColor.white, for: .selected)
        

        btnWeek2.setBackgroundColor(UIColor.Color.appBlueColor2, forState: .selected)
        btnWeek2.setBackgroundColor(.white, forState: .normal)
        btnWeek2.setTitleColor(UIColor(hex:"#393F45"), for: .normal)
        btnWeek2.setTitleColor(UIColor.white, for: .selected)
        
        btnWeek1Option.setBackgroundColor(UIColor.Color.appBlueColor2, forState: .selected)
        btnWeek1Option.setBackgroundColor(.white, forState: .normal)
        btnWeek1Option.setTitleColor(UIColor(hex:"#393F45"), for: .normal)
        btnWeek1Option.setTitleColor(UIColor.white, for: .selected)
        btnWeek1Option.isSelected = true
        

        btnWeek2Option.setBackgroundColor(UIColor.Color.appBlueColor2, forState: .selected)
        btnWeek2Option.setBackgroundColor(.white, forState: .normal)
        btnWeek2Option.setTitleColor(UIColor(hex:"#393F45"), for: .normal)
        btnWeek2Option.setTitleColor(UIColor.white, for: .selected)
        self.viewBiweeklySelection.isHidden = true
        
        
        
//        btnWeekly.isSelected = true
        
        btnWeekly.tag = 1
        btnBiWeekly.tag = 2
        
        btnWeek1.tag = 1
        btnWeek2.tag = 2
        
        switchWeeklyOvertime.tag = 1
        switchDailyOvertime.tag = 2
        switchSplitShift.tag = 3
        
        continueButtonStep1.tag = 10
        continueButtonStep2.tag = 20
        continueButtonStep3.tag = 30
        continueButtonStep4.tag = 40
        
//        editWeeklyOvertimeHoursView.isUserInteractionEnabled = false
//        editdailyOvertimeHoursView.isUserInteractionEnabled = false
//        selectWeekStartdayView.isUserInteractionEnabled = false
//        selectPayPeriodView.isUserInteractionEnabled = false
//        editWeeklyOvertimeHoursView.isUserInteractionEnabled = false
//        editdailyOvertimeHoursView.isUserInteractionEnabled = false
//        selectWeekStartdayView.isUserInteractionEnabled = false
//        selectPayPeriodView.isUserInteractionEnabled = false
//        selectCurrentPayWeek.isUserInteractionEnabled = false
//        switchWeeklyOvertime.isUserInteractionEnabled = false
//        switchDailyOvertime.isUserInteractionEnabled = false
//        btnWeek1.isUserInteractionEnabled = false
//        btnWeek2.isUserInteractionEnabled = false
        
//        txtSelectSettings.isUserInteractionEnabled = true
//        self.timesheetSettingView.isHidden = false
        showSettingsView(showAccount: isForAccountSettings)
        
//        self.timesheetStackView.alpha = 0.5
        changeTimesheetAppearance(toEdit: true)
        changeBusinessAppearance(toEdit: true)
//        self.accountStackView.alpha = 0.5
        changeAccountTextfieldsAppearance(toEdit: true)
        self.saveView.isHidden = true
        editView.alpha = 0.0
        
        if self.setupProfile{
            Defaults.shared.settingsPopupStatus = 1
            self.congratulationsPopup.isHidden  = false
        }
        txteditWeeklyOvertimeHours.delegate = self
        txteditdailyOvertimeHours.delegate = self
        txtselectWeekStartday.delegate = self
       // txtselectPayPeriod.delegate = self
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtUserName.delegate = self
        txtemail.delegate = self
        txtpassword.delegate = self
        
        txtBusinessName.delegate = self
        txtZipCode.delegate = self
        txtTotalEmployee.delegate = self
        txtBusinessWebsite.delegate = self
        txtBusinessTimezone.delegate = self
        
        
//        arrSettings = [["title":"Account Settings","subtitle":"General account info","icon":"account_settings"],["title":"Business Settings","subtitle":"Info about your business","icon":"bussiness_settings"],["title":"Timeclock Settings","subtitle":"Settings that affect employees","icon":"timesheet_settings"]]
        arrSettings = [["title":"Business Settings","subtitle":"Info about your business","icon":"bussiness_settings"],["title":"Timeclock Settings","subtitle":"Settings that affect employees","icon":"timesheet_settings"]]
        accountSettingView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchSettings()
        if wasAppKilledWhenSettingsIncomplete == true{
            wasAppKilledWhenSettingsIncomplete = false
            self.setupMerchant = SetupMerchant()
            self.setupMerchant.merchant_id = "\(Defaults.shared.currentUser?.merchantId ?? 0)"
            self.setupMerchant.merchant_current_pay_week = "1"
            self.editPayPeriodStartDayView.isHidden = false
            self.blurOverlayView.isHidden = false
        }
    }
    private func setupMenu(){
//        let controller = MenuViewController.instantiate()
//        controller.delegate = self
//        controller.selectedOption = .Settings
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
        menuV.selectedOption = .Settings
        menuV.selectedOptionEmployee = .Settings
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
    func showSettingsView(showAccount : Bool = false){
        self.viewSelection.isHidden = false
        self.businessSettingsView.isHidden = true
        self.timesheetSettingView.isHidden = true
        //        self.businessSettingsView.isHidden = false
//        self.accountSettingView.isHidden = true
//        if showAccount == true {
//            self.accountSettingView.isHidden = false
//            self.viewSelection.isHidden = true
//        }
    }
    
    @IBAction func menuClicked(sender:UIButton){
//        self.present(menu, animated: true, completion: {})
        menuV.showHideMenu()
        self.btnMenu.isHidden = true
    }
    func callSetupMerchangtAPI(){
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.setupMerchants(), param: setupMerchant.getParam(), header: Defaults.shared.header ?? ["":""]) { success, response, error in
            Defaults.shared.settingsPopupStatus = nil
            if let res = response{
                print(res)
                self.editPayPeriodStartDayView.isHidden = true
                self.editPayPeriodDurationView.isHidden = true
//                self.editWeeklyOvertimeView.isHidden = true
                self.editdailyOvertimeView.isHidden = true
                self.blurOverlayView.isHidden = true
                if let status = res["status"] as? Int{
                    if status == 1{
                        self.successPopup.isHidden = false
                        //Refresh Settings View by calling API
                        self.fetchSettings()
                    }
                }
            }else if let err = error{
                print(err)
                self.editPayPeriodStartDayView.isHidden = true
                self.editPayPeriodDurationView.isHidden = true
//                self.editWeeklyOvertimeView.isHidden = true
                self.editdailyOvertimeView.isHidden = true
                self.blurOverlayView.isHidden = true
            }
        }
    }
    
    func setSelectedDetailsToMerchantSettings(){
        merchantSettings?.empFirstname = self.txtFirstName.text
        merchantSettings?.empLastname = self.txtLastName.text
        merchantSettings?.empUserName = self.txtUserName.text
        merchantSettings?.empWorkEmail = self.txtemail.text
        
      
        if let intOvertimeDaily = Int(self.txteditdailyOvertimeHours.text ?? "") {
            merchantSettings?.merchantDailyOvertime = NSNumber(value:intOvertimeDaily)
        }
        
        if let intOvertimeWeekly = Int(self.txteditWeeklyOvertimeHours.text ?? "") {
            merchantSettings?.merchantWeeklyOvertime = NSNumber(value:intOvertimeWeekly)
        }
        
//        merchantSettings?.merchantPayPeriod = self.txtselectPayPeriod.text?.first?.uppercased() ?? ""
        
//        if self.txtselectWeekStartday.text == "Sunday"{
//            merchantSettings?.merchantWeekStart = 1
//        }else if self.txtselectWeekStartday.text == "Monday"{
//            merchantSettings?.merchantWeekStart = 2
//        }else if self.txtselectWeekStartday.text == "Tuesday"{
//            merchantSettings?.merchantWeekStart = 3
//        }else if self.txtselectWeekStartday.text == "Wednesday"{
//            merchantSettings?.merchantWeekStart = 4
//        }else if self.txtselectWeekStartday.text == "Thursday"{
//            merchantSettings?.merchantWeekStart = 5
//        }else if self.txtselectWeekStartday.text == "Friday"{
//            merchantSettings?.merchantWeekStart = 6
//        }else if self.txtselectWeekStartday.text == "Saturday"{
//            merchantSettings?.merchantWeekStart = 7
//        }
        
        if self.switchWeeklyOvertime.isOn {
            self.merchantSettings?.merchantWeeklyOvertimeEnabled = "Y"
        }
        else{
            self.merchantSettings?.merchantWeeklyOvertimeEnabled = "N"
        }
        
        if self.switchDailyOvertime.isOn {
            self.merchantSettings?.merchantDailyOvertimeEnabled = "Y"
        }
        else{
            self.merchantSettings?.merchantDailyOvertimeEnabled = "N"
        }

        if self.switchSplitShift.isOn {
            self.merchantSettings?.merchantSplitEnabled = "Y"
        }
        else{
            self.merchantSettings?.merchantSplitEnabled = "N"
        }
        
//        if self.btnWeek1.isSelected {
//            self.merchantSettings?.merchantCurrentPayWeek = 1
//        }else{
//            self.merchantSettings?.merchantCurrentPayWeek = 0
//        }
        
        self.merchantSettings?.merchantName = txtBusinessName.text
        self.merchantSettings?.merchantWeb = txtBusinessWebsite.text
        self.merchantSettings?.merchantZip = txtZipCode.text
        let timezone = txtBusinessTimezone.text!.components(separatedBy:" ")[0]
//        if timezone != "Test" {
            merchantSettings?.merchantTimezone = "US/\(timezone)"
//        }
//        else{
//            merchantSettings?.merchantTimezone = "Asia/Kolkata"
//        }
        merchantSettings?.merchantCompanySize = self.txtTotalEmployee.text
    }
    
    func callSaveMerchantSettings(){
        let param = ["merchant_id": "\(Defaults.shared.currentUser?.merchantId ?? 0)",
          "emp_token": "\(Defaults.shared.currentUser?.empToken ?? "")",
          "emp_id": "\(Defaults.shared.currentUser?.empId ?? 0)",
        "merchant_weekly_overtime_enabled": "\(merchantSettings?.merchantWeeklyOvertimeEnabled ?? "")",
          "merchant_weekly_overtime": "\(merchantSettings?.merchantWeeklyOvertime ?? 0)",
          "merchant_daily_overtime_enabled": "\(merchantSettings?.merchantDailyOvertimeEnabled ?? "")",
          "merchant_daily_overtime":"\(merchantSettings?.merchantDailyOvertime ?? 0)",
          "emp_firstname": "\(merchantSettings?.empFirstname ?? "")",
          "emp_lastname": "\(merchantSettings?.empLastname ?? "")",
          "emp_work_email": "\(merchantSettings?.empWorkEmail ?? "")",
          "merchant_name": "\(merchantSettings?.merchantName ?? "")",
          "merchant_zip": "\(merchantSettings?.merchantZip ?? "")",
          "merchant_web": "\(merchantSettings?.merchantWeb ?? "")",
          "merchant_company_size": "\(merchantSettings?.merchantCompanySize ?? "")",
          "merchant_timezone": "\(merchantSettings?.merchantTimezone ?? "")",
          "merchant_split_enabled": "\(merchantSettings?.merchantSplitEnabled ?? "")",
          "emp_username": "\(merchantSettings?.empUserName ?? "")",
          "merchant_pay_period" :"\(merchantSettings?.merchantPayPeriod ?? "")",
          "merchant_current_pay_week" : "\(merchantSettings?.merchantCurrentPayWeek ?? 0)",
          "merchant_week_start" : "\(merchantSettings?.merchantWeekStart ?? 0)"
        ] as [String : Any]
        
        NetworkLayer.sharedNetworkLayer.postWebApiCallWithHeader(apiEndPoints: APIEndPoints.saveSettings(), param: param, header: ["":""]) { success, response, error in
            if let res = response{
                print(res)
                if let status = res["status"] as? Int , status == 1{
                    SucessPopupVC.showSuccessPopup(prevVC: self,titleStr: "Success" , strSubTitle: "Your changes were saved!") { done in
                        self.fetchSettings()
                }
                    
                }
            }else if let err = error{
                print(err)
            }
        }
    }
    func fetchSettings(){
        let param = ["merchant_id": "\(Defaults.shared.currentUser?.merchantId ?? 0)",
          "emp_token": "\(Defaults.shared.currentUser?.empToken ?? "")",
          "emp_id": "\(Defaults.shared.currentUser?.empId ?? 0)"
        ] as [String : Any]
        print(param)
        print(Defaults.shared.header ?? ["":""])
        NetworkLayer.sharedNetworkLayer.postWebApiCallWithHeader(apiEndPoints: APIEndPoints.fetchSettings(), param: param, header: ["":""]) { success, response, error in
            if let res = response{
                print(res)
                let data = Mapper<MerchantSettingsData>().map(JSONObject:res)
                print(data?.toJSON ?? "")
                self.merchantSettings = data?.settings?.first
                self.setSettingsData()
            }else if let err = error{
                print(err)
            }
        }
    }
    func setSettingsData(){
        self.txtFirstName.text = (merchantSettings?.empFirstname ?? "")
        self.txtLastName.text = (merchantSettings?.empLastname ?? "")
        self.txtUserName.text = (merchantSettings?.empUserName ?? "")
        self.txtemail.text = (merchantSettings?.empWorkEmail ?? "")
        
        if let passwordLength = Defaults.shared.passLen{
            self.txtpassword.text = Utility.randomString(length: passwordLength)
        }
        else{
            self.txtpassword.text = Defaults.shared.currentUser?.empPassword ?? ""
        }
        
        self.txteditdailyOvertimeHours.text = "\(merchantSettings?.merchantDailyOvertime ?? 8)"
        self.txteditWeeklyOvertimeHours.text = "\(merchantSettings?.merchantWeeklyOvertime ?? 32)"
        
        if merchantSettings?.merchantPayPeriod ?? "" == "W"{
            self.txtselectPayPeriod.text = NSLocalizedString("Weekly", comment: "btnWeekly")
            self.selectWeekView.isHidden = true
        }else if merchantSettings?.merchantPayPeriod ?? "" == "B"{
            self.txtselectPayPeriod.text = NSLocalizedString("Biweekly", comment: "btnBiweekly")
            self.selectWeekView.isHidden = false
        }
        
        if merchantSettings?.merchantWeekStart ?? 0 == 0{
            self.txtselectWeekStartday.text = NSLocalizedString("Sunday", comment: "btnSunday")
        }else if merchantSettings?.merchantWeekStart ?? 0 == 1{
            self.txtselectWeekStartday.text = NSLocalizedString("Monday", comment: "btnMonday")
        }else if merchantSettings?.merchantWeekStart ?? 0 == 2{
            self.txtselectWeekStartday.text = NSLocalizedString("Tuesday", comment: "btnTuesday")
        }else if merchantSettings?.merchantWeekStart ?? 0 == 3{
            self.txtselectWeekStartday.text = NSLocalizedString("Wednesday", comment: "btnWednesday")
        }else if merchantSettings?.merchantWeekStart ?? 0 == 4{
            self.txtselectWeekStartday.text = NSLocalizedString("Thursday", comment: "btnThursday")
        }else if merchantSettings?.merchantWeekStart ?? 0 == 5{
            self.txtselectWeekStartday.text = NSLocalizedString("Friday", comment: "btnFriday")
        }else if merchantSettings?.merchantWeekStart ?? 0 == 6{
            self.txtselectWeekStartday.text = NSLocalizedString("Saturday", comment: "btnSaturday")
        }
        
        if self.merchantSettings?.merchantWeeklyOvertimeEnabled ?? "N" == "Y"{
            self.switchWeeklyOvertime.isOn = true
        }else{
            self.switchWeeklyOvertime.isOn = false
        }
        if self.merchantSettings?.merchantDailyOvertimeEnabled ?? "N" == "Y"{
            self.switchDailyOvertime.isOn = true
        }else{
            self.switchDailyOvertime.isOn = false
        }
        
        if self.merchantSettings?.merchantSplitEnabled ?? "N" == "Y"{
            self.switchSplitShift.isOn = true
        }else{
            self.switchSplitShift.isOn = false
        }
        
        if self.merchantSettings?.merchantCurrentPayWeek ?? 0 == 1{
            self.btnWeek1.isSelected = true
            self.btnWeek2.isSelected = false
        }else{
            self.btnWeek1.isSelected = false
            self.btnWeek2.isSelected = true
        }
        
        txtBusinessName.text = self.merchantSettings?.merchantName
        txtBusinessWebsite.text = self.merchantSettings?.merchantWeb
        txtZipCode.text = self.merchantSettings?.merchantZip

//        if merchantSettings?.merchantTimezone ?? "" == "US/Atlantic"{
//            self.txtBusinessTimezone.text = "Atlantic Standard Time(AST)"
//        }else
        if merchantSettings?.merchantTimezone ?? "" == "US/Eastern"{
            self.txtBusinessTimezone.text = "Eastern Standard Time(EST)"
        }else if merchantSettings?.merchantTimezone ?? "" == "US/Central"{
            self.txtBusinessTimezone.text = "Central Standard Time(CST)"
        }else if merchantSettings?.merchantTimezone ?? "" == "US/Mountain"{
            self.txtBusinessTimezone.text = "Mountain Standard Time(MST)"
        }else if merchantSettings?.merchantTimezone ?? "" == "US/Pacific"{
            self.txtBusinessTimezone.text = "Pacific Standard Time(PST)"
        }
//        else if merchantSettings?.merchantTimezone ?? "" == "Asia/Kolkata"{
//            self.txtBusinessTimezone.text = "Test Timezone(Don't Choose)"
//        }
        
        self.txtTotalEmployee.text = merchantSettings?.merchantCompanySize ?? ""
        
        
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
//                    self.showSettingsView(showAccount: true)
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
    @IBAction func editContinueClick(sender:UIButton){
        
        
        if sender.tag == 10{
            if let selectedDay = self.editDaySelected{
                hideAllSettingProfileSetupViews()
                setupMerchant.merchant_week_start = "\(selectedDay.rawValue)"
                editPayPeriodDurationView.isHidden = false
                Defaults.shared.settingsPopupStatus = 2
            }
            else{
                self.showAlert(alertType:.validation, message: "Please select pay period start on.")
            }
        }else if sender.tag == 20{
            if let selectedDuration = self.editDurationSelected{
                hideAllSettingProfileSetupViews()
                if (selectedDuration.rawValue == 1){
                    setupMerchant.merchant_pay_period = "W"
                }else if (selectedDuration.rawValue == 2){
                    setupMerchant.merchant_pay_period = "B"
//                    if btnWeek2Option.isSelected == true{
//                        setupMerchant.merchant_current_pay_week = "2"
//                    }else{
//                        setupMerchant.merchant_current_pay_week = "1"
//                    }
                }
//                editWeeklyOvertimeView.isHidden = false
                editdailyOvertimeView.isHidden = false
                Defaults.shared.settingsPopupStatus = 3
            }
            else{
                self.showAlert(alertType:.validation, message: "Please select Pay Period duration.")
            }
        }else if sender.tag == 30{
            if let weeklyOvertimeHours = txtEditPopupWeeklyOvertimeHours.text , weeklyOvertimeHours.count > 0{
                hideAllSettingProfileSetupViews()
                setupMerchant.merchant_weekly_overtime = weeklyOvertimeHours
                editdailyOvertimeView.isHidden = false
            }
            else{
                self.showAlert(alertType:.validation, message: "Please enter weekly overtime.")
            }
        }else if sender.tag == 40{
            if checkDailyWeeklyOvertimeValidation(){
                if let weeklyOvertimeHours = txtEditPopupWeeklyOvertimeHours.text , var dailyOvertimeHours = txtEditPopupDailyOvertimeHours.text{
                    if dailyOvertimeHours.count < 1{
                        dailyOvertimeHours = "8"
                        setupMerchant.merchant_daily_overtime_enabled = "N"
                    }
                    else
                    {
                        setupMerchant.merchant_daily_overtime_enabled = "Y"
                    }
                    hideAllSettingProfileSetupViews()
                    setupMerchant.merchant_weekly_overtime = weeklyOvertimeHours
                    setupMerchant.merchant_daily_overtime = dailyOvertimeHours
                    setupMerchant.merchant_timezone = Defaults.shared.currentUser?.merchantTimezone ?? ""
//                    setupMerchant.merchant_current_pay_week = "1"
                    Defaults.shared.settingsPopupStatus = 4
                    callSetupMerchangtAPI()
//                    self.callSaveMerchantSettings()
                    print(setupMerchant ?? "")
                    //callSetupAPI
                }
            }
        }
    }
        
        func checkDailyWeeklyOvertimeValidation() -> Bool{
            if txtEditPopupWeeklyOvertimeHours.text!.count < 1{
                
                self.showAlert(alertType:.validation, message: "Please enter weekly overtime.")
                return false
            }
//            if txtEditPopupDailyOvertimeHours.text!.count < 1{
//
//                self.showAlert(alertType:.validation, message: "Please Enter Daily Overtime.")
//                return false
//            }
            return true
        }
    
    func hideAllSettingProfileSetupViews(){
        editPayPeriodStartDayView.isHidden = true
        editPayPeriodDurationView.isHidden = true
//        editWeeklyOvertimeView.isHidden = true
        editdailyOvertimeView.isHidden = true
    }
    
    @IBAction func skipEditWeeklyHoursClick(sender:UIButton){
        setupMerchant.merchant_weekly_overtime = ""
        editdailyOvertimeView.isHidden = false
    }
    @IBAction func skipEditDailyHoursClick(sender:UIButton){
        setupMerchant.merchant_weekly_overtime = ""
        setupMerchant.merchant_daily_overtime = ""
        setupMerchant.merchant_timezone = Defaults.shared.currentUser?.merchantTimezone ?? ""
//        setupMerchant.merchant_current_pay_week = "1"
        
        callSetupMerchangtAPI()
       
    }
//    @IBAction func selectSettingType(sender:UIButton){
//
//        let pickerArray = ["TimeClock Settings","Account Settings"]
//        IQKeyboardManager.shared.enable = false
//        PickerView.sharedInstance.addPicker(self, onTextField: txtSelectSettings, pickerArray: pickerArray) { index, value, isDismiss in
//            if !isDismiss {
//                IQKeyboardManager.shared.enable = true
//                 print(value)
//                if value == Settings.timeclock.rawValue{
//                    self.selectedSettings = .timeclock
//                    self.timesheetSettingView.isHidden = false
////                    self.businessSettingsView.isHidden = false
//                    self.accountSettingView.isHidden = true
//                }else if value == Settings.account.rawValue{
//                    self.selectedSettings = .account
//                    self.timesheetSettingView.isHidden = true
////                    self.businessSettingsView.isHidden = true
//                    self.accountSettingView.isHidden = false
//                }
//             }
//            self.txtSelectSettings.resignFirstResponder()
//        }
//
//
//    }
    
    @IBAction func editDaySelected(sender:UIButton){
        btnSunday.isSelected = false
        btnMonday.isSelected = false
        btnTuesday.isSelected = false
        btnWednesday.isSelected = false
        btnThursday.isSelected = false
        btnFriday.isSelected = false
        btnSaturday.isSelected = false
        
        sender.isSelected = true
        
        if sender.tag == 0{
            self.editDaySelected = .sunday
        }else if sender.tag == 1{
            self.editDaySelected = .monday
        }else if sender.tag == 2{
            self.editDaySelected = .tuesday
        }else if sender.tag == 3{
            self.editDaySelected = .wednesday
        }else if sender.tag == 4{
            self.editDaySelected = .thursday
        }else if sender.tag == 5{
            self.editDaySelected = .friday
        }else if sender.tag == 6{
            self.editDaySelected = .saturday
        }
    }
    
    @IBAction func editDurationSelected(sender:UIButton){
        btnWeekly.isSelected = false
        btnBiWeekly.isSelected = false
        
        sender.isSelected = true
        if sender.tag == 1{
            self.editDurationSelected = .weekly
            self.viewBiweeklySelection.isHidden = true
        }else if sender.tag == 2{
            self.editDurationSelected = .biWeekly
            self.viewBiweeklySelection.isHidden = false
        }
    }
    
    @IBAction func congratulationsPopupContinueSelected(sender:UIButton){
        self.setupMerchant = SetupMerchant()
        self.setupMerchant.merchant_id = "\(Defaults.shared.currentUser?.merchantId ?? 0)"
        self.setupMerchant.merchant_current_pay_week = "1"
        self.congratulationsPopup.isHidden = true
        self.editPayPeriodStartDayView.isHidden = false
        self.blurOverlayView.isHidden = false
       
    }
    @IBAction func changePasswordClicked(sender:UIButton){
        let vc = ChangePasswordVC.instantiate()
        self.presentVC(controller:vc)
    }
    @IBAction func successPopupContinueSelected(sender:UIButton){
        self.successPopup.isHidden = true
        let vc = EmployeesVC.instantiate()
        vc.isFromProfileSetup = true
        self.pushVC(controller:vc)
    }
    
    @IBAction func successPopupSkipSelected(sender:UIButton){
        self.successPopup.isHidden = true
    }
    
    @IBAction func editClick(sender:UIButton){
        editWeeklyOvertimeHoursView.isUserInteractionEnabled = true
        editdailyOvertimeHoursView.isUserInteractionEnabled = true
        selectWeekStartdayView.isUserInteractionEnabled = true
        selectPayPeriodView.isUserInteractionEnabled = true
        selectCurrentPayWeek.isUserInteractionEnabled = true
        switchWeeklyOvertime.isUserInteractionEnabled = true
        switchDailyOvertime.isUserInteractionEnabled = true
        switchSplitShift.isUserInteractionEnabled = true
        btnWeek1.isUserInteractionEnabled = true
        btnWeek2.isUserInteractionEnabled = true
//        self.timesheetStackView.alpha = 1.0
        changeTimesheetAppearance(toEdit: true)
//        self.accountStackView.alpha = 1.0
        changeAccountTextfieldsAppearance(toEdit: true)
        changeBusinessAppearance(toEdit: true)
        saveView.isHidden = false
        editView.isUserInteractionEnabled = false
        editView.alpha = 0.5
    }
    
    @IBAction func selectPayPeriodClick(sender:UIButton){
        if editView.alpha == 1.0{
            editTooltipView.isHidden = false
            return
        }
        let pickerArray = self.durationOptions
        IQKeyboardManager.shared.enable = false
        PickerView.sharedInstance.addPicker(self, onTextField: txtselectPayPeriod, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                IQKeyboardManager.shared.enable = true
                 print(value)
                self.txtselectPayPeriod.text = value
                if index == 0{
                    self.merchantSettings?.merchantPayPeriod = "W"
                    self.selectWeekView.isHidden = true
                }else{
                    self.merchantSettings?.merchantPayPeriod = "B"
                    self.selectWeekView.isHidden = false
                }
             }
            self.txtselectPayPeriod.resignFirstResponder()
        }
    }
    
    @IBAction func selectCurrentPayperiodClick(sender:UIButton){
        if editView.alpha == 1.0{
            editTooltipView.isHidden = false
            return
        }
        if sender.tag == 1{
            btnWeek1.isSelected = true
            btnWeek2.isSelected = false
            
        }else if sender.tag == 2{
            btnWeek1.isSelected = false
            btnWeek2.isSelected = true
        }
        self.merchantSettings?.merchantCurrentPayWeek = ((sender.tag) as NSNumber)
    }
    
    @IBAction func selectStartWeekdayClick(sender:UIButton){
        if editView.alpha == 1.0{
            editTooltipView.isHidden = false
            return
        }
        let pickerArray = self.weekDaysArray
        IQKeyboardManager.shared.enable = false
        PickerView.sharedInstance.addPicker(self, onTextField: txtselectWeekStartday, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                IQKeyboardManager.shared.enable = true
                 print(value)
                self.txtselectWeekStartday.text = value
                self.merchantSettings?.merchantWeekStart = ((index) as NSNumber)
               
             }
            self.txtselectWeekStartday.resignFirstResponder()
        }
    }
    
    @IBAction func saveClick(sender:UIButton){
//        editWeeklyOvertimeHoursView.isUserInteractionEnabled = false
//        editdailyOvertimeHoursView.isUserInteractionEnabled = false
//        selectWeekStartdayView.isUserInteractionEnabled = false
//        selectPayPeriodView.isUserInteractionEnabled = false
//        selectCurrentPayWeek.isUserInteractionEnabled = false
//        switchWeeklyOvertime.isUserInteractionEnabled = false
//        switchDailyOvertime.isUserInteractionEnabled = false
//        btnWeek1.isUserInteractionEnabled = false
//        btnWeek2.isUserInteractionEnabled = false
        SettingsSavePopupVC.showSettingsSavePopup(prevVC: self) { isSaveTapped in
            if isSaveTapped{
                if self.validateSettings(){
//                    self.saveView.isHidden = true
//                    self.editView.isUserInteractionEnabled = true
//                    self.editView.alpha = 1.0
        //            self.timesheetStackView.alpha = 0.5
//                    self.changeTimesheetAppearance(toEdit: false)
        //            self.accountStackView.alpha = 0.5
//                    self.changeAccountTextfieldsAppearance(toEdit: false)
//                    self.changeBusinessAppearance(toEdit: false)
                    self.setSelectedDetailsToMerchantSettings()
                    self.callSaveMerchantSettings()
                }
            }
        }
    }
    
    func validateSettings() -> Bool{
        var isValidated = true
        if txtFirstName.text!.count < 1{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Please Enter First Name", comment: "alertLabel"))
            return false
        }
        if txtFirstName.text!.hasNumbers{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Name can only contain alphabets.", comment: "alertLabel"))
            return false
        }
        
        if txtLastName.text!.count < 1{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Please Enter Last Name", comment: "alertLabel"))
            return false
        }
        if txtLastName.text!.hasNumbers{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Name can only contain alphabets.", comment: "alertLabel"))
            return false
        }
        if txtUserName.text!.count < 1{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Please Enter Username", comment: "alertLabel"))
            return false
        }
        if let email = txtemail.text{
            if !(email.count > 0 && email.isEmail){
                self.showAlert(alertType:.validation, message: NSLocalizedString("Please Enter Valid Email", comment: "alertLabel"))
                isValidated = false
            }
        }
        if txtBusinessName.text!.count < 1{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Please Enter Business Name", comment: "alertLabel"))
            return false
        }
        if txtBusinessName.text!.hasNumbers{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Name can only contain alphabets.", comment: "alertLabel"))
            return false
        }
        if txtZipCode.text!.count < 1{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Please Enter Zipcode", comment: "alertLabel"))
            return false
        }
        if txtBusinessTimezone.text!.count < 1{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Please Enter Timezone", comment: "alertLabel"))
            return false
        }
        if let url = txtBusinessWebsite.text , url.trimmed.count > 0{
            if !(url.isValidUrl()){
                self.showAlert(alertType:.validation, message: NSLocalizedString("Invalid Website. Please Try Again.", comment: "alertLabel"))
                isValidated = false
            }
        }
        if txtTotalEmployee.text!.count < 1{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Please Select how many people do you employ.", comment: "alertLabel"))
            return false
        }
        
        if txteditWeeklyOvertimeHours.text!.count < 1{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Please Enter Weekly Overtime.", comment: "alertLabel"))
            return false
        }
        if txteditdailyOvertimeHours.text!.count < 1{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Please Enter Daily Overtime.", comment: "alertLabel"))
            return false
        }
        return isValidated
    }
    
    @IBAction func cancelClick(sender:UIButton){
//        editWeeklyOvertimeHoursView.isUserInteractionEnabled = false
//        editdailyOvertimeHoursView.isUserInteractionEnabled = false
//        selectWeekStartdayView.isUserInteractionEnabled = false
//        selectPayPeriodView.isUserInteractionEnabled = false
//        selectCurrentPayWeek.isUserInteractionEnabled = false
//        switchWeeklyOvertime.isUserInteractionEnabled = false
//        switchDailyOvertime.isUserInteractionEnabled = false
//        btnWeek1.isUserInteractionEnabled = false
//        btnWeek2.isUserInteractionEnabled = false
        //        self.timesheetStackView.alpha = 0.5
        //        self.accountStackView.alpha = 0.5
        
//        saveView.isHidden = true
//        editView.isUserInteractionEnabled = true
//        editView.alpha = 1.0
//        changeTimesheetAppearance(toEdit: false)
//        changeAccountTextfieldsAppearance(toEdit: false)
//        changeBusinessAppearance(toEdit: false)
        fetchSettings()
    }
    @IBAction func closeClick(sender:UIButton){
        editPayPeriodStartDayView.isHidden = true
        editPayPeriodDurationView.isHidden = true
//        editWeeklyOvertimeView.isHidden = true
        editdailyOvertimeView.isHidden = true
        
        self.blurOverlayView.isHidden = true
    }
    
    @IBAction func btnSelectBusinessTimezoneTapped(_ sender: Any) {
//        let pickerArray = ["Atlantic Standard Time(AST)","Eastern Standard Time(EST)","Central Standard Time(CST)","Mountain Standard Time(MST)","Pacific Standard Time(PST)","Test Timezone(Don't Choose)"]
        let pickerArray = ["Eastern Standard Time(EST)","Central Standard Time(CST)","Mountain Standard Time(MST)","Pacific Standard Time(PST)"]
        IQKeyboardManager.shared.enable = false
        PickerView.sharedInstance.addPicker(self, onTextField: txtBusinessTimezone, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                IQKeyboardManager.shared.enable = true
                 self.txtBusinessTimezone.text = value
                 print(value)
             }
            self.txtBusinessTimezone.resignFirstResponder()
        }
    }

    @IBAction func btnBusinessNoOfEmp(_ sender: Any) {
        IQKeyboardManager.shared.enable = false
        PickerView.sharedInstance.addPicker(self, onTextField: txtTotalEmployee, pickerArray: arrNoOfEmps) { index, value, isDismiss in
            if !isDismiss {
                IQKeyboardManager.shared.enable = true
                 self.txtTotalEmployee.text = value
                 print(value)
             }
            self.txtTotalEmployee.resignFirstResponder()
        }
    }
    
    @IBAction func switchValueDidChange(sender:UISwitch)
    {
        if editView.alpha == 1.0{
            editTooltipView.isHidden = false
            sender.isOn = !sender.isOn
            return
        }
        if sender.tag == 1{
            //Weekly
            if (sender.isOn == true){
                print("on")
                self.merchantSettings?.merchantWeeklyOvertimeEnabled = "Y"
            }
            else{
                self.merchantSettings?.merchantWeeklyOvertimeEnabled = "N"
            }
        }else{
            //Daily
            if (sender.isOn == true){
                print("on")
                self.merchantSettings?.merchantDailyOvertimeEnabled = "Y"
            }
            else{
                self.merchantSettings?.merchantDailyOvertimeEnabled = "N"
            }
        }
       
    }
    @IBAction func editTooltipOkClicked(){
        self.editTooltipView.isHidden = true
    }
    
    @IBAction func btnBackToSelectionTapped(_ sender: Any) {
        self.viewSelection.isHidden = false
        self.saveView.isHidden = true
        self.timesheetSettingView.isHidden = true
        self.businessSettingsView.isHidden = true
//        self.accountSettingView.isHidden = true
    }
    
    @IBAction func btnWeek1OptionTapped(_ sender: Any) {
        btnWeek1Option.isSelected = true
        btnWeek2Option.isSelected = false
        setupMerchant.merchant_current_pay_week = "1"
    }
    
    @IBAction func btnWeek2OptionTapped(_ sender: Any) {
        btnWeek1Option.isSelected = false
        btnWeek2Option.isSelected = true
        setupMerchant.merchant_current_pay_week = "2"
    }
    
    func changeAccountTextfieldsAppearance(toEdit mode: Bool){
        if mode{
            txtFirstName.backgroundColor = UIColor.white
            txtLastName.backgroundColor = UIColor.white
            txtUserName.backgroundColor = UIColor.white
            txtemail.backgroundColor = UIColor.white
            txtpassword.backgroundColor = UIColor.white
        }
        else{
            txtFirstName.backgroundColor = UIColor.Color.appThemeBGColor
            txtLastName.backgroundColor = UIColor.Color.appThemeBGColor
            txtUserName.backgroundColor = UIColor.Color.appThemeBGColor
            txtemail.backgroundColor = UIColor.Color.appThemeBGColor
            txtpassword.backgroundColor = UIColor.Color.appThemeBGColor
        }
    }
    
    func changeTimesheetAppearance(toEdit mode: Bool){
        if mode{
            editWeeklyOvertimeHoursView.backgroundColor = UIColor.white
            editdailyOvertimeHoursView.backgroundColor = UIColor.white
            selectPayPeriodView.backgroundColor = UIColor.white
            selectWeekStartdayView.backgroundColor = UIColor.white
            switchDailyOvertime.isEnabled = true
            switchWeeklyOvertime.isEnabled = true
            switchSplitShift.isEnabled = true
            
        }
        else{
            editWeeklyOvertimeHoursView.backgroundColor = UIColor.Color.appThemeBGColor
            editdailyOvertimeHoursView.backgroundColor = UIColor.Color.appThemeBGColor
            selectPayPeriodView.backgroundColor = UIColor.Color.appThemeBGColor
            selectWeekStartdayView.backgroundColor = UIColor.Color.appThemeBGColor
            switchDailyOvertime.isEnabled = false
            switchWeeklyOvertime.isEnabled = false
            switchSplitShift.isEnabled = false
            
        }
    }
    
    func changeBusinessAppearance(toEdit mode: Bool){
        if mode{
            txtBusinessName.backgroundColor = UIColor.white
            txtZipCode.backgroundColor = UIColor.white
            txtBusinessTimezone.backgroundColor = UIColor.white
            txtBusinessWebsite.backgroundColor = UIColor.white
            txtTotalEmployee.backgroundColor = UIColor.white
        }
        else{
            txtBusinessName.backgroundColor = UIColor.Color.appThemeBGColor
            txtZipCode.backgroundColor = UIColor.Color.appThemeBGColor
            txtBusinessTimezone.backgroundColor = UIColor.Color.appThemeBGColor
            txtBusinessWebsite.backgroundColor = UIColor.Color.appThemeBGColor
            txtTotalEmployee.backgroundColor = UIColor.Color.appThemeBGColor
        }
    }
    
    @IBAction func btnDeleteMyAccountClicked(_ sender: Any) {
        DeleteAccountVC.showDeleteAccountPopup(prevVC: self) { isDeleteTapped in
            if isDeleteTapped {
                //Call API for delete
                self.callDeleteAccountAPI()
            }
        }
    }
    
    func callDeleteAccountAPI(){
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
                          "emp_id":Defaults.shared.currentUser?.empId ?? 0] as [String : Any]
        
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.deleteMerchant(), param:parameters, header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                print(res)
                if let status = res["status"] as? Int{
                    if status == 1{
                        //Logout User
                        Defaults.shared.currentUser = nil
                        Utility.setRootScreen(isShowAnimation: true)
                    }
                }
                else{
                    self.showAlert(alertType:.validation, message: "Something went wrong while deleting account. Please try again.")
                }
            }else if let err = error{
                print(err)
                self.showAlert(alertType:.validation, message: "Something went wrong while deleting account. Please try again.")
            }
        }
    }
    
}
extension SettingsVC:MenuItemDelegate {
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

extension SettingsVC: CustomMenuItemDelegate {
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

extension SettingsVC:UITextFieldDelegate {
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

extension SettingsVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"SettingsSelectionCell",for:indexPath) as! SettingsSelectionCell
        let dictSetting = arrSettings[indexPath.row]
        cell.lblSettingTitle.text = NSLocalizedString(dictSetting["title"]!, comment: "lblSettingsTitle")
        cell.lblSettingDetails.text = NSLocalizedString(dictSetting["subtitle"]!, comment: "lblSettingsDetails")
        cell.imgSettings.image = UIImage.init(named: dictSetting["icon"]!)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0{
//            //Account
//            self.viewSelection.isHidden = true
//            self.saveView.isHidden = false
//            self.timesheetSettingView.isHidden = true
//            self.businessSettingsView.isHidden = true
//            self.accountSettingView.isHidden = false
//        }
         if indexPath.row == 0{
            //Bussiness
            self.viewSelection.isHidden = true
            self.saveView.isHidden = false
            self.timesheetSettingView.isHidden = true
            self.businessSettingsView.isHidden = false
//            self.accountSettingView.isHidden = true
        }
        else if indexPath.row == 1{
            //Timesheet
            self.viewSelection.isHidden = true
            self.saveView.isHidden = false
            self.timesheetSettingView.isHidden = false
            self.businessSettingsView.isHidden = true
//            self.accountSettingView.isHidden = true
        }
    }
}

extension UIButton {
  func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
    let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
      color.setFill()
      UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
    }
    setBackgroundImage(colorImage, for: controlState)
  }
}

class SettingsSelectionCell : UITableViewCell{
 
    @IBOutlet weak var imgSettings: UIImageView!
    @IBOutlet weak var lblSettingTitle: UILabel!
    @IBOutlet weak var lblSettingDetails: UILabel!
    
    
}
