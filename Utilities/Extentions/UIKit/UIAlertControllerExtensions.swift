//
//  UIAlertControllerExtensions.swift
//  StructureApp
// 
//  Created By: Bryte
//  Created on: 11/11/17 11:00 AM - (Bryte)
//  
//  Copyright © 2017 Bryte. All rights reserved.
//  
//  

import Foundation
import UIKit

extension UIAlertController {
    
    /// Use this method to display an **Alert** or an **ActionSheet** on any viewController.
    ///
    /// - Parameters:
    ///   - controller: Object of controller on which you need to an display Alert/Actionsheet.
    ///   - title: String Title which you want to display.
    ///   - message: String Message which you want to display.
    ///   - style: .alert || .actionshhet
    ///   - cancelButton: String Title for Cancel Button type which you want to display.
    ///   - distrutiveButton: String Title for Distrutive Button type which you want to display.
    ///   - otherButtons: String Array of Other Button type which you want to display.
    ///   - completion: You will get the call back here when user tap on the button from the alert.
    ///
    ///     - Other Button Index will always be the first priority which will start from - **0...**
    ///     - If Cancel And Destructive both the buttons will be there then index of Destructive button is **0**(2nd Last) and Cancel Button index is **1** (Last).
    ///     - If Cancel, Destructive and Other Buttons will be there then index of Destructive button is **(2nd Last)** and Cancel Button index is **(Last)**. and Other Buttons index will start from **0**
    ///
    class func showAlert(controller: AnyObject ,
                         title: String? = nil,
                         message: String? = nil,
                         style: UIAlertController.Style = .alert ,
                         cancelButton: String? = nil ,
                         distrutiveButton: String? = nil ,
                         otherButtons: [String]? = nil,
                         completion: ((Int, String) -> Void)?) {
        
        // Set Title to the Local Variable
//        let strTitle = ""
        
        // Set Message to the Local Variable
//        let strMessage = message!
        
        // Create an object of Alert Controller
        let alert = UIAlertController.init(title: title?.localized, message: message?.localized, preferredStyle: style)
        
        // Set Attributed title for Alert with custom Font and Color
        //        let titleAttribute: [String: Any] = [NSFontAttributeName: UIFont.MuliBold(size: 16.0), NSForegroundColorAttributeName: UIColor.orangeDark]
        //        let titleString = NSMutableAttributedString(string: strTitle, attributes: titleAttribute)
        //        alert.setValue(titleString, forKey: "attributedTitle") // attributedMessage // attributedTitle
        
        // Set Attributed message for Alert with custom Font and Color
        //        let messageAttribute: [String: Any] = [NSFontAttributeName: UIFont.MuliRegular(size: 14.0), NSForegroundColorAttributeName: UIColor.graySubTitle]
        //        let messageString = NSMutableAttributedString(string: strMessage, attributes: messageAttribute)
        //        alert.setValue(messageString, forKey: "attributedMessage") // attributedMessage // attributedTitle
        
        // Set Distrutive button if it is not nil
        if let strDistrutiveBtn = distrutiveButton {
            
            let aStrDistrutiveBtn = strDistrutiveBtn.localized
            
            alert.addAction(UIAlertAction.init(title: aStrDistrutiveBtn, style: .destructive, handler: { _ in
                
                completion?(otherButtons != nil ? otherButtons!.count: 0, strDistrutiveBtn)
                
            }))
            
        }
        
        // Set Cancel button if it is not nil
        if let strCancelBtn = cancelButton {
            
            let aStrCancelBtn = strCancelBtn.localized
            
            alert.addAction(UIAlertAction.init(title: aStrCancelBtn, style: .cancel, handler: { _ in
                
                // Pass action to the completion block
                if  distrutiveButton != nil {
                    // If Distrutive button was added to the alert then pass the index 2nd last
                    completion?(otherButtons != nil ? otherButtons!.count + 1: 1, strCancelBtn)
                } else {
                    // Pass the last index to the completion block
                    completion?(otherButtons != nil ? otherButtons!.count: 0, strCancelBtn)
                }
                
            }))
            
        }
        
        // Set Other Buttons if it is not nil
        if let arr = otherButtons {
            
            // Loop through all the array and add the individual action to the alert
            for (index, value) in arr.enumerated() {
                
                let aValue = value.localized
                
                alert.addAction(UIAlertAction.init(title: aValue, style: .default, handler: { _ in
                    
                    // Pass the index and the string value to the completion block which will use to perform further action
                    completion?(index, value)
                    
                }))
                
            }
        }
        
        // Change the Color of the button title
        //        alert.view.tintColor = UIColor.orangeDark
        
        // Display an alert on on the controller
        controller.present(alert, animated: true, completion: nil)
        
    }
    
    /// Use this method to display an **Alert** with **Ok** Button on any viewController.
    ///
    /// - Parameters:
    ///   - controller: Object of controller on which you need to display an Alert
    ///   - message: String Message which you want to display.
    ///   - completion: You will get the call back here when user tap on the button from the alert. Index will always be 0
    ///
    class func showAlertWithOkButton(controller: AnyObject ,
                                     message: String? = nil ,
                                     completion: ((Int, String) -> Void)?) {
        
        showAlert(controller: controller, message: message, style: .alert, cancelButton: nil, distrutiveButton: nil, otherButtons: ["Ok"], completion: completion)
        
    }
    
    /// Use this method to display an **Alert** with **Cancel** Button on any viewController.
    ///
    /// - Parameters:
    ///   - controller: Object of controller on which you need to display an Alert
    ///   - message: String Message which you want to display.
    ///   - completion: You will get the call back here when user tap on the button from the alert. Index will always be 0
    class func showAlertWithCancelButton(controller: AnyObject ,
                                         message: String? = nil ,
                                         completion: ((Int, String) -> Void)?) {
        
        showAlert(controller: controller, message: message, style: .alert, cancelButton: "Cancel", distrutiveButton: nil, otherButtons: nil, completion: completion)
        
    }
    
    /// Use this method to display an **Alert** for Delete confirmation on any viewController.
    ///
    /// - Parameters:
    ///   - controller: Object of controller on which you need to display an Alert
    ///   - message: String Message which you want to display.
    ///   - completion: You will get the call back here when user tap on the button from the alert.
    ///
    ///     - If Cancel And Destructive both the buttons will be there then index of Destructive button is **0**(2nd Last) and Cancel Button index is **1** (Last).
    class func showDeleteAlert(controller: AnyObject ,
                               message: String? = nil ,
                               completion: ((Int, String) -> Void)?) {
        
        showAlert(controller: controller, message: message, style: .alert, cancelButton: "Cancel", distrutiveButton: "Delete", otherButtons: nil, completion: completion)
        
    }
    
    /// Use this method to display an **ActionSheet** for Image Picker confirmation on any viewController.
    ///
    /// - Parameters:
    ///   - controller: Object of controller on which you need to display an Alert
    ///   - message: String Message which you want to display.
    ///   - completion: You will get the call back here when user tap on the button from the alert.
    ///
    ///     - Index For "Use Gallery" button = 0
    ///     - Index For "Use Camera" button = 1
    ///     - Index For "Cancel" button = 2
    class func showActionsheetForImagePicker(controller: AnyObject ,
                                             message: String? = nil ,
                                             completion: ((Int, String) -> Void)?) {
        
        showAlert(controller: controller, message: message, style: .actionSheet, cancelButton: "Cancel", distrutiveButton: nil, otherButtons: ["Use Gallery", "Use Camera"], completion: completion)
        
    }
    
}

