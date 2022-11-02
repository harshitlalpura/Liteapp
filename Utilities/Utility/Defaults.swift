//
//  Defaults.swift
//  Vocabmeme
//
//  Created by Navroz Huda on 23/01/22.
//

import Foundation
import ObjectMapper
import Alamofire

class Defaults {
    
    static let shared = Defaults()
    let userDefaults = UserDefaults()
    
    
   
   
    var header: [String:String]?{
        get {
            return userDefaults.value(forKey: "header") as? [String : String]
        }
        set {
            userDefaults.setValue(newValue, forKey: "header")
            userDefaults.synchronize()
        }
    }
    
    var currentUser: EmpData? {
        get {
            if let loggedUser = userDefaults.object(forKey: "loggedUser") as? Data {
                let decoder = JSONDecoder()
                return try? decoder.decode(EmpData.self, from: loggedUser)
            }
            return nil
        }
        set {
            
            let encoder = JSONEncoder()
            self.header = ["Authorization":"Bearer \(newValue?.empToken ?? "")"]
            if let encoded = try? encoder.encode(newValue) {
                userDefaults.set(encoded, forKey: "loggedUser")
                userDefaults.synchronize()
            } else {
                userDefaults.set(nil, forKey: "loggedUser")
                userDefaults.synchronize()
            }
        }
    }
   /*
    var currentUser: [CurrentUser]? {
        get {
            if let calculatorConfig = userDefaults.object(forKey: "currentUser") as? Data {
                let decoder = JSONDecoder()
                return try? decoder.decode([CurrentUser].self, from: calculatorConfig)
            }
            return nil
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                userDefaults.set(encoded, forKey: "calculatorConfig")
                userDefaults.synchronize()
            } else {
                userDefaults.set(nil, forKey: "calculatorConfig")
                userDefaults.synchronize()
            }
        }
    }
    */
    static func clear() {
            guard let domain = Bundle.main.bundleIdentifier else { return }
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
        }
    
    var fcmToken = ""
    /*  var fcmToken: String {
        get {
            return userDefaults.string(forKey:"fcmToken") ?? ""
        }
        set {
            userDefaults.setValue(newValue, forKey: "fcmToken")
            userDefaults.synchronize()
        }
    } */
    
    var referralCode: String? {
       get {
           return userDefaults.string(forKey:"referralCode")
       }
       set {
           userDefaults.setValue(newValue, forKey: "referralCode")
           userDefaults.synchronize()
       }
    }
    
    var forgotPasswordEmpId: String? {
       get {
           return userDefaults.string(forKey:"forgotPasswordEmpId")
       }
       set {
           userDefaults.setValue(newValue, forKey: "forgotPasswordEmpId")
           userDefaults.synchronize()
       }
    }
    
    var hasPremium: Bool {
        get {
            return userDefaults.bool(forKey: "hasPremium")
        }
        set {
            userDefaults.setValue(newValue, forKey: "hasPremium")
            userDefaults.synchronize()
        }
    }
    
    var likeNotification: Bool {
        get {
            return userDefaults.bool(forKey: "likeNotification")
        }
        set {
            userDefaults.setValue(newValue, forKey: "likeNotification")
            userDefaults.synchronize()
        }
    }
    
    var commentNotification: Bool {
        get {
            return userDefaults.bool(forKey: "commentNotification")
        }
        set {
            userDefaults.setValue(newValue, forKey: "commentNotification")
            userDefaults.synchronize()
        }
    }
   
    var followerNotification: Bool {
        get {
            return userDefaults.bool(forKey: "followerNotification")
        }
        set {
            userDefaults.setValue(newValue, forKey: "followerNotification")
            userDefaults.synchronize()
        }
    }
    
    var postNotification: Bool {
        get {
            return userDefaults.bool(forKey: "postNotification")
        }
        set {
            userDefaults.setValue(newValue, forKey: "postNotification")
            userDefaults.synchronize()
        }
    }
}
extension UserDefaults {

    subscript<T>(key: String) -> T? {
        get {
            return value(forKey: key) as? T
        }
        set {
            set(newValue, forKey: key)
        }
    }

    subscript<T: RawRepresentable>(key: String) -> T? {
        get {
            if let rawValue = value(forKey: key) as? T.RawValue {
                return T(rawValue: rawValue)
            }
            return nil
        }
        set {
            set(newValue?.rawValue, forKey: key)
        }
    }
}
/*struct CurrentUserCache {
    static let key = "currentUser"
    static func save(_ value: CurrentUser!) {
        UserDefaults.standard.set(value.toJSON(), forKey: key)
    }
    static func get() -> CurrentUser? {
        var userData: CurrentUser!
        let data = UserDefaults.standard.value(forKey: key)
        userData = Mapper<CurrentUser>().map(JSONObject: data)
        return userData
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
} */
extension UIColor {
    // house blue
    @IBInspectable var houseBlue: UIColor { return UIColor(red:(51/255), green:(205/255), blue:(255/255), alpha:(1)) }

    // house gray
    @IBInspectable var houseGray: UIColor { return UIColor(white:0.4, alpha: 1) }

    // house white
    @IBInspectable var appWhite: UIColor { return UIColor.white }
    
   // #4b93d2
   // AppThemeBlue
    @IBInspectable var appThemeBlue: UIColor { return UIColor(hex:"4B93D2") }
    
    // #ffe45e
    // AppThemeYellow
    @IBInspectable var appThemeYellow: UIColor { return UIColor(hex:"FFE45E") }
    
   
    
    
}
