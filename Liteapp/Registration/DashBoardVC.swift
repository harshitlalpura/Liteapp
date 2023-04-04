//
//  DashBoardVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import UIKit
import SideMenu
import ObjectMapper
import Alamofire

class DashBoardVC:BaseViewController, StoryboardSceneBased{
    
    
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.timesheetiPad.rawValue : StoryboardName.timesheet.rawValue, bundle: nil)
    
    var menu:SideMenuNavigationController!
    @IBOutlet weak var calanderCollectionView: UICollectionView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblClockinStatus: UILabel!
    @IBOutlet weak var lblTotalHours: UILabel!
    @IBOutlet weak var lblWeeklyHours: UILabel!
    @IBOutlet weak var lblPayPeriod: UILabel!
    @IBOutlet weak var imageviewClockinStatus: UIImageView!
    @IBOutlet weak var btnClockin: UIButton!
    @IBOutlet weak var btnStartBreak: UIButton!
    @IBOutlet weak var stackviewtimesheet: UIStackView!
    
    @IBOutlet weak var lblweeklyHr: UILabel!
    @IBOutlet weak var lblweeklyMin: UILabel!
    @IBOutlet weak var lblTotalHr: UILabel!
    @IBOutlet weak var lblTotalMin: UILabel!
    
    @IBOutlet weak var lblDailyHours: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblampm: UILabel!
    
    @IBOutlet weak var lblusername: UILabel!
//    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var clockInSuccessPopup: UIView!
    @IBOutlet weak var lbltimeClockInPopup: UILabel!
    @IBOutlet weak var lbltimeClockInampm: UILabel!
    @IBOutlet weak var lblDateClockInPopup: UILabel!
    
    @IBOutlet weak var breakinSuccessPopup: UIView!
    @IBOutlet weak var lbltimebreakinPopup: UILabel!
    @IBOutlet weak var lbltimebreakinampm: UILabel!
    @IBOutlet weak var lblDatebreakinPopup: UILabel!
    @IBOutlet weak var lblMessagebreakinPopup: UILabel!
    
    @IBOutlet weak var clockOutSuccessPopup: UIView!
    @IBOutlet weak var lbltimeclockOutPopup: UILabel!
    @IBOutlet weak var lbltimeclockOutampm: UILabel!
    @IBOutlet weak var lblDateclockOutPopup: UILabel!
  
    @IBOutlet weak var customNavView: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    
    @IBOutlet weak var lblTimeClock: UILabel!
    @IBOutlet weak var lblClockOut1: UILabel!
    @IBOutlet weak var lblClockOut2: UILabel!
    @IBOutlet weak var lblProjectedClockOut: UILabel!
    @IBOutlet weak var lblTotalHour: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var myTimesheetLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var btnOKBreakInPopUp: UIButton!
    @IBOutlet weak var btnOKClockOutPopUp: UIButton!
    @IBOutlet weak var clockOutPopUpLabel: UILabel!
    @IBOutlet weak var btnOKClockInPopUp: UIButton!
    @IBOutlet weak var clockInPopUpLabel: UILabel!
    
    var menuV : CustomMenuView!
    var dashboardData:DashBoardData!
    var strCurrentDate = ""
    var selectedDate = Date()
    var itemsDate = [[Date]]()
    let now = Date()
    let calendar = Calendar.current
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm" // or "hh:mm a" if you need to have am or pm symbols
        return formatter
    }()
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTimeClock.text = NSLocalizedString("TimeClock", comment: "lblTimeClock")
        lblClockOut1.text = NSLocalizedString("You are clocked out.", comment: "lblClockOut1")
        lblClockOut2.text = NSLocalizedString("You are clocked out.", comment: "lblClockOut2")
        lblProjectedClockOut.text = NSLocalizedString("Projected Out : -:-- --", comment: "lblProjectedClockOut")
        lblTotalHour.text = NSLocalizedString("Total Hours", comment: "lblTotalHour")
        hourLabel.text = NSLocalizedString("hr", comment: "hourLabel")
        minuteLabel.text = NSLocalizedString("min", comment: "minuteLabel")
        myTimesheetLabel.text = NSLocalizedString("My Timesheets", comment: "myTimesheetLabel")
        totalLabel.text = NSLocalizedString("Total", comment: "totalLabel")
        btnOKBreakInPopUp.setTitle(NSLocalizedString("Ok", comment: "btnOKBreakInPopUp"), for: .normal)
        btnOKClockOutPopUp.setTitle(NSLocalizedString("Ok", comment: "btnOKClockOutPopUp"), for: .normal)
        clockOutPopUpLabel.text = NSLocalizedString("You are clocked out.", comment: "clockOutPopUpLabel")
        btnOKClockInPopUp.setTitle(NSLocalizedString("Ok", comment: "btnOKClockInPopUp"), for: .normal)
        clockInPopUpLabel.text = NSLocalizedString("You are clocked in!", comment: "clockInPopUpLabel")
        
        setupMenu()
        setData()
