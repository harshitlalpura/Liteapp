//
//  OnBoardingManager.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import Foundation

struct SaveMerchant{
    var merchant_name:String?
    var merchant_timezone:String?
    var merchant_company_size:String?
    var merchant_zip:String?
    var merchant_web:String = ""
    
    var merchant_lite_enabled:String = "YES"
    var emp_firstname:String?
    var emp_lastname:String?
    var emp_work_email:String?
    var emp_username:String?
    var emp_password:String?
    
    func getParam()->[String:Any]{
        
        let parameters = ["merchant_name":"\(self.merchant_name ?? "")",
                          "merchant_timezone":"\(self.merchant_timezone ?? "")",
                          "merchant_company_size":"\(self.merchant_company_size ?? "")",
                          "merchant_zip":"\(self.merchant_zip ?? "")",
                            "merchant_web":"\(self.merchant_web)",
                          "merchant_lite_enabled":"\(self.merchant_lite_enabled)",
                          "emp_firstname":"\(self.emp_firstname ?? "")",
                          "emp_lastname":"\(self.emp_lastname ?? "")",
                          "emp_work_email":"\(self.emp_work_email ?? "")",
                          "emp_username":"\(self.emp_username ?? "")",
                          "emp_password":"\(self.emp_password ?? "")"]
        return parameters
    }
    
}

struct SetupMerchant{
    var merchant_id:String?
    var merchant_week_start:String?
    var merchant_pay_period:String?
    var merchant_current_pay_week:String?
    var merchant_weekly_overtime:String?
    
    var merchant_daily_overtime:String?
    var merchant_timezone:String?

    
   // let parameters = "merchant_id=28&merchant_week_start=1&merchant_pay_period=B&merchant_current_pay_week=1&merchant_weekly_overtime=34&merchant_daily_overtime=10&merchant_timezone=US%2FEastern"
    
    func getParam()->[String:Any]{
        
        let parameters = ["merchant_id":self.merchant_id ?? "",
                          "merchant_week_start":self.merchant_week_start ?? "",
                          "merchant_pay_period":self.merchant_pay_period ?? "",
                          "merchant_current_pay_week":self.merchant_current_pay_week ?? "",
                          "merchant_weekly_overtime":self.merchant_weekly_overtime ?? "",
                          "merchant_daily_overtime":self.merchant_daily_overtime ?? "",
                          "merchant_timezone":self.merchant_timezone ?? ""]
        return parameters
    }
    
}

struct SaveEmployee{
    var merchant_id:String?
    var emp_firstname:String?
    var emp_lastname:String?
//    var emp_job_title:String?
    var emp_work_email:String?
    
    var emp_password:String?
   
   // let parameters = "merchant_id=27&emp_firstname=Navroz&emp_lastname=Huda&emp_job_title=Chief%20iOS%20Manager&emp_work_email=navrozhuda%40gmail.com&emp_password=1234"
    
    func getParam()->[String:Any]{
        
        let parameters = ["merchant_id":self.merchant_id ?? "",
                          "emp_firstname":self.emp_firstname ?? "",
                          "emp_lastname":self.emp_lastname ?? "",
//                          "emp_job_title":self.emp_job_title ?? "",
                          "emp_job_title":"",
                          "emp_work_email":self.emp_work_email ?? "",
                          "emp_password":emp_password ?? ""]
        return parameters
    }
    
}


