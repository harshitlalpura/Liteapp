import Foundation 
import ObjectMapper 

class EmployeeTimeReportData: Mappable { 

	var status: NSNumber? 
	var payperiods: [Payperiods]? 
	var merchant: [Merchant]? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		status <- map["status"] 
		payperiods <- map["payperiods"] 
		merchant <- map["merchant"] 
	}
} 

class Merchant: Mappable { 

	var merchantId: NSNumber? 
	var merchantName: String? 
	var merchantAppImage: String? 
	var merchantImage: String? 
	var merchantImageMime: String? 
	var merchantSubdomain: String? 
	var merchantPanelSubdomain: String? 
	var merchantCompanySize: String? 
	var merchantBusinessType: String? 
	var merchantBusinessIndustry: String? 
	var merchantAddress: Any? 
	var merchantCity: String? 
	var merchantState: String? 
	var merchantZip: String? 
	var merchantPhone: String? 
	var merchantCountry: String? 
	var merchantWeb: String? 
	var merchantMaxHoursBreak: NSNumber? 
	var merchantPayPeriod: String? 
	var merchantWeekStart: NSNumber? 
	var merchantCurrentPayWeek: NSNumber? 
	var merchantHighHours: NSNumber? 
	var merchantForceClockOutNotificationEnabled: String? 
	var merchantLateShiftAllowance: NSNumber? 
	var merchantPanelLoginBg: String? 
	var merchantFrontLoginBg: String? 
	var merchantFrontDashboardBg: String? 
	var merchantFrontTimeclockBg: String? 
	var merchantTimezone: String? 
	var merchantCreatedAt: String? 
	var merchantUpdatedAt: String? 
	var merchantFromTime: String? 
	var merchantToTime: String? 
	var merchantQuickbooksAccessToken: String? 
	var merchantQuickbooksAccessTokenDatetime: Any? 
	var merchantQuickbooksRefreshToken: String? 
	var merchantQuickbooksRefreshTokenDatetime: Any? 
	var merchantQuickbooksCompanyId: String? 
	var merchantNetworkRestrictionEnabled: String? 
	var merchantRestrictionsEnabled: String? 
	var merchantLiteEnabled: String? 
	var merchantProfileCompleted: String? 
	var merchantReferenceNumber: String? 
	var merchantWeeklyOvertimeEnabled: String? 
	var merchantWeeklyOvertime: NSNumber? 
	var merchantDailyOvertimeEnabled: String? 
	var merchantDailyOvertime: NSNumber? 
	var merchantEmpEarlyClockInNotiEnabled: String? 
	var merchantEmpEarlyClockInAllowance: NSNumber? 
	var merchantEmpEarlyClockOutNotiEnabled: String? 
	var merchantEmpEarlyClockOutAllowance: NSNumber? 
	var merchantEmpLateClockInNotiEnabled: String? 
	var merchantEmpLateClockInAllowance: NSNumber? 
	var merchantEmpLateClockOutNotiEnabled: String? 
	var merchantEmpLateClockOutAllowance: NSNumber? 
	var merchantEmpPostClockInNotiEnabled: String? 
	var merchantEmpPostClockOutNotiEnabled: String? 
	var merchantEmpMissedClockOutNotiEnabled: String? 
	var merchantEmpOvertimeNotiEnabled: String? 
	var merchantMgEarlyClockInNotiEnabled: String? 
	var merchantMgEarlyClockInAllowance: NSNumber? 
	var merchantMgEarlyClockOutNotiEnabled: String? 
	var merchantMgEarlyClockOutAllowance: NSNumber? 
	var merchantMgLateClockInNotiEnabled: String? 
	var merchantMgLateClockInAllowance: NSNumber? 
	var merchantMgLateClockOutNotiEnabled: String? 
	var merchantMgLateClockOutAllowance: NSNumber? 
	var merchantMgPostClockInNotiEnabled: String? 
	var merchantMgPostClockOutNotiEnabled: String? 
	var merchantMgMissedClockOutNotiEnabled: String? 
	var merchantMgOvertimeNotiEnabled: String? 
	var merchantTimeRequestNotiEnabled: String? 
	var merchantPtoRequestNotiEnabled: String? 
	var merchantVacationRequestNotiEnabled: String? 
	var merchantTimesheetReminderEnabled: String? 
	var merchantTimesheetReminderText: String? 
	var merchantTimesheetReminderDay: NSNumber? 
	var merchantTimesheetReminderTime: String? 
	var merchantTrash: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		merchantId <- map["merchant_id"] 
		merchantName <- map["merchant_name"] 
		merchantAppImage <- map["merchant_app_image"] 
		merchantImage <- map["merchant_image"] 
		merchantImageMime <- map["merchant_image_mime"] 
		merchantSubdomain <- map["merchant_subdomain"] 
		merchantPanelSubdomain <- map["merchant_panel_subdomain"] 
		merchantCompanySize <- map["merchant_company_size"] 
		merchantBusinessType <- map["merchant_business_type"] 
		merchantBusinessIndustry <- map["merchant_business_industry"] 
		merchantAddress <- map["merchant_address"] 
		merchantCity <- map["merchant_city"] 
		merchantState <- map["merchant_state"] 
		merchantZip <- map["merchant_zip"] 
		merchantPhone <- map["merchant_phone"] 
		merchantCountry <- map["merchant_country"] 
		merchantWeb <- map["merchant_web"] 
		merchantMaxHoursBreak <- map["merchant_max_hours_break"] 
		merchantPayPeriod <- map["merchant_pay_period"] 
		merchantWeekStart <- map["merchant_week_start"] 
		merchantCurrentPayWeek <- map["merchant_current_pay_week"] 
		merchantHighHours <- map["merchant_high_hours"] 
		merchantForceClockOutNotificationEnabled <- map["merchant_force_clock_out_notification_enabled"] 
		merchantLateShiftAllowance <- map["merchant_late_shift_allowance"] 
		merchantPanelLoginBg <- map["merchant_panel_login_bg"] 
		merchantFrontLoginBg <- map["merchant_front_login_bg"] 
		merchantFrontDashboardBg <- map["merchant_front_dashboard_bg"] 
		merchantFrontTimeclockBg <- map["merchant_front_timeclock_bg"] 
		merchantTimezone <- map["merchant_timezone"] 
		merchantCreatedAt <- map["merchant_created_at"] 
		merchantUpdatedAt <- map["merchant_updated_at"] 
		merchantFromTime <- map["merchant_from_time"] 
		merchantToTime <- map["merchant_to_time"] 
		merchantQuickbooksAccessToken <- map["merchant_quickbooks_access_token"] 
		merchantQuickbooksAccessTokenDatetime <- map["merchant_quickbooks_access_token_datetime"] 
		merchantQuickbooksRefreshToken <- map["merchant_quickbooks_refresh_token"] 
		merchantQuickbooksRefreshTokenDatetime <- map["merchant_quickbooks_refresh_token_datetime"] 
		merchantQuickbooksCompanyId <- map["merchant_quickbooks_company_id"] 
		merchantNetworkRestrictionEnabled <- map["merchant_network_restriction_enabled"] 
		merchantRestrictionsEnabled <- map["merchant_restrictions_enabled"] 
		merchantLiteEnabled <- map["merchant_lite_enabled"] 
		merchantProfileCompleted <- map["merchant_profile_completed"] 
		merchantReferenceNumber <- map["merchant_reference_number"] 
		merchantWeeklyOvertimeEnabled <- map["merchant_weekly_overtime_enabled"] 
		merchantWeeklyOvertime <- map["merchant_weekly_overtime"] 
		merchantDailyOvertimeEnabled <- map["merchant_daily_overtime_enabled"] 
		merchantDailyOvertime <- map["merchant_daily_overtime"] 
		merchantEmpEarlyClockInNotiEnabled <- map["merchant_emp_early_clock_in_noti_enabled"] 
		merchantEmpEarlyClockInAllowance <- map["merchant_emp_early_clock_in_allowance"] 
		merchantEmpEarlyClockOutNotiEnabled <- map["merchant_emp_early_clock_out_noti_enabled"] 
		merchantEmpEarlyClockOutAllowance <- map["merchant_emp_early_clock_out_allowance"] 
		merchantEmpLateClockInNotiEnabled <- map["merchant_emp_late_clock_in_noti_enabled"] 
		merchantEmpLateClockInAllowance <- map["merchant_emp_late_clock_in_allowance"] 
		merchantEmpLateClockOutNotiEnabled <- map["merchant_emp_late_clock_out_noti_enabled"] 
		merchantEmpLateClockOutAllowance <- map["merchant_emp_late_clock_out_allowance"] 
		merchantEmpPostClockInNotiEnabled <- map["merchant_emp_post_clock_in_noti_enabled"] 
		merchantEmpPostClockOutNotiEnabled <- map["merchant_emp_post_clock_out_noti_enabled"] 
		merchantEmpMissedClockOutNotiEnabled <- map["merchant_emp_missed_clock_out_noti_enabled"] 
		merchantEmpOvertimeNotiEnabled <- map["merchant_emp_overtime_noti_enabled"] 
		merchantMgEarlyClockInNotiEnabled <- map["merchant_mg_early_clock_in_noti_enabled"] 
		merchantMgEarlyClockInAllowance <- map["merchant_mg_early_clock_in_allowance"] 
		merchantMgEarlyClockOutNotiEnabled <- map["merchant_mg_early_clock_out_noti_enabled"] 
		merchantMgEarlyClockOutAllowance <- map["merchant_mg_early_clock_out_allowance"] 
		merchantMgLateClockInNotiEnabled <- map["merchant_mg_late_clock_in_noti_enabled"] 
		merchantMgLateClockInAllowance <- map["merchant_mg_late_clock_in_allowance"] 
		merchantMgLateClockOutNotiEnabled <- map["merchant_mg_late_clock_out_noti_enabled"] 
		merchantMgLateClockOutAllowance <- map["merchant_mg_late_clock_out_allowance"] 
		merchantMgPostClockInNotiEnabled <- map["merchant_mg_post_clock_in_noti_enabled"] 
		merchantMgPostClockOutNotiEnabled <- map["merchant_mg_post_clock_out_noti_enabled"] 
		merchantMgMissedClockOutNotiEnabled <- map["merchant_mg_missed_clock_out_noti_enabled"] 
		merchantMgOvertimeNotiEnabled <- map["merchant_mg_overtime_noti_enabled"] 
		merchantTimeRequestNotiEnabled <- map["merchant_time_request_noti_enabled"] 
		merchantPtoRequestNotiEnabled <- map["merchant_pto_request_noti_enabled"] 
		merchantVacationRequestNotiEnabled <- map["merchant_vacation_request_noti_enabled"] 
		merchantTimesheetReminderEnabled <- map["merchant_timesheet_reminder_enabled"] 
		merchantTimesheetReminderText <- map["merchant_timesheet_reminder_text"] 
		merchantTimesheetReminderDay <- map["merchant_timesheet_reminder_day"] 
		merchantTimesheetReminderTime <- map["merchant_timesheet_reminder_time"] 
		merchantTrash <- map["merchant_trash"] 
	}
} 

