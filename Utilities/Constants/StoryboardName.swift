//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 15/05/20

import Foundation
import UIKit


enum StoryboardName: String {
    case onBording = "OnBording"
    case home = "Home"
    case homeiPad = "HomeiPad"
    case signin = "Signin"
    case main = "Main"
    case mainiPad = "MainiPad"
    case sideMenu = "SideMenu"
    case settings = "Settings"
    case timesheet = "Timesheet"
    case timesheetiPad = "TimesheetiPad"
    case merchant = "Merchant"
    case merchantipad = "MerchantiPad"
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: MAIN_BUNDLE)
    }

    @discardableResult
    func instantiate<T: UIViewController>(viewController: T.Type, function: String = #function, line: Int = #line, file: String = #file) -> T {
        let storyboardID = (viewController as UIViewController.Type).storyboardID

        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(rawValue) Storyboard.\nFile: \(file) \nLine Number: \(line) \nFunction: \(function)")
        }

        return scene
    }

    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
}