//        self.logoutView.dropShadow()
        NotificationCenter.default.addObserver(self, selector:#selector(appMovedToForeground),name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    private func getCurrentTime() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
    }

    @objc func currentTime() {
        lblTime.text = Date().string(format: DateTimeFormat.h_mm.rawValue)
    }
   
    override func viewWillAppear(_ animated: Bool) {
       
        self.fetchDashboard()
        self.getCurrentTime()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        //Check if Settings Popup filling is incomplete
        if let settingsStatus = Defaults.shared.settingsPopupStatus{
            if settingsStatus == 1 || settingsStatus == 2 || settingsStatus == 3 {
                //Show Settings with Popups
                let vc = SettingsVC.instantiate()
                vc.wasAppKilledWhenSettingsIncomplete = true
                self.pushVC(controller:vc)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            NotificationCenter.default.removeObserver(self)
        timer.invalidate()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    @objc func appMovedToForeground() {
        self.fetchDashboard()
    }
    
    @IBAction func menuClicked(sender:UIButton){
       // self.createBlurOverlay()
//        self.present(menu, animated: true, completion: {})
//        menuV.isHidden = false
        menuV.showHideMenu()
        self.btnMenu.isHidden = true
    }
    
    @IBAction func rightBarButtonClicked(sender:UIButton){
//        if logoutView.isHidden == true{
//            logoutView.isHidden = false
//        }else{
//            logoutView.isHidden = true
//        }
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
//                    let vc = SettingsVC.instantiate()
//                    vc.isForAccountSettings = true
//                    self.pushVC(controller:vc)
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
    func setData(){
//        logoutView.isHidden = true
        lblusername.text = Utility.getNameInitials()
        let currenttitme = Date().string(format: DateTimeFormat.h_mm.rawValue)
        lblTime.text = currenttitme
        lblampm.text = (Date().string(format: DateTimeFormat.a.rawValue)).lowercased()
      //  let currentdate = Date().string(format: DateTimeFormat.MMMM_dd_yyyy.rawValue)
       
    }
    private func setupMenu(){
//        let controller = MenuViewController.instantiate()
//        controller.delegate = self
//        controller.selectedOption = .TimeClock
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
        menuV.selectedOption = .TimeClock
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
    
    func fetchDashboard(){
        let currenttitme = Date().string(format: DateTimeFormat.h_mm.rawValue)
        lblTime.text = currenttitme
        lblampm.text = (Date().string(format: DateTimeFormat.a.rawValue)).lowercased()
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0] as [String : Any]
        let headerAuth = ["Authorization":"Bearer \(Defaults.shared.currentUser?.empToken ?? "")"]
        print(parameters)
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.dashboard(), param: parameters,header:headerAuth){ success, response, error in
            if let res = response{
                print(res)
                let dashBoardData = Mapper<DashBoardData>().map(JSONObject:res)
                self.dashboardData = dashBoardData
                print(dashBoardData ?? "")
               self.setupCalendarView(dashBoardData:dashBoardData)
                self.setDashBoardData(dashBoardData:dashBoardData)
                let currenttitme = Date().string(format: DateTimeFormat.h_mm.rawValue)
                self.lblTime.text = currenttitme
                self.lblampm.text = (Date().string(format: DateTimeFormat.a.rawValue)).lowercased()
                self.calanderCollectionView.reloadData()
            }else if let err = error{
                print(err)
            }
        }
    }
    func setDashBoardData(dashBoardData:DashBoardData?){
        
        if dashBoardData?.todayMinutes == 0{
            // imgStatus.tintColor = UIColor.Color.red
            imageviewClockinStatus.tintColor = UIColor.Color.red
            lblClockinStatus.text = Localizable.Clockin.notClockedIn
            btnClockin.backgroundColor = UIColor.Color.green
            //  btnClockin.cornerRadius = 0.0
            btnClockin.setTitle(Localizable.Clockin.btnCheckin, for: .normal)
        }
        else{
            switch dashBoardData?.currentStatus ?? "" {
                
            case UserStatus.loggedOut.rawValue:
                // imgStatus.tintColor = UIColor.Color.red
                imageviewClockinStatus.tintColor = UIColor.Color.red
                lblClockinStatus.text = Localizable.Clockin.clockedoutAt + " " + "\(dashBoardData?.lastEventTime ?? "")"
                btnClockin.backgroundColor = UIColor.Color.green
                //  btnClockin.cornerRadius = 0.0
                btnClockin.setTitle(Localizable.Clockin.btnCheckin, for: .normal)
                
            case UserStatus.loggedIN.rawValue:
                // imgStatus.tintColor = UIColor.Color.green
                imageviewClockinStatus.tintColor = UIColor.Color.green
                lblClockinStatus.text = Localizable.Clockin.clockedinAt + " " + "\(dashBoardData?.lastEventTime ?? "")"
                btnClockin.backgroundColor = UIColor.Color.red
                //  btnClockin.cornerRadius = btnClockin.frame.height / 2
                btnClockin.setTitle(Localizable.Clockin.btnCheckout, for: .normal)
                
            case UserStatus.Inbreak.rawValue:
                // imgStatus.tintColor = UIColor.Color.yellow
                imageviewClockinStatus.tintColor = UIColor.Color.yellow
                lblClockinStatus.text = Localizable.Clockin.btnInAt + " " + "\(dashBoardData?.lastEventTime ?? "")"
                btnClockin.backgroundColor = UIColor.Color.red
                btnClockin.setTitle(Localizable.Clockin.btnCheckout, for: .normal)
                
                btnStartBreak.setTitle(Localizable.Clockin.btnEndreak, for: .normal)
                
            case UserStatus.Endbreak.rawValue:
                // imgStatus.tintColor = UIColor.Color.green
                imageviewClockinStatus.tintColor = UIColor.Color.green
                lblClockinStatus.text = Localizable.Clockin.clockedinAt + " " + "\(dashBoardData?.lastEventTime ?? "")"
                btnClockin.backgroundColor = UIColor.Color.red
                btnClockin.setTitle(Localizable.Clockin.btnCheckout, for: .normal)
                
                btnStartBreak.setTitle(Localizable.Clockin.btnStartBreak, for: .normal)
                
            default:
                break
            }
        }
    }
    func fetchTimeLineByDate(date:String){
        print("fetchTimeLineByDate \(date)")
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0,
            "timeline_date":date] as [String : Any]
        print(parameters)
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.timelineByDate(), param: parameters, header: Defaults.shared.header ?? ["":""]){ success, response, error in
            if let res = response{
                print(res)
                let timeLineData = Mapper<TimeLineData>().map(JSONObject:res)
                print(timeLineData ?? "")
                self.setTimeLineData(timelineData:timeLineData)
                self.calanderCollectionView.reloadData()
            }else if let err = error{
                print(err)
            }
        }
    }
    private func changeStatus(event_type: String) {

        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0,
            "event_type":event_type] as [String : Any]
        
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.createEvent(), param: parameters, header: Defaults.shared.header ?? ["":""]) { success, response, error in
            if success {
                self.fetchDashboard()
                print(response ?? "")
                let dateFormat = "MMM,dd YYYY"
                
                let timeFormat = "hh:mm"
                let timeFormatampm = "a"
                let time = Date().string(format: timeFormat)
                let date = Date().string(format: dateFormat)
                let ampm = Date().string(format: timeFormatampm)
                self.lblDatebreakinPopup.text = date
                self.lblDateclockOutPopup.text = date
                self.lblDateClockInPopup.text = date
                
                
                self.lbltimebreakinPopup.text = time
                self.lbltimeclockOutPopup.text = time
                self.lbltimeClockInPopup.text = time
                
                self.lbltimeClockInampm.text = ampm
                self.lbltimeclockOutampm.text = ampm
                self.lbltimebreakinampm.text = ampm
                
                if  event_type == UserStatus.loggedIN.rawValue {
                   // self.showSucessMessage(strMessage: Localizable.Clockin.clokcin)
                    self.clockInSuccessPopup.isHidden = false
                    
                   
                } else if  event_type == UserStatus.loggedOut.rawValue {
                   // self.showSucessMessage(strMessage: Localizable.Clockin.clockedout)
                    self.clockOutSuccessPopup.isHidden = false
                }else if  event_type == UserStatus.Inbreak.rawValue {
                    // self.showSucessMessage(strMessage: Localizable.Clockin.clockedout)
                    self.breakinSuccessPopup.isHidden = false
                    self.lblMessagebreakinPopup.text = NSLocalizedString("You are on lunch break!", comment: "lblMessagebreakinPopup")
                 }else if  event_type == UserStatus.Endbreak.rawValue {
                     // self.showSucessMessage(strMessage: Localizable.Clockin.clockedout)
                     self.clockInSuccessPopup.isHidden = false
                  }
            }else{
                if let err = error{
                    print(err)
//                    if err.errodCode == CreateEventError.L{
//                        self.geofeneAlertview.isHidden = false
//                        self.geofeneAlertMessage.text = CreateEventError.LMessage
//                    }else if err.errodCode == CreateEventError.D || err.errodCode == CreateEventError.I{
//                        self.geofeneAlertMessage.text = CreateEventError.IMessage
//                    self.geofeneAlertview.isHidden = false
                }
            }
        }

       
    }
    func setTimeLineData(timelineData:TimeLineData?){
        
        for view in stackviewtimesheet.subviews{
            view.removeFromSuperview()
        }
        for event in timelineData?.timeline ?? [Timeline](){
              let timeReportViewNew = TimeReportView()
            
              
            self.stackviewtimesheet.addArrangedSubview(timeReportViewNew)
              timeReportViewNew.translatesAutoresizingMaskIntoConstraints = false
              let heightConstraint = NSLayoutConstraint(item: timeReportViewNew, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
              timeReportViewNew.addConstraints([heightConstraint])
              
            let timeLineEvent = event.timelineEvent ?? ""
            if timeLineEvent == "I"{
                timeReportViewNew.titleLabel.text = NSLocalizedString("Shift Start:", comment: "timeReportViewNew")
                timeReportViewNew.barView.backgroundColor = UIColor.startShiftColor
               // startTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
            }else if timeLineEvent == "O"{
                timeReportViewNew.titleLabel.text = NSLocalizedString("Shift End:", comment: "timeReportViewNew")
                timeReportViewNew.barView.backgroundColor = UIColor.endShiftColor
               // endTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
            }else if timeLineEvent == "B"{
                timeReportViewNew.titleLabel.text = NSLocalizedString("Break Start:", comment: "timeReportViewNew")
                timeReportViewNew.barView.backgroundColor = UIColor.breakStartColor
              //  breakstartTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
            }else if timeLineEvent == "S"{
                timeReportViewNew.titleLabel.text = NSLocalizedString("Break End:", comment: "lblMessagebreakinPopup")
                timeReportViewNew.barView.backgroundColor = UIColor.breakEndColor
               // breakEndTime = event.timelineTime?.toDate(dateFormat:DateTimeFormat.wholedateTime.rawValue)
            }
            
          
           timeReportViewNew.timeLabel.text = event.timelineValue
            
          }
        let strTotalMins = NSString(format: "%.1f", timelineData?.totalHoursF ?? 0.0)
        
        let totalHoursMins = (strTotalMins).components(separatedBy:".")
        let touple = self.minutesToHoursAndMinutes(Int(totalHoursMins[0]) ?? 0)
        self.lblTotalHr.text = "\(touple.hours)"
        self.lblTotalMin.text = "\(touple.leftMinutes)"
    }
    func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func secondsToHoursAndMinutes(_ seconds: Int) -> (hours: Int , leftMinutes: Int) {
        return (seconds / 3600, (seconds % 3600) / 60)
    }
    
    func setupCalendarView(dashBoardData:DashBoardData?){
        
        
        let weeklyHoursMins = (dashBoardData?.weeklyHours ?? "0.0").components(separatedBy:".")
       
        let touple = self.minutesToHoursAndMinutes(Int(weeklyHoursMins[0]) ?? 0)
       
        self.lblweeklyHr.text = "\(touple.hours)"
        self.lblweeklyMin.text = "\(touple.leftMinutes)"
        //  lblTotalHours.attributedText = self.clockAttributed(hour: "\(touple.hours)", minutes: "\(touple.leftMinutes)")
        self.lblPayPeriod.text = dashBoardData?.payPeriod ?? ""
        
        let todayHoursMins = ("\(dashBoardData?.todayMinutes ?? 0)" ).components(separatedBy:".")
//        let todayHoursMinstouple = self.minutesToHoursAndMinutes(Int(todayHoursMins[0]) ?? 0)
        let todayHoursMinstouple = self.secondsToHoursAndMinutes(Int(todayHoursMins[0]) ?? 0)
        self.lblDailyHours.text = "Daily Hours \(todayHoursMinstouple.hours)hr \(todayHoursMinstouple.leftMinutes)min "
        
        let startDate = (dashBoardData?.payPeriodFrom ?? "").toDate(format:DateTimeFormat.yyyy_MM_dd.rawValue)
        var endDate = (dashBoardData?.payPeriodTo ?? "").toDate(format: DateTimeFormat.yyyy_MM_dd.rawValue)
        endDate = Calendar.current.date(byAdding: .day, value: -1, to: endDate)!
        let numberOfColumn = Device.current.isPad ? 7 : 3
        Utility.setupCollectionUi(collection:calanderCollectionView, cellHeight: 90.0,numberOfColumn:numberOfColumn,scrollDirection:UICollectionView.ScrollDirection.horizontal.rawValue)
        let dateArray = calendar.getDates(startDate, endDate)
        itemsDate = dateArray.chunked(into: numberOfColumn)
        print(itemsDate)
        calanderCollectionView.delegate = self
        calanderCollectionView.dataSource = self
        calanderCollectionView.allowsMultipleSelection = false
        calanderCollectionView.reloadData()
        var indexPath = NSIndexPath(row: 0, section: 0)
        for i in 0..<itemsDate.count {
            if let obj = itemsDate[i].firstIndex(of:now.startOfDay){
                indexPath = NSIndexPath(row: obj, section: i)
                break
            }
        }
        
     //   self.calanderCollectionView.selectItem(at:indexPath as IndexPath, animated: true, scrollPosition: .centeredHorizontally)
        var offsetX = 0
        if indexPath.section > 0{
            offsetX = Int(self.calanderCollectionView.frame.width) * indexPath.section
        }
        self.calanderCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
      //  let date = self.itemsDate[indexPath.section][indexPath.row]
       // selectedDate = date
        selectedDate = Date()
        lblDate.text = (selectedDate.toString(format: .custom(DateTimeFormat.MMM_dd_yyyy.rawValue)))
        strCurrentDate = selectedDate.string(format: DateTimeFormat.yyyy_MM_dd.rawValue)
        fetchTimeLineByDate(date: strCurrentDate)
           
    }
    @IBAction func btnClockInTapped(_ sender: Any) {
        
        if self.dashboardData?.currentStatus ?? "" == UserStatus.loggedIN.rawValue ||  self.dashboardData?.currentStatus ?? "" == UserStatus.Endbreak.rawValue {
            changeStatus(event_type: UserStatus.loggedOut.rawValue)
       
        } else if self.dashboardData?.currentStatus ?? "" == UserStatus.loggedOut.rawValue || self.dashboardData?.currentStatus ?? "" == UserStatus.Endbreak.rawValue{
            changeStatus(event_type: UserStatus.loggedIN.rawValue)
        }
        else{
            self.showAlert(alertType:.validation, message: NSLocalizedString("Plese end lunch break first.", comment: "ClockInAlert"))
        }
    }
    
    @IBAction func btnStartBreakTapped(_ sender: Any) {
        
        if self.dashboardData?.currentStatus ?? "" == UserStatus.loggedIN.rawValue {
            
            changeStatus(event_type: UserStatus.Inbreak.rawValue)
      
        } else if self.dashboardData?.currentStatus ?? "" == UserStatus.Inbreak.rawValue {
            
            changeStatus(event_type: UserStatus.Endbreak.rawValue)
      
        } else if self.dashboardData?.currentStatus ?? "" == UserStatus.Endbreak.rawValue {
            changeStatus(event_type: UserStatus.Inbreak.rawValue)
        }
        else{
            self.showAlert(alertType:.validation, message: NSLocalizedString("You have to clock in first.", comment: "StartBreakAlert"))
        }
    }
    @IBAction func calenderNextClick(sender:UIButton){
        calanderCollectionView.scrollToNextItem()
    }
    @IBAction func calenderPrevClick(sender:UIButton){
        calanderCollectionView.scrollToPrevItem()
    }
    
    @IBAction func clockInPopUpOkClick(sender:UIButton){
        self.clockInSuccessPopup.isHidden = true
        self.breakinSuccessPopup.isHidden = true
        self.clockOutSuccessPopup.isHidden = true
    }
}
extension DashBoardVC:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.itemsDate.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.itemsDate[section].count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = calanderCollectionView.dequeueReusableCell(withReuseIdentifier: CalendarCell.reuseIdentifier, for: indexPath as IndexPath) as! CalendarCell
        let date = self.itemsDate[indexPath.section][indexPath.row]
        cell.TitleLabel.text = date.string(format:DateTimeFormat.EEEE.rawValue)
        cell.dateLabel.text = date.string(format:DateTimeFormat.dd.rawValue)
        cell.dateLabel.textColor = .darkGray
        
        if Calendar.current.isDate(selectedDate, equalTo: date, toGranularity: .day){
//        if selectedDate == date{
            cell.isSelected = true
        }
        else{
            cell.isSelected = false
        }
        cell.setCellUIForSelection()

        return cell
    }
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        let date = self.itemsDate[indexPath.section][indexPath.row]
        selectedDate = date
