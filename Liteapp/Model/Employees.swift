//
//  Employees.swift
//  Liteapp
//
//  Created by Navroz Huda on 12/06/22.
//

import Foundation
import ObjectMapper

class EmployeesData: Mappable {

    var status: NSNumber?
    var employeeList: [Employee]?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        status <- map["status"]
        employeeList <- map["data"]
    }
}

class Employee: Mappable {

    var empId: NSNumber?
    var empFirstname: String?
    var empLastname: String?
    var empWorkEmail: String?
    var empJobTitle: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        empId <- map["emp_id"]
        empFirstname <- map["emp_firstname"]
        empLastname <- map["emp_lastname"]
        empWorkEmail <- map["emp_work_email"]
        empJobTitle <- map["emp_job_title"]
    }
}
struct UpdateEmployee{
    var merchantId:String = "\(Defaults.shared.currentUser?.merchantId ?? 0)"
    var empToken:String = Defaults.shared.currentUser?.empToken ?? ""
    var empId:String = "\(Defaults.shared.currentUser?.empId ?? 0)"
    var empID:String?
    var empFirstname:String?
    
    var empLastname:String?
    var empJobTitle:String?
    
    var empWorkEmail:String?
    var empPassword:String?
    
    var timesheet:String?
    var timezone:String?

    
   
    
    func getParam()->[String:Any]{
        
        let parameters = ["merchant_id":"\(self.merchantId)" ,
                          "emp_token":"\(self.empToken)",
                          "emp_id":"\(self.empId)",
                          "empID":"\(self.empID ?? "")",
                          "emp_firstname":"\(self.empFirstname ?? "")",
                          "emp_lastname":"\(self.empLastname ?? "")",
                          "emp_job_title":"\(self.empJobTitle ?? "")",
                          "emp_work_email":"\(self.empWorkEmail ?? "")",
                          "emp_password":"\(self.empPassword ?? "")",
                          "timesheet":"\(self.timesheet ?? "")",
                          "timezone":"\(self.timezone ?? "")"]
        return parameters
    }
    
}

struct DeleteEmployee{
    var merchantId:String = "\(Defaults.shared.currentUser?.merchantId ?? 0)"
    var empToken:String = Defaults.shared.currentUser?.empToken ?? ""
    var empId:String = "\(Defaults.shared.currentUser?.empId ?? 0)"
    var empID:String?
  
    func getParam()->[String:Any]{
        
        let parameters = ["merchant_id":"\(self.merchantId)" ,
                          "emp_token":"\(self.empToken)",
                          "emp_id":"\(self.empId)",
                          "empID":"\(self.empID ?? "")"]
        return parameters
    }
    
}

struct CreateEmployee{

    var merchantId:String = "\(Defaults.shared.currentUser?.merchantId ?? 0)"
    var empToken:String = Defaults.shared.currentUser?.empToken ?? ""
    var empId:String = "\(Defaults.shared.currentUser?.empId ?? 0)"
    var empID:String?
    var empFirstname:String?
    
    var empLastname:String?
    var empJobTitle:String?
    
    var empWorkEmail:String?
    var empPassword:String?
    
    var timesheet:String?
    var timezone:String?

    
   
    
    func getParam()->[String:Any]{
        
        let parameters = ["merchant_id":"\(self.merchantId)" ,
                          "emp_token":"\(self.empToken)",
                          "emp_id":"\(self.empId)",
                          "emp_firstname":"\(self.empFirstname ?? "")",
                          "emp_lastname":"\(self.empLastname ?? "")",
                          "emp_job_title":"\(self.empJobTitle ?? "")",
                          "emp_work_email":"\(self.empWorkEmail ?? "")",
                          "emp_password":"\(self.empPassword ?? "")",
                          "timesheet":"\(self.timesheet ?? "")",
                          "timezone":"\(self.timezone ?? "")"]
        return parameters
    }
}
class EmployeeDetailsData: Mappable {

    var status: NSNumber?
    var employees: [EmployeeDetails]?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        status <- map["status"]
        employees <- map["data"]
    }
}

class EmployeeDetails: Mappable {

    var empId: NSNumber?
    var empFirstname: String?
    var empLastname: String?
    var empPassword: String?
    var empWorkEmail: String?
    var empJobTitle: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        empId <- map["emp_id"]
        empFirstname <- map["emp_firstname"]
        empLastname <- map["emp_lastname"]
        empPassword <- map["emp_password"]
        empWorkEmail <- map["emp_work_email"]
        empJobTitle <- map["emp_job_title"]
    }
}
