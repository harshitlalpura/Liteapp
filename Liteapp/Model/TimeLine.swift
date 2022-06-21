//
//  TimeLine.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import Foundation
import ObjectMapper

class TimeLineData: Mappable {

    var status: NSNumber?
    var timeline: [Timeline]?
    var totalHours: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        status <- map["status"]
        timeline <- map["timeline"]
        totalHours <- map["total_hours"]
    }
}

class Timeline: Mappable {

    var timelineId: NSNumber?
    var timelineEvent: String?
    var timelineTime: String?
    var timelineValue: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        timelineId <- map["timeline_id"]
        timelineEvent <- map["timeline_event"]
        timelineTime <- map["timeline_time"]
        timelineValue <- map["timeline_value"]
    }
}



class DashBoardData: Mappable {

    var status: NSNumber?
    var currentStatus: String?
    var payPeriod: String?
    var payPeriodFrom: String?
    var payPeriodTo: String?
    var weeklyHours: String?
    var todayMinutes: NSNumber?
    var lastEventTime: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        status <- map["status"]
        currentStatus <- map["current_status"]
        payPeriod <- map["pay_period"]
        payPeriodFrom <- map["pay_period_from"]
        payPeriodTo <- map["pay_period_to"]
        weeklyHours <- map["weekly_hours"]
        todayMinutes <- map["today_minutes"]
        lastEventTime <- map["last_event_time"]
    }
}


class MerchantSettingsData: Mappable {

    var status: NSNumber?
    var settings: [MerchantSettings]?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        status <- map["status"]
        settings <- map["message"]
    }
}

class MerchantSettings: Mappable {

    var empFirstname: String?
    var empLastname: String?
    var empWorkEmail: String?
    var merchantWeeklyOvertimeEnabled: String?
    var merchantWeeklyOvertime: NSNumber?
    var merchantDailyOvertimeEnabled: String?
    var merchantDailyOvertime: NSNumber?
    var merchantPayPeriod: String = "B"
    var merchantWeekStart: NSNumber?
    var merchantCurrentPayWeek: NSNumber?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        empFirstname <- map["emp_firstname"]
        empLastname <- map["emp_lastname"]
        empWorkEmail <- map["emp_work_email"]
        merchantWeeklyOvertimeEnabled <- map["merchant_weekly_overtime_enabled"]
        merchantWeeklyOvertime <- map["merchant_weekly_overtime"]
        merchantDailyOvertimeEnabled <- map["merchant_daily_overtime_enabled"]
        merchantDailyOvertime <- map["merchant_daily_overtime"]
        merchantPayPeriod <- map["merchant_pay_period"]
        merchantWeekStart <- map["merchant_week_start"]
        merchantCurrentPayWeek <- map["merchant_current_pay_week"]
        
    }
}
class TimesheetData: Mappable {

    var status: NSNumber?
    var timesheets: [PayPeriodTimesheet]?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        status <- map["status"]
        timesheets <- map["data"]
    }
}

class PayPeriodTimesheet: Mappable {

    var payperiodEmpId: NSNumber?
    var empId: NSNumber?
    var empFirstname: String?
    var empLastname: String?
    var empStatus: String?
    var empJobTitle: String?
    var empPay: String?
    var empSalaryTimesheetEnabled: String?
    var regular: NSNumber?
    var overtime: NSNumber?
    var total: String?
    var payperiodStatus: String?
    var payperiodId: NSNumber?
    var payperiodFrom: String?
    var payperiodTo: String?
    var hours: [Hours]?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        payperiodEmpId <- map["payperiod_emp_id"]
        empId <- map["emp_id"]
        empFirstname <- map["emp_firstname"]
        empLastname <- map["emp_lastname"]
        empStatus <- map["emp_status"]
        empJobTitle <- map["emp_job_title"]
        empPay <- map["emp_pay"]
        empSalaryTimesheetEnabled <- map["emp_salary_timesheet_enabled"]
        regular <- map["regular"]
        overtime <- map["overtime"]
        total <- map["total"]
        payperiodStatus <- map["payperiod_status"]
        payperiodId <- map["payperiod_id"]
        payperiodFrom <- map["payperiod_from"]
        payperiodTo <- map["payperiod_to"]
        hours <- map["hours"]
    }
}

class Hours: Mappable {

    var totalHours: NSNumber?
    var totalMinutes: NSNumber?
    var projectedHours: NSNumber?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        totalHours <- map["total_hours"]
        totalMinutes <- map["total_minutes"]
        projectedHours <- map["projected_hours"]
    }
}