//        lblDate.text = (selectedDate.toString(format: .custom(DateTimeFormat.MMM_dd_yyyy.rawValue)))
        strCurrentDate = selectedDate.string(format: DateTimeFormat.yyyy_MM_dd.rawValue)
        fetchTimeLineByDate(date: strCurrentDate)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calanderCollectionView.frame.width / CGFloat(itemsDate[indexPath.section].count)
        return CGSize(width:width, height: 90)
    }
}
extension DashBoardVC:MenuItemDelegate {
    func MenuItemClicked(menuName: String) {
        print(menuName)
        if menuName == Menuname.settings{
            self.removeBlurOverlay()
            let vc = SettingsVC.instantiate()
            self.pushVC(controller:vc)
        }else  if menuName == Menuname.logout{
            self.removeBlurOverlay()
            Defaults.shared.currentUser = nil
            Utility.setRootScreen(isShowAnimation: true)
//            logoutView.isHidden = true
          
        }else  if menuName == Menuname.employee{
            self.removeBlurOverlay()
            let vc = EmployeesVC.instantiate()
            self.pushVC(controller:vc)
            
        }else  if menuName == Menuname.timeSheet{
            self.removeBlurOverlay()
            let vc = TimesheetListVC.instantiate()
            self.pushVC(controller:vc)
          
        }
    }
    func createBlurOverlay(){
        let view = UIView(frame:self.view.frame)
        view.tag = 11111
        view.backgroundColor = .black.withAlphaComponent(0.5)
        self.view.addSubview(view)
    }
    func removeBlurOverlay(){
        for view in self.view.allSubViewsOf(type:UIView.self){
            if view.tag == 11111{
                view.removeFromSuperview()
                break
            }
        }
    }
}

