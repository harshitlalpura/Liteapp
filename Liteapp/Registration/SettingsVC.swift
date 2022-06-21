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

enum EditSelectedDay:Int{
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
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
    
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.merchant.rawValue, bundle: nil)
    var menu:SideMenuNavigationController!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var logoutView: UIView!
    
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
    
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtpassword: UITextField!
   
    var setupMerchant:SetupMerchant!
    var merchantSettings:MerchantSettings?
    var editDaySelected:EditSelectedDay = .monday
    var editDurationSelected:EditDuration = .weekly
    var setupProfile:Bool = false
    
    var weekDaysArray = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var durationOptions = ["Weekly","Biweekly"]
    var settingsArray = ["TimeClock Settings","Account Settings"]
    
    var selectedSettings:Settings = .timeclock
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupMenu()
    }
    func setUI(){
        logoutView.isHidden = true
        lblusername.text = "\(Defaults.shared.currentUser?.empFirstname ?? "") \(Defaults.shared.currentUser?.empLastname ?? "")"
        
        btnSunday.tag = 1
        btnMonday.tag = 2
        btnTuesday.tag = 3
        btnWednesday.tag = 4
        btnThursday.tag = 5
        btnFriday.tag = 6
        btnSaturday.tag = 7
        
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
       
        btnWeek1.setBackgroundColor(UIColor.Color.appThemeBGColor, forState: .selected)
        btnWeek1.setBackgroundColor(.white, forState: .normal)
        
        btnWeek2.setBackgroundColor(UIColor.Color.appThemeBGColor, forState: .selected)
        btnWeek2.setBackgroundColor(.white, forState: .normal)
        
        btnWeekly.isSelected = true
        
        btnWeekly.tag = 1
        btnBiWeekly.tag = 2
        
        btnWeek1.tag = 1
        btnWeek2.tag = 2
        
        switchWeeklyOvertime.tag = 1
        switchDailyOvertime.tag = 2
        
        continueButtonStep1.tag = 10
        continueButtonStep2.tag = 20
        continueButtonStep3.tag = 30
        continueButtonStep4.tag = 40
        
        editWeeklyOvertimeHoursView.isUserInteractionEnabled = false
        editdailyOvertimeHoursView.isUserInteractionEnabled = false
        selectWeekStartdayView.isUserInteractionEnabled = false
        selectPayPeriodView.isUserInteractionEnabled = false
        editWeeklyOvertimeHoursView.isUserInteractionEnabled = false
        editdailyOvertimeHoursView.isUserInteractionEnabled = false
        selectWeekStartdayView.isUserInteractionEnabled = false
        selectPayPeriodView.isUserInteractionEnabled = false
        selectCurrentPayWeek.isUserInteractionEnabled = false
        switchWeeklyOvertime.isUserInteractionEnabled = false
        switchDailyOvertime.isUserInteractionEnabled = false
        btnWeek1.isUserInteractionEnabled = false
        btnWeek2.isUserInteractionEnabled = false
        
        self.timesheetSettingView.isHidden = false
        self.accountSettingView.isHidden = true
        
        self.saveView.isHidden = true
        
        if self.setupProfile{
            self.congratulationsPopup.isHidden  = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchSettings()
    }
    private func setupMenu(){
        let controller = MenuViewController.instantiate()
        controller.delegate = self
        controller.selectedOption = .Settings
        menu = SideMenuNavigationController(rootViewController:controller)
        menu.navigationBar.isHidden = true
        menu.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView:view)
        SideMenuManager.default.leftMenuNavigationController = menu
        
    }
    @IBAction func menuClicked(sender:UIButton){
        self.present(menu, animated: true, completion: {})
    }
    func callSetupMerchangtAPI(){
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.setupMerchants(), param: setupMerchant.getParam(), header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                print(res)
                self.editPayPeriodStartDayView.isHidden = true
                self.editPayPeriodDurationView.isHidden = true
                self.editWeeklyOvertimeView.isHidden = true
                self.editdailyOvertimeView.isHidden = true
                self.blurOverlayView.isHidden = true
                if let status = res["status"] as? Int{
                    if status == 1{
                        self.successPopup.isHidden = false
                    }
                }
            }else if let err = error{
                print(err)
                self.editPayPeriodStartDayView.isHidden = true
                self.editPayPeriodDurationView.isHidden = true
                self.editWeeklyOvertimeView.isHidden = true
                self.editdailyOvertimeView.isHidden = true
                self.blurOverlayView.isHidden = true
            }
        }
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
          "emp_work_email": "\(merchantSettings?.empWorkEmail ?? "")"
        ] as [String : Any]
        
        NetworkLayer.sharedNetworkLayer.postWebApiCallWithHeader(apiEndPoints: APIEndPoints.saveSettings(), param: param, header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if let res = response{
                print(res)
               
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
        
        NetworkLayer.sharedNetworkLayer.postWebApiCallWithHeader(apiEndPoints: APIEndPoints.fetchSettings(), param: param, header: Defaults.shared.header ?? ["":""]) { success, response, error in
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
        self.txtname.text = (merchantSettings?.empFirstname ?? "") + " " + (merchantSettings?.empLastname ?? "")
        self.txtemail.text = (merchantSettings?.empWorkEmail ?? "")
        self.txtpassword.text = Defaults.shared.currentUser?.empPassword ?? ""
        self.txteditdailyOvertimeHours.text = "\(merchantSettings?.merchantDailyOvertime ?? 8)"
        self.txteditWeeklyOvertimeHours.text = "\(merchantSettings?.merchantWeeklyOvertime ?? 32)"
        
        if merchantSettings?.merchantPayPeriod ?? "" == "B"{
            self.txtselectPayPeriod.text = "Weekly"
        }else if merchantSettings?.merchantPayPeriod ?? "" == "W"{
            self.txtselectPayPeriod.text = "Biweekly"
        }
        
        if merchantSettings?.merchantWeekStart ?? 0 == 1{
            self.txtselectWeekStartday.text = "Sunday"
        }else if merchantSettings?.merchantWeekStart ?? 0 == 2{
            self.txtselectWeekStartday.text = "Monday"
        }else if merchantSettings?.merchantWeekStart ?? 0 == 3{
            self.txtselectWeekStartday.text = "Tuesday"
        }else if merchantSettings?.merchantWeekStart ?? 0 == 4{
            self.txtselectWeekStartday.text = "Wednesday"
        }else if merchantSettings?.merchantWeekStart ?? 0 == 5{
            self.txtselectWeekStartday.text = "Thursday"
        }else if merchantSettings?.merchantWeekStart ?? 0 == 6{
            self.txtselectWeekStartday.text = "Friday"
        }else if merchantSettings?.merchantWeekStart ?? 0 == 7{
            self.txtselectWeekStartday.text = "Saturday"
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
        
        if self.merchantSettings?.merchantCurrentPayWeek ?? 0 == 1{
            self.btnWeek1.isSelected = true
            self.btnWeek2.isSelected = false
        }else{
            self.btnWeek1.isSelected = false
            self.btnWeek2.isSelected = true
        }
        
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
    @IBAction func editContinueClick(sender:UIButton){
        
        editPayPeriodStartDayView.isHidden = true
        editPayPeriodDurationView.isHidden = true
        editWeeklyOvertimeView.isHidden = true
        editdailyOvertimeView.isHidden = true
        
        if sender.tag == 10{
            setupMerchant.merchant_week_start = "\(self.editDaySelected.rawValue)"
            editPayPeriodDurationView.isHidden = false
        }else if sender.tag == 20{
            if (self.editDurationSelected.rawValue == 1){
                setupMerchant.merchant_pay_period = "W"
            }else if (self.editDurationSelected.rawValue == 2){
                setupMerchant.merchant_pay_period = "B"
            }
            editWeeklyOvertimeView.isHidden = false
        }else if sender.tag == 30{
            setupMerchant.merchant_weekly_overtime = txtEditPopupWeeklyOvertimeHours.text
            editdailyOvertimeView.isHidden = false
        }else if sender.tag == 40{
            setupMerchant.merchant_daily_overtime = txtEditPopupDailyOvertimeHours.text
            setupMerchant.merchant_timezone = Defaults.shared.currentUser?.merchantTimezone ?? ""
            setupMerchant.merchant_current_pay_week = "1"
            
            callSetupMerchangtAPI()
            print(setupMerchant ?? "")
            //callSetupAPI
        }
    }
    @IBAction func skipEditWeeklyHoursClick(sender:UIButton){
       
    }
    @IBAction func skipEditDailyHoursClick(sender:UIButton){
        
       
    }
    @IBAction func selectSettingType(sender:UIButton){
        
        let pickerArray = ["TimeClock Settings","Account Settings"]
        
        PickerView.sharedInstance.addPicker(self, onTextField: txtname, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                
                 print(value)
                if value == Settings.timeclock.rawValue{
                    self.selectedSettings = .timeclock
                    self.timesheetSettingView.isHidden = false
                    self.accountSettingView.isHidden = true
                }else if value == Settings.account.rawValue{
                    self.selectedSettings = .account
                    self.timesheetSettingView.isHidden = true
                    self.accountSettingView.isHidden = false
                }
             }
            self.txtname.resignFirstResponder()
        }
        
       
    }
    
    @IBAction func editDaySelected(sender:UIButton){
        btnSunday.isSelected = false
        btnMonday.isSelected = false
        btnTuesday.isSelected = false
        btnWednesday.isSelected = false
        btnThursday.isSelected = false
        btnFriday.isSelected = false
        btnSaturday.isSelected = false
        
        sender.isSelected = true
        
        if sender.tag == 1{
            self.editDaySelected = .sunday
        }else if sender.tag == 2{
            self.editDaySelected = .monday
        }else if sender.tag == 3{
            self.editDaySelected = .tuesday
        }else if sender.tag == 4{
            self.editDaySelected = .wednesday
        }else if sender.tag == 5{
            self.editDaySelected = .thursday
        }else if sender.tag == 6{
            self.editDaySelected = .friday
        }else if sender.tag == 7{
            self.editDaySelected = .saturday
        }
    }
    
    @IBAction func editDurationSelected(sender:UIButton){
        btnWeekly.isSelected = false
        btnBiWeekly.isSelected = false
        
        sender.isSelected = true
        if sender.tag == 1{
            self.editDurationSelected = .weekly
        }else if sender.tag == 2{
            self.editDurationSelected = .biWeekly
        }
    }
    
    @IBAction func congratulationsPopupContinueSelected(sender:UIButton){
        self.setupMerchant = SetupMerchant()
        self.setupMerchant.merchant_id = "\(Defaults.shared.currentUser?.merchantId ?? 0)"
        self.congratulationsPopup.isHidden = true
        self.editPayPeriodStartDayView.isHidden = false
        self.blurOverlayView.isHidden = false
    }
    
    @IBAction func successPopupContinueSelected(sender:UIButton){
        self.successPopup.isHidden = true
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
        btnWeek1.isUserInteractionEnabled = true
        btnWeek2.isUserInteractionEnabled = true
        
        saveView.isHidden = false
        editView.isUserInteractionEnabled = false
        editView.alpha = 0.5
    }
    
    @IBAction func selectPayPeriodClick(sender:UIButton){
        let pickerArray = self.durationOptions
        
        PickerView.sharedInstance.addPicker(self, onTextField: txtselectWeekStartday, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                
                 print(value)
                self.txtselectPayPeriod.text = value
                if index == 0{
                    self.merchantSettings?.merchantPayPeriod = "W"
                }else{
                    self.merchantSettings?.merchantPayPeriod = "B"
                }
             }
            self.txtselectWeekStartday.resignFirstResponder()
        }
    }
    
    @IBAction func selectCurrentPayperiodClick(sender:UIButton){
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
        let pickerArray = self.weekDaysArray
        
        PickerView.sharedInstance.addPicker(self, onTextField: txtselectWeekStartday, pickerArray: pickerArray) { index, value, isDismiss in
            if !isDismiss {
                
                 print(value)
                self.txtselectWeekStartday.text = value
                self.merchantSettings?.merchantWeekStart = ((index + 1) as NSNumber)
               
             }
            self.txtselectWeekStartday.resignFirstResponder()
        }
    }
    
    @IBAction func saveClick(sender:UIButton){
        editWeeklyOvertimeHoursView.isUserInteractionEnabled = false
        editdailyOvertimeHoursView.isUserInteractionEnabled = false
        selectWeekStartdayView.isUserInteractionEnabled = false
        selectPayPeriodView.isUserInteractionEnabled = false
        selectCurrentPayWeek.isUserInteractionEnabled = false
        switchWeeklyOvertime.isUserInteractionEnabled = false
        switchDailyOvertime.isUserInteractionEnabled = false
        btnWeek1.isUserInteractionEnabled = false
        btnWeek2.isUserInteractionEnabled = false
        saveView.isHidden = true
        editView.isUserInteractionEnabled = true
        editView.alpha = 1.0
        self.callSaveMerchantSettings()
        //call save api
    }
    @IBAction func cancelClick(sender:UIButton){
        editWeeklyOvertimeHoursView.isUserInteractionEnabled = false
        editdailyOvertimeHoursView.isUserInteractionEnabled = false
        selectWeekStartdayView.isUserInteractionEnabled = false
        selectPayPeriodView.isUserInteractionEnabled = false
        selectCurrentPayWeek.isUserInteractionEnabled = false
        switchWeeklyOvertime.isUserInteractionEnabled = false
        switchDailyOvertime.isUserInteractionEnabled = false
        btnWeek1.isUserInteractionEnabled = false
        btnWeek2.isUserInteractionEnabled = false
        saveView.isHidden = true
        editView.isUserInteractionEnabled = true
        editView.alpha = 1.0
    }
    @IBAction func closeClick(sender:UIButton){
        editPayPeriodStartDayView.isHidden = true
        editPayPeriodDurationView.isHidden = true
        editWeeklyOvertimeView.isHidden = true
        editdailyOvertimeView.isHidden = true
        
        self.blurOverlayView.isHidden = true
    }
    @IBAction func switchValueDidChange(sender:UISwitch)
    {
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
extension UIButton {
  func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
    let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
      color.setFill()
      UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
    }
    setBackgroundImage(colorImage, for: controlState)
  }
}