class Payperiods: Mappable { 

	var payperiodId: NSNumber? 
	var payperiodStatus: String? 
	var payperiodFrom: String? 
	var payperiodTo: String? 
	var payperiodFrom1: String? 
	var payperiodTo1: String? 
	var weeks: [Weeks]? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		payperiodId <- map["payperiod_id"] 
		payperiodStatus <- map["payperiod_status"] 
		payperiodFrom <- map["payperiod_from"] 
		payperiodTo <- map["payperiod_to"] 
		payperiodFrom1 <- map["payperiod_from1"] 
		payperiodTo1 <- map["payperiod_to1"] 
		weeks <- map["weeks"] 
	}
} 

class Weeks: Mappable { 

	var weekFrom: String? 
	var weekTo: String? 
	var timesheet: [Timesheet]? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		weekFrom <- map["week_from"] 
		weekTo <- map["week_to"] 
		timesheet <- map["timesheet"] 
	}
} 

class Timesheet:NSObject,Codable, Mappable {

    var date: String?
    var events: [Events]?

    override init() {
        super.init()
    }

    convenience required init?(_ map: Map) {
        self.init()
    }
    required init?(map: Map){
    }

    func mapping(map: Map) {
        date <- map["date"]
        events <- map["events"]
    }
    
    
    func addEventsForDay(date:CustomDate)->Timesheet{
        let timesheet = Timesheet()
        timesheet.date = date.datestring ?? ""
        var events = [Events]()
        events.append(Events().addStartShift(date: date.datestring ?? ""))
        events.append(Events().addEndShift(date: date.datestring ?? ""))
        events.append(Events().addStartBreak(date: date.datestring ?? ""))
        events.append(Events().addEndBreak(date: date.datestring ?? ""))
        timesheet.events = events
        return timesheet
    }
    