extension DashBoardVC: CustomMenuItemDelegate {
    func customMenuItemClicked(menuName: String) {
        print(menuName)
        if menuName == Menuname.settings{
            
            let vc = SettingsVC.instantiate()
            self.pushVC(controller:vc)
        }else  if menuName == Menuname.logout{
            
            Defaults.shared.currentUser = nil
            Utility.setRootScreen(isShowAnimation: true)
            //            logoutView.isHidden = true
            
        }else  if menuName == Menuname.employee{
            
            let vc = EmployeesVC.instantiate()
            self.pushVC(controller:vc)
            
        }else  if menuName == Menuname.timeSheet{
            
            let vc = TimesheetListVC.instantiate()
            self.pushVC(controller:vc)
            
        }
        self.btnMenu.isHidden = false
    }
    
    func customMenuDidHide(){
        self.btnMenu.isHidden = false
    }
}

extension UIColor{
//    static let startShiftColor = UIColor(hex:"81C469")
//    static let breakStartColor = UIColor(hex:"F1A25B")
//    static let breakEndColor = UIColor(hex:"78828D")
//    static let endShiftColor = UIColor(hex:"C46561")
    static let startShiftColor = UIColor(hex:"5EA426")
    static let breakStartColor = UIColor(hex:"F0C42F")
    static let breakEndColor = UIColor(hex:"F0C42F")
    static let endShiftColor = UIColor(hex:"D13024")
                                   
}
extension UIView {

    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
