//
//  APIEndPoints.swift
//

import Foundation


class APIEndPoints {
    
    static func login() -> String {
        return APIConstants.baseURL + "login"
    }
    static func saveMerchants() -> String {
        return APIConstants.baseURL + "merchants/save"
    }
    static func setupMerchants() -> String {
        return APIConstants.baseURL + "merchants/setupMerchant"
    }
    static func saveEmployees() -> String {
        return APIConstants.baseURL + "employees/save"
    }
    static func saveEmployeesByManager() -> String {
        return APIConstants.baseURL + "employees/saveByMan"
    }
    static func checkUsername() -> String {
        return APIConstants.baseURL + "checkUsername"
    }
    static func checkEmail() -> String {
        return APIConstants.baseURL + "checkEmail"
    }
    static func searchMerchantsByRef() -> String {
        return APIConstants.baseURL + "merchants/searchByRef"
    }
    static func fetchSettings() -> String {
        return APIConstants.baseURL + "merchants/fetchSettings"
    }
    static func saveSettings() -> String {
        return APIConstants.baseURL + "merchants/saveSettings"
    }
    static func fetchAllPayPeriods() -> String {
        return APIConstants.baseURL + "timesheets/fetchAllPayPeriods"
    }
    static func fetchAllemployees() -> String {
        return APIConstants.baseURL + "employees/fetchAll"
    }
    static func fetchEmployees() -> String {
        return APIConstants.baseURL + "employees/fetch"
    }
    static func timeReport() -> String {
        return APIConstants.baseURL + "timeReport"
    }
    static func updateEmployees() -> String {
        return APIConstants.baseURL + "employees/update"
    }
    static func deleteEmployees() -> String {
        return APIConstants.baseURL + "employees/delete"
    }
    static func dashboard() -> String {
        return APIConstants.baseURL + "dashboard"
    }
    static func createEvent() -> String {
        return APIConstants.baseURL + "createEvent"
    }
    static func changePassword() -> String {
        return APIConstants.baseURL + "changePassword"
    }
    static func changeStatus() -> String {
        return APIConstants.baseURL + "timesheets/changeStatus"
    }
    static func fetchTimesheetsById() -> String {
        return APIConstants.baseURL + "timesheets/fetchById"
    }
    static func timelineByDate() -> String {
        return APIConstants.baseURL + "timelineByDate"
    }
    static func forgotPassword() -> String {
        return APIConstants.baseURL + "forgotPassword"
    }
    static func resetPassword() -> String {
        return APIConstants.baseURL + "resetPassword"
    }
    static func privacyPolicy() -> String {
        return APIConstants.baseURL + "privacyPolicy"
    }
    static func termsOfService() -> String {
        return APIConstants.baseURL + "termsOfService"
    }
    
    
}
