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

class EmployeesVC:BaseViewController, StoryboardSceneBased{
    
    static let sceneStoryboard = UIStoryboard(name: StoryboardName.merchant.rawValue, bundle: nil)
    var menu:SideMenuNavigationController!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var tblview: UITableView!
    var employeeList =  [Employee]()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenu()
        setData()
        self.logoutView.dropShadow()
        setTableView()
    }
    func setTableView(){
        //self.tblview.register(EmployeeCell.self, forCellWithReuseIdentifier: "EmployeeCell")
        tblview.delegate = self
        tblview.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchEmployees()
    }
    @IBAction func menuClicked(sender:UIButton){
        self.present(menu, animated: true, completion: {})
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
    @IBAction func addEmployeeClicked(sender:UIButton){
        let vc = AddEmployeeVC.instantiate()
        self.pushVC(controller: vc)
    }
    func setData(){
        logoutView.isHidden = true
        lblusername.text = "\(Defaults.shared.currentUser?.empFirstname ?? "") \(Defaults.shared.currentUser?.empLastname ?? "")"
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
    func fetchEmployees(){
        let parameters = ["merchant_id":Defaults.shared.currentUser?.merchantId ?? 0,
            "emp_token":Defaults.shared.currentUser?.empToken ?? "",
            "emp_id":Defaults.shared.currentUser?.empId ?? 0,
            "limit":"100",
            "offset":"0",
            "sort_column":"emp_firstname",
            "sort_type":"asc",
        ] as [String : Any]

        print(parameters)
        NetworkLayer.sharedNetworkLayer.postWebApiCallwithHeader(apiEndPoints: APIEndPoints.fetchAllemployees(), param: parameters, header: Defaults.shared.header ?? ["":""]){ success, response, error in
            if let res = response{
                print(res)
                let data = Mapper<EmployeesData>().map(JSONObject:res)
                self.employeeList = data?.employeeList ?? [Employee]()
                self.tblview.reloadData()
                
            }else if let err = error{
                print(err)
            }
        }
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
