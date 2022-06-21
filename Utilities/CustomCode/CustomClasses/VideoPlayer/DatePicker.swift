//
//  DatePicker.swift

//  Created by DatePicker on 07/06/18.
//  Copyright © 2018 DatePicker. All rights reserved.
//

import UIKit

// Properties
//

typealias completionBlock = (_ strData: String , _ isDismiss: Bool) -> Void
var block: completionBlock!
var datePicker = UIDatePicker()
var parentVC = UIViewController()
// let kDateFormat = "dd-MM-yyyy"
let kMMddYYYYhhmmss = "yyyy-MM-dd HH:mm:ss"

//let kMMddYYYYhhmmss = "yyyy-MM-dd HH:mm:ssZ"
let kHHMMSS = "HH:mm:ss"
let kDateFormat = "MM-dd-YYYY"
let kTimeFormat = "h:mm"
let timeFormat = "hh:mm a"
let kDateGetFormat = "yyyy-MM-dd"
let kDateFormatDisplay = "YYYY-MM-dd hh:mm a"
let kHHmmss = "HH:mm:ss"
let MMddYYYY = "MM/dd/YYYY"
var futureDate = true
class DatePicker: NSObject {
    /// Call this function to present date picker on textfield
    class func pickDate(txtField: UITextField, VC: UIViewController, strMaxDate: String? = nil, datePickerMode: UIDatePicker.Mode, isfutureDateAllowed:Bool = true, completion: @escaping completionBlock) {
        parentVC = VC
        datePicker = UIDatePicker()
        txtField.tintColor = UIColor.clear
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.datePickerMode = datePickerMode
        if isfutureDateAllowed{
            datePicker.date = Date()
            datePicker.maximumDate = Date()
        }
        
       
        if strMaxDate != nil {
            let dateFormater = DateFormatter()
            if datePickerMode == .date {
                dateFormater.dateFormat = kDateGetFormat
            } else {
                dateFormater.dateFormat = timeFormat
            }
//
//            let maxDate = dateFormater.date(from: strMaxDate!)
//            datePicker.minimumDate = maxDate

        } else {
//            datePicker.minimumDate = Date()
        }

        datePicker.backgroundColor = UIColor.white

        if !(txtField.text?.isEmpty)! {
            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = kDateFormat
            if datePickerMode == .date{
                dateFormatter.dateFormat = kDateFormat
                if strMaxDate != nil {
                        datePicker.setDate(Date(), animated: false)
//                    if let date = dateFormatter.date(from: strMaxDate!) {
                    

//                        datePicker.setDate(date, animated: false)
//                    }
                }

//                if let date = dateFormatter.date(from: txtField.text!){
//                    datePicker.setDate(date, animated: false)
//                }
            }else if(isfutureDateAllowed == false){
                dateFormatter.dateFormat = timeFormat

                if let date = dateFormatter.date(from: txtField.text!) {
                    datePicker.setDate(date, animated: false)
                }
            }
            else {
                dateFormatter.dateFormat = kTimeFormat

                if let date = dateFormatter.date(from: txtField.text!) {
                    datePicker.setDate(date, animated: false)
                }
            }
        }

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.barTintColor = UIColor.Color.blue
        toolBar.tintColor = .white
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DatePicker.doneClick))
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.RobotoMedium(size: FontSize.regular.rawValue)], for: UIControl.State.normal)
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.RobotoMedium(size: FontSize.regular.rawValue)], for: UIControl.State.selected)

        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(DatePicker.cancelClick))
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.RobotoMedium(size: FontSize.regular.rawValue)], for: UIControl.State.normal)
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.RobotoMedium(size: FontSize.regular.rawValue)], for: UIControl.State.selected)

        doneButton.tintColor = UIColor.white
        cancelButton.tintColor = UIColor.white

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtField.inputView = datePicker
        txtField.inputAccessoryView = toolBar
        block = completion
    }

    @objc class func doneClick() {
        let dateFormatter = DateFormatter()

        if datePicker.datePickerMode == .date {
            dateFormatter.dateFormat = kDateGetFormat
            let aString = dateFormatter.string(from: datePicker.date)
            block(aString , false)
        } else if datePicker.datePickerMode == .time {
            //dateFormatter.dateFormat = kTimeFormat
            if futureDate == false{
                dateFormatter.dateFormat = kTimeFormat
                let aString = dateFormatter.string(from: datePicker.date)
               
                block(aString , false)
            }else{
                dateFormatter.dateFormat = timeFormat
                let aString = dateFormatter.string(from: datePicker.date)
               
                block(aString , false)
            }
           
        }

        parentVC.view.endEditing(true)
    }

    @objc class func cancelClick() {
        block("" , true)

        parentVC.view.endEditing(true)
    }
}
