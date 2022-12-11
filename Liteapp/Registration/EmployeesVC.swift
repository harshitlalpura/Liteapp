//
//  EmployeesVC.swift
//  Liteapp
//
//  Created by Navroz Huda on 12/06/22.
//

import UIKit
import SideMenu
import ObjectMapper
import Alamofire

enum EmployeeSortType:Int{
   // asc / desc
    case none = 0
    case name = 1
    case jobtitle = 2
}
class EmployeesVC:BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.merchantipad.rawValue : StoryboardName.merchant.rawValue, bundle: nil)
    var menu:SideMenuNavigationController!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var tblview: UITableView!
    var employeeList =  [Employee]()
    var isFromProfileSetup = false
    @IBOutlet weak var nameSortImageview: UIImageView!
    @IBOutlet weak var jobTitleSortImageview: UIImageView!
  
    @IBOutlet weak var lblCreateEmployee: UILabel!
    @IBOutlet weak var btnCreateEmployeeNoEmployeeView: UIButton!
    @IBOutlet weak var viewNoEmployeesAdded: UIView!
    @IBOutlet weak var customNavView: UIView!
    
    var menuV : CustomMenuView!
    @IBOutlet weak var btnMenu: UIButton!
    
    var sortNameType = Sort.defaultShort
    var sortJobTitleType = Sort.defaultShort
   
    var currentSortType = EmployeeSortType.none
    
    var sortType = ""
    var sortColumn = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenu()
        setData()
        setTableView()
    }
    func setTableView(){
        //self.tblview.register(EmployeeCell.self, forCellWithReuseIdentifier: "EmployeeCell")
        tblview.delegate = self
        tblview.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchEmployees()
        if isFromProfileSetup{
            isFromProfileSetup = false
            let vc = CreateEmployeeVC.instantiate()
            self.pushVC(controller:vc)
        }
    }
    @IBAction func menuClicked(sender:UIButton){
//        self.present(menu, animated: true, completion: {})
        menuV.showHideMenu()
        self.btnMenu.isHidden = true
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
    @IBAction func sortNameClicked(sender:UIButton){
        sortColumn = ""
        
        nameSortImageview.image = UIImage.sortDefault
        jobTitleSortImageview.image = UIImage.sortDefault
        
        
        if sortNameType == Sort.decending{
            currentSortType = EmployeeSortType.none
            sortType = Sort.defaultShort.rawValue
            sortColumn = "emp_firstname"
            sortNameType = Sort.defaultShort
        }else if sortNameType == Sort.defaultShort{
            currentSortType = EmployeeSortType.name
            sortType = Sort.ascending.rawValue
            sortColumn = "emp_firstname"
            sortNameType = Sort.ascending
            nameSortImageview.image = UIImage.sortAsc
        }else if sortNameType == Sort.ascending{
            currentSortType = EmployeeSortType.name
            sortType = Sort.decending.rawValue
            sortColumn = "emp_firstname"
            sortNameType = Sort.decending
            nameSortImageview.image = UIImage.sortDesc
        }
        fetchEmployees()
    }
    @IBAction func sortJobTitleClicked(sender:UIButton){
        sortColumn = ""
        nameSortImageview.image = UIImage.sortDefault
        jobTitleSortImageview.image = UIImage.sortDefault
       
        if sortJobTitleType == Sort.decending{
            currentSortType = EmployeeSortType.none
            sortType = Sort.defaultShort.rawValue
            sortColumn = "emp_job_title"
            sortJobTitleType = Sort.defaultShort
        }else if sortJobTitleType == Sort.defaultShort{
            currentSortType = EmployeeSortType.jobtitle
            sortType = Sort.ascending.rawValue
            sortColumn = "emp_job_title"
            sortJobTitleType = Sort.ascending
            jobTitleSortImageview.image = UIImage.sortAsc
        }else if sortJobTitleType == Sort.ascending{
            currentSortType = EmployeeSortType.jobtitle
            sortType = Sort.decending.rawValue
            sortColumn = "emp_job_title"
            sortJobTitleType = Sort.decending
            jobTitleSortImageview.image = UIImage.sortDesc
        }
        fetchEmployees()
    }
    @IBAction func addEmployeeClicked(sender:UIButton){
        showAddEmployeeScreen()
    }
    
    func showAddEmployeeScreen(){
        let vc = AddEmployeeVC.instantiate()
        vc.delegate = self
        self.presentVC(controller: vc, animated: false)
      //  self.pushVC(controller: vc)
    }
    
    func setData(){
        lblusername.text = Utility.getNameInitials()
        viewNoEmployeesAdded.isHidden = true
        
        
//        let font1 = UIFont.Robotolight(size: 16.0)
//        let font2 = UIFont.Robotobold(size: 16.0)
        
        let lightFont = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                          NSAttributedString.Key.font: UIFont.Robotolight(size: 16.0)]
        let boldFont = [ NSAttributedString.Key.foregroundColor: UIColor.white,
                         NSAttributedString.Key.font: UIFont.Robotobold(size: 16.0)]
        
        let attString = NSMutableAttributedString()
        attString.append(NSAttributedString(string: "Create your employees ", attributes: lightFont))
        attString.append(NSAttributedString(string: "here ", attributes: boldFont))
        
        
        lblCreateEmployee.attributedText = attString
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
    
    func fetchEmployees(){
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0,
            "limit":"100",
            "offset":"0",
            "sort_column":self.sortColumn,
            "sort_type":self.sortType,
        ] as [String : Any]

        print(parameters)
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.fetchAllemployees(), param: parameters, header: Defaults.shared.header ?? ["":""]){ success, response, error in
            if let res = response{
                print(res)
                let data = Mapper<EmployeesData>().map(JSONObject:res)
                self.employeeList = data?.employeeList ?? [Employee]()
                self.tblview.reloadData()
                if self.employeeList.count > 0 {
                    self.viewNoEmployeesAdded.isHidden = true
                }
                else{
                    self.viewNoEmployeesAdded.isHidden = false
                }
                
            }else if let err = error{
                print(err)
            }
        }
    }
    
    @IBAction func btnCreateNewEmployeeTapped(_ sender: Any) {
        showAddEmployeeScreen()
    }
    
}
extension EmployeesVC:AddEmployeeVCDelegate{
    func didDismiss() {
        let vc = CreateEmployeeVC.instantiate()
        self.pushVC(controller:vc)
    }
}
extension EmployeesVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblview.dequeueReusableCell(withIdentifier: EmployeeCell.reuseIdentifier, for: indexPath as IndexPath) as! EmployeeCell
        let employee = self.employeeList[indexPath.row]
        cell.lblName.text = (employee.empFirstname ?? "") + " " + (employee.empLastname ?? "")
        cell.lblJobTitle.text = employee.empJobTitle ?? ""
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EmployeeTimeReportVC.instantiate()
        vc.isFromEmployee = true
        vc.selectedEmployeeID = self.employeeList[indexPath.row].empId?.stringValue ?? ""
        self.pushVC(controller:vc)
    }
    
    
}
extension EmployeesVC:MenuItemDelegate {
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


extension EmployeesVC: CustomMenuItemDelegate {
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
    func customMenuDidHide(){
        self.btnMenu.isHidden = false
    }
}