    func addShiftForDay(){
        self.events?.append(Events().addStartShift(date: self.date ?? ""))
        self.events?.append(Events().addEndShift(date: self.date ?? ""))
    }
    func addBreaksForDay(){
        self.events?.append(Events().addStartBreak(date: self.date ?? ""))
        self.events?.append(Events().addEndBreak(date: self.date ?? ""))
    }
}
struct EventType{
    static let shiftStart = "Start Shift"
    static let shiftEnd = "End Shift"
    static let breakStart = "Start Lunch"
    static let breakEnd = "End Lunch"
}
class Events:NSObject,Codable, Mappable {

    var timelineId: Int?
    var timelineEvent: String?
    var timelineDate: String?
    var timelineTime: String?
    var timelineValue: String?

    override init() {
        super.init()
    }

    convenience required init?(_ map: Map) {
        self.init()
    }
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        timelineId <- map["timeline_id"]
        timelineEvent <- map["timeline_event"]
        timelineDate <- map["timeline_date"]
        timelineTime <- map["timeline_time"]
        timelineValue <- map["timeline_value"]
    }
    
    func addStartShift(date:String)->Events{
        let event = Events()
        event.timelineId = -1
        event.timelineEvent = UserStatus.loggedIN.rawValue
        event.timelineDate = date
        event.timelineTime = ""
        event.timelineValue = ""
        return event
    }
    func addEndShift(date:String)->Events{
        let event = Events()
        event.timelineId = -1
        event.timelineEvent = UserStatus.loggedOut.rawValue
        event.timelineDate = date
        event.timelineTime = ""
        event.timelineValue = ""
        return event
    }
    func addStartBreak(date:String)->Events{
        let event = Events()
        event.timelineId = -1
        event.timelineEvent = UserStatus.Inbreak.rawValue
        event.timelineDate = date
        event.timelineTime = ""
        event.timelineValue = ""
        return event
    }
    func addEndBreak(date:String)->Events{
        let event = Events()
        event.timelineId = -1
        event.timelineEvent = UserStatus.Endbreak.rawValue
        event.timelineDate = date
        event.timelineTime = ""
        event.timelineValue = ""
        return event
    }
    
}
