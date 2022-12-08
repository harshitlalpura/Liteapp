//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 04/02/21

import Foundation
import UIKit

import SafariServices
import  AVKit
import AVFoundation

/// Utility class for application
public class Utility {
    
    // MARK: - singleton sharedInstance
    static var sharedInstance = Utility()
    static let synth = AVSpeechSynthesizer()
    var referralCode:String?
    /// App's name (if applicable).
    public static func TextToSpeech(string:String) {
        
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-us")
        utterance.rate = 0.5
        utterance.volume = .greatestFiniteMagnitude
       // let synthesizer = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    func logout(){
        Defaults.clear()
      //  CurrentUserCache.remove()
        Utility.sharedInstance.stopRemoteNotificatio()
        Utility.setRootScreen(isShowAnimation: true)
    }
    func stopRemoteNotificatio(){
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    func startRemoteNotificatio(){
        //AppDelegate.sharedInstance.RegisterFCM(UIApplication.shared)
    }
    var notificationData:NSDictionary!
   // var tempRefresh:Bool = false
    /// App's name (if applicable).
    public static var appDisplayName: String? {
        // http://stackoverflow.com/questions/28254377/get-app-name-in-swift
        return MAIN_BUNDLE.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    
    /// This will return a App Vendor UUID
    public static var appVendorUUID: String {
        return CURRENT_DEVICE.identifierForVendor!.uuidString
    }
    
    /// App's bundle ID (if applicable).
    public static var appBundleID: String? {
        return MAIN_BUNDLE.bundleIdentifier
    }

    /// App current build number (if applicable).
    public static var appBuild: String? {
        return MAIN_BUNDLE.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    static var timestamp: String {
        return "\(Int(Date().timeIntervalSince1970 * 1000))"
    }

    static var headerTimeStamp: String {
        return "\(Int(Date().timeIntervalSince1970))"
    }
    
    /// Application icon badge current number.
    public static var applicationIconBadgeNumber: Int {
        get {
            return APPLICATION.applicationIconBadgeNumber
        }
        set {
            APPLICATION.applicationIconBadgeNumber = newValue
        }
    }
    
    /// App's current version (if applicable).
    public static var appVersion: String? {
        return MAIN_BUNDLE.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    /// Check if app is running in debug mode.
    public static var isInDebuggingMode: Bool {
        // http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    /// Check if multitasking is supported in current device.
    public static var isMultitaskingSupported: Bool {
        return CURRENT_DEVICE.isMultitaskingSupported
    }
    
    /// Check if device is registered for remote notifications for current app (read-only).
    public static var isRegisteredForRemoteNotifications: Bool {
        return APPLICATION.isRegisteredForRemoteNotifications
    }
    
    /// This method will return a Top Most View Controller of the application's window which you wan use.
    ///
    /// - Returns: Object of the UIViewController
    public func topMostController() -> UIViewController {
        let arrWind = APPLICATION.windows
        if arrWind.count > 0 {
            if let keyWndw = APPLICATION.windows.filter({$0.isKeyWindow}).first {
                var topController: UIViewController = keyWndw.rootViewController!
                while topController.presentedViewController != nil {
                    topController = topController.presentedViewController!
                }
                return topController
            }
        }
        return UIViewController()
    }

    /// Check if application is running on simulator (read-only).
    public static var isRunningOnSimulator: Bool {
        // http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    ///  Most top view controller (if applicable).
    public static var mostTopViewController: UIViewController? {
        get {
            return KEY_WINDOW?.rootViewController
        }
        set {
            KEY_WINDOW?.rootViewController = newValue
        }
    }
    
    /// This method will return a Top Most View Controller (currectly visible) of the application's window which you can use.
    ///
    /// - Returns: Object of the UIViewController
    public func topMostController() -> UIViewController? {
        
        //        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        //        while (topController.presentedViewController != nil) {
        //            topController = topController.presentedViewController!
        //        }
        //        return topController
        
        var from = KEY_WINDOW?.rootViewController
        while from != nil {
            if let to = (from as? UITabBarController)?.selectedViewController {
                from = to
            } else if let to = (from as? UINavigationController)?.visibleViewController {
                from = to
            } else if let to = from?.presentedViewController {
                from = to
            } else {
                break
            }
        }
        return from
        
    }
    
    /// Class name of object as string.
    ///
    /// - Parameter object: Any object to find its class name.
    /// - Returns: Class name for given object.
    static func typeName(for object: Any) -> String {
        let objectType = type(of: object.self)
        return String.init(describing: objectType)
    }

    /// This method will set root menu video controller
    ///
    /// - Parameters:
    ///   - isFromNotification: set coming from notification
    static func playSplash(completionHandler:@escaping CompletionHandler){
        let width = Constant.SCREEN_WIDTH * 0.65
        let revealingSplashView = SplashView(logoImage: UIImage(named: AppConstants.Image.AppLogo)!, backgroundImage: UIImage(named: AppConstants.Image.bg)!, iconInitialSize:  CGSize(width: width, height: width))
        revealingSplashView.duration = 4.0
        ROOT_FIRST_VC?.rootViewController?.view.addSubview(revealingSplashView)
        revealingSplashView.startAnimattion(completionHandler: {success in
            completionHandler(success)
        })
    }
    static func setRootScreen(isFromNoti: Bool = false, isShowAnimation: Bool = true ,isOnBoarding:Bool = false) {
        
           
        
          //  var controller =  LoginViewController.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
         
          //  let controller =  Defaults.shared.currentUser != nil ?  DashBoardVC.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.timesheet.rawValue)!) :  LoginViewController.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
        
            let controller =  LoginViewController.instantiate(fromStoryboard: StoryboardName(rawValue: StoryboardName.main.rawValue)!)
        
     
            let navigationController = BaseNavigationController(rootViewController: controller)
            navigationController.navigationBar.isHidden = true
            
            if isShowAnimation {
                UIView.transition(with: ROOT_FIRST_VC!,
                                  duration: 0.5, options: .transitionFlipFromLeft,
                                  animations: {
                                    ROOT_FIRST_VC?.rootViewController = navigationController
                                    ROOT_FIRST_VC?.makeKeyAndVisible()

                                  }, completion: { _ in

                                  })
            } else {
                ROOT_FIRST_VC?.rootViewController = navigationController
               // self.playSplash { (success) in}
            
                ROOT_FIRST_VC?.makeKeyAndVisible()

            }
        
    }
    
    static func delay(_ delay: Double, closure:@escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func openWhatsapp(phonenumber:String){
        let urlWhats = "whatsapp://send?phone=\(phonenumber)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    /// Setup Collection with 2 collum
    /// - Parameters:
    ///   - collection: UIcollectionview
    ///   - cellHeight: Collection cell height
    static func setupCollectionUi(collection: UICollectionView, cellHeight: CGFloat,numberOfColumn:Int = 1,scrollDirection:Int = UICollectionView.ScrollDirection.vertical.rawValue,minimumLineSpacing:CGFloat = 0.0) {
        let fllowLayout = UICollectionViewFlowLayout()
        fllowLayout.itemSize = CGSize(width: collection.frame.width/CGFloat(numberOfColumn), height: cellHeight)
        print("table width is \(collection.frame.width)")
        print("cell width is \(collection.frame.width/CGFloat(numberOfColumn))")
        print("number of cell is \(numberOfColumn)")
        fllowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        fllowLayout.scrollDirection = UICollectionView.ScrollDirection(rawValue: scrollDirection)!
        fllowLayout.minimumInteritemSpacing = 0.0
        fllowLayout.minimumLineSpacing = Device.current.isPad ? minimumLineSpacing : 0.0
        collection.collectionViewLayout = fllowLayout

    }
    
    static func setupCollectionHorizontalUi(collection: UICollectionView, cellHeight: CGFloat,numberofColumn:Double = 2.0,scrollDirection:Int = UICollectionView.ScrollDirection.horizontal.rawValue) {
        let fllowLayout = UICollectionViewFlowLayout()
        fllowLayout.itemSize = CGSize(width: (Constant.DEVICE_SCREEN_WIDTH/numberofColumn)-24, height: cellHeight)
        fllowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        fllowLayout.scrollDirection = UICollectionView.ScrollDirection(rawValue: scrollDirection)!
        fllowLayout.minimumInteritemSpacing = 0.0
        collection.collectionViewLayout = fllowLayout
    }
    
    /// Setup Collection with 2 collum
    /// - Parameters:
    ///   - collection: UIcollectionview
    ///   - cellHeight: Collection cell height
    static func setupVerticalCollectionUi(collection: UICollectionView) {
        let fllowLayout = UICollectionViewFlowLayout()
        fllowLayout.itemSize = CGSize(width: 65, height: 65)
        fllowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        fllowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        fllowLayout.minimumInteritemSpacing = 0.0
        collection.collectionViewLayout = fllowLayout

    }
    
    /// Setup Collection with 3 row
    /// - Parameters:
    ///   - collection: UIcollectionview
    ///   - cellHeight: Collection cell height
    static func setupCategoryCollectionUi(collection: UICollectionView, cellHeight: CGFloat) {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (collection.size.width ) / 3, height: cellHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        collection.collectionViewLayout = layout
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false

    }
    static func rateApp() {
       // itms-
        let appid = ""
        guard let url = URL(string: "https://apps://itunes.apple.com/app/" + "\(appid)") else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    static func yearsBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current

        let components = calendar.dateComponents([.year], from: startDate, to: endDate)

        return (components.year ?? 0) + 1 
    }

    /// open url link with safari controller
    /// - Parameter link: link in string
    func openLinkWithSafariController(link: String) {
        guard let url = URL(string: link) else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true

        let vc = SFSafariViewController(url: url, configuration: config)
        Utility.sharedInstance.topMostController().present(vc, animated: true)
    }
    
    /// for set tint color on button from image back groud
    /// - Parameters:
    ///   - fromImage: set imageview from need to get color
    ///   - FromLocation: set location button when pick up point
    ///   - targetButton: set target button where need to apply
    func setTintColorFromImage(fromImage: UIImageView, FromLocation: UIButton, targetButton: UIButton)  {
        if let imageColorAtPixelPoint = fromImage.image?.pixelColor(atLocation: FromLocation.frame.origin) {
            targetButton.tintColor = imageColorAtPixelPoint.isLight() ? UIColor.Color.white : UIColor.Color.blue
        }
    }

    /// Convert any to json form
    /// - Parameter object: object description
    /// - Returns: String
    func json(from object: Any) -> String? {
        let jsonData = try? JSONSerialization.data(withJSONObject: object, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)!
        return jsonString
    }

    func getThumbnail(urlPath: String, isWebPath: Bool = false, block:@escaping (UIImage?)->()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let asset: AVAsset!
            if isWebPath {
                asset = AVAsset(url: URL(string: urlPath)!)

            } else {
                asset = AVAsset(url: URL(fileURLWithPath: urlPath))
            }

            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            assetImgGenerate.maximumSize = CGSize(width: 1160, height: 1160)
            assetImgGenerate.requestedTimeToleranceAfter = CMTime.zero
            assetImgGenerate.requestedTimeToleranceBefore = CMTime.zero

            let time = CMTimeMakeWithSeconds(Float64(1), preferredTimescale: 100)
            assetImgGenerate.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)], completionHandler: { (requestedTime, thumbnail, actualTime, result, error) in
                if error == nil {
                    let frameImg  = UIImage(cgImage: thumbnail!)
                    block(frameImg)
                }
            })
        }
    }

   
    
    class func showWebController(strURL: String?) {
        var aStrURL = ""
        if let strURL = strURL, (strURL.isHttpUrl || strURL.isHttpsUrl) {
            aStrURL = strURL
        } else {
            aStrURL = "http://" + (strURL ?? "")
        }
        if let url = URL(string: aStrURL) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            Utility().topMostController().present(vc, animated: true)
        }
    }
    
    func snapImages()->[String]{
        var names = [String]()
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        let assetURL = bundleURL.appendingPathComponent("SnapImages.bundle")

        do {
          let contents = try fileManager.contentsOfDirectory(at: assetURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: .skipsHiddenFiles)

          for item in contents
          {
            names.append(item.lastPathComponent)
          }
            return names
        }
        catch let error as NSError {
          print(error)
        return names
        }
       
    }

    
    /// Set Suffix Number For Amont
    /// - Parameter number: Pass Amount
    /// - Returns: Retrrn in strinn e.g 1k
    static func suffixNumber(number:Double) -> String {
        
        var num = number
        let sign = ((num < 0) ? "-" : "" )
        
        num = fabs(num)
        
        if (num < 1000.0){
            return "\(sign)\(Int(num))"
        }
        
        let exp:Int = Int(log10(num) / 3.0 )
        
        let units:[String] = ["K","M","B","T","P","E"] // "G"
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10
        
        return "\(sign)\(Int(roundedNum))\(units[exp-1])"
    }
    
    static func getMenuWidth() -> CGFloat{
        let appScreenRect = UIApplication.shared.keyWindow?.bounds ?? UIWindow().bounds
        let minimumSize = min(appScreenRect.width, appScreenRect.height)
        let wid = minimumSize * 0.75
        return wid
    }
    
    static func getNameInitials() -> String{
        if let firstName = Defaults.shared.currentUser?.empFirstname, let lastname = Defaults.shared.currentUser?.empLastname{
            let firstNameInitialsIndex = firstName.index(firstName.startIndex, offsetBy: 0)
            let firstNameInitials = firstName[firstNameInitialsIndex]
            let lastNameInitialsIndex = lastname.index(lastname.startIndex, offsetBy: 0)
            let lastNameInitials = lastname[lastNameInitialsIndex]
            return firstNameInitials.uppercased() + lastNameInitials.uppercased()
        }
        return ""
    }
    static func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

