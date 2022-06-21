//
//  UserEmployee.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import Foundation
import ObjectMapper

class EmployeeData: Codable, Mappable {

    var status: Int?
    var message: String?
    var empData: [EmpData]?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        empData <- map["emp_data"]
    }
}

class EmpData:Codable,Mappable {

    var empId: Int?
    var empUsername: String?
    var empFirstname: String?
    var empLastname: String?
    var empPassword: String?
    var empWorkEmail: String?
    var empJobTitle: String?
    var empType: String?
    var merchantId: Int?
    var merchantName: String?
    var merchantProfileCompleted: String?
    var merchantReferenceNumber: String?
    var merchantTimezone: String?
    var empToken: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        empId <- map["emp_id"]
        empUsername <- map["emp_username"]
        empFirstname <- map["emp_firstname"]
        empLastname <- map["emp_lastname"]
        empPassword <- map["emp_password"]
        empWorkEmail <- map["emp_work_email"]
        empJobTitle <- map["emp_job_title"]
        empType <- map["emp_type"]
        merchantId <- map["merchant_id"]
        merchantName <- map["merchant_name"]
        merchantProfileCompleted <- map["merchant_profile_completed"]
        merchantReferenceNumber <- map["merchant_reference_number"]
        merchantTimezone <- map["merchant_timezone"]
        empToken <- map["emp_token"]
    }
}
