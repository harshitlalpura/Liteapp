//
//  Constant.swift
//  Bryte
//
//  Copyright © Bryte All rights reserved.
//  Created on 02/02/2021
//

import Foundation
import UIKit
import KeychainAccess
import Reachability
#if DEBUG
//    func debugPrint(items: Any..., separator: String = " ", terminator: String = "\n") {}
//    func print(items: Any..., separator: String = " ", terminator: String = "\n") {}
//    func print() {}
//    func print(_: Any) {}
#elseif STAGING
    func debugPrint(items: Any..., separator: String = " ", terminator: String = "\n") {}
    func print(items: Any..., separator: String = " ", terminator: String = "\n") {}
    func print() {}
    func print(_: Any) {}
#else
    func debugPrint(items: Any..., separator: String = " ", terminator: String = "\n") {}
    func print(items: Any..., separator: String = " ", terminator: String = "\n") {}
    func print() {}
    func print(_: Any) {}
#endif

#if DEBUG
// APPSTORE version
let keychain = Keychain(service: "com.Bryte.keychain.development")

#elseif STAGING
// Bryte ENTERPRISE version
let keychain = Keychain(service: "com.Bryte.keychain.staging")

#elseif RELEASE
// Bryte ENTERPRISE DEMO version
let keychain = Keychain(service: "com.Bryte.keychain")

#else
// Bryte DEVELOPMENT version
let keychain = Keychain(service: "com.Bryte.keychain.development")

#endif

/// General object of Application Delegate
let APP_DELEGATE: AppDelegate                   =   UIApplication.shared.delegate as! AppDelegate

///get the first root viewcontroller
var ROOT_FIRST_VC                               =  UIApplication.shared.windows.first

/// General object of Main Bundle
let MAIN_BUNDLE                                 =   Bundle.main

/// General object of Main Screen
let MAIN_SCREEN                                 =   UIScreen.main

/// General object of UIApplication
let APPLICATION                                 =   UIApplication.shared

/// General object of Current Device
let CURRENT_DEVICE                              =   UIDevice.current

/// General object of NotificationCenter
let NOTIFICATION_CENTER                         =   NotificationCenter.default

///get the keywindow
let KEY_WINDOW                                  =  UIApplication.shared.windows.filter {$0.isKeyWindow}.first

/// General object of UserDefaults
let USER_DEFAULTS                               =   UserDefaults.standard

/// General object for the Reachability
let reachability                                = try! Reachability()

/// General object ofthe Device Helper
let device = Device.current

class Constant {
    
    //--------------------------------------------------------------------------
    // MARK: Default Values
    //--------------------------------------------------------------------------
    
    static let SCREEN_WIDTH:CGFloat =  375
    static let SCREEN_HEIGHT:CGFloat =  812
    static let DEVICE_SCREEN_WIDTH =  MAIN_SCREEN.bounds.width
    static let DEVICE_SCREEN_HEIGHT =  MAIN_SCREEN.bounds.height
    static let RIGHTMENU_SPACE :CGFloat =    60
    static let MYPAGE_CELLLHEIGHT :CGFloat =    150
    static let MYPAGE_CELLLHEIGHT_iPAD :CGFloat =    200
    static let DOCUMENT_CELLHEIGHT :CGFloat =    172
    static let BOTTOMSHEET_RADIUS :CGFloat =    12
    static let SUBCATEGORY_CELLLHEIGHT :CGFloat =    130
    static let COMPNYMAX_LENGHT :Int =    20
    static let COMPNYMIN_LENGHT :Int =    2

    struct CMSLink {
        static let termsAndCondtition = "https://www.google.com/"
    }
}

struct StaticString {
    static let tableViewContentHeight = "TableViewContentHeight"
    static let scrollDeciderForParralaxTopTabbar = "scrollDeciderForParralaxTopTabbar"
    static var AppName = "G'tFunded".localized
    static let dummyInfo = "Under the federal securities laws, any offer or sale of a security must either be registered with the SEC or meet an exemption. Regulation D under the Securities Act provides a number of exemptions from the registration requirements, allowing some companies to offer and sell their securities without having to register the offering Under the federal securities laws, any offer or sale of a security must either be registered with the SEC or meet an exemption. Regulation D under the Securities Act provides a number of exemptions from the registration requirements, allowing some companies to offer and sell their securities without having to register the offering"
    static let dummyPackageData = "UI design and content analysis, this can include copy writing and the design of site navigation and user experience. Technical setup and installation of content manage"
    static let dummyPortfolioData = "Custom website design and development for a city tours ticketing company. Custom ecommerce functionality for ticket sales and reservations. Custom animated illustrations Custom website design and development for a city tours ticketing company. Custom ecommerce functionality for ticket sales and reservations. Custom animated illustrations Custom website design and development for a city tours ticketing company. Custom ecommerce functionality for ticket sales and reservations. Custom animated illustrations Custom website design and development for a city tours ticketing company. Custom ecommerce functionality for ticket sales and reservations. Custom animated illustrations "
    static let dummyWorkHistoryData = "We need a developer to help in the selection of a template and the development of our new website. Content is ready. We know what we want the"
}

struct PlaceHolderImages {
    static let feedPlaceHolder = UIImage(named: "pl_feed")
    static let userPlaceHolder = UIImage(named: "pl_profile_avtar")
    static let businessExpPlaceHolder = UIImage(named: "pl_business_exp")
    static let educationPlaceHolder = UIImage(named: "pl_education")
    static let liecenceAndCertificatePlaceHolder = UIImage(named: "pl_liecence_certificate")
    static let noDataFound = UIImage(named: "pl_no_data_found")
    static let noInternetConnection = UIImage(named: "pl_no_internet_connection")
    static let noDataFoundSmall = UIImage(named: "No data-pana_small.pdf")
    static let feedPause = UIImage(named: "feed_pause")
    static let feedPlay = UIImage(named: "feed_play")

}
extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
