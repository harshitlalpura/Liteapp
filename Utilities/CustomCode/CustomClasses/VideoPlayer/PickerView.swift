//
//  ECMPicker.swift
//  E-Receipt
//
//  Created by My-EReceipt on 23/04/2p.
//  Copyright © 2018 My-EReceipt. All rights reserved.
//

import UIKit

class PickerDataModel {
    // MARK: Properties

    var name: String
    var nameAr: String
    var id: String

    init?(_ name: String, _ nameAr: String, _ id: String) {
        self.name = name
        self.nameAr = nameAr
        self.id = id
    }
}

class PickerView: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: Properties

    // MARK: 

    static let sharedInstance = PickerView()
    typealias pickerCompletionBlock = (_ selectedIndex: Int, _ selectedValue: String , _ isCancel: Bool) -> Void
    var simplePicker: UIPickerView?
    var pickerDataSource: NSMutableArray?
    var pickerBlock: pickerCompletionBlock?
    var pickerSelectedIndex: Int = 0
    var parentVC = UIViewController()
    var arrPickerData = [String]()

    var arrCategoryData = [PickerDataModel]()
    var arrSubCategoryData = [PickerDataModel]()
    var arrPriorityData = [PickerDataModel]()
    var arrDeliveryModeData = [PickerDataModel]()

    /// Call this function to add picker over textfield
    func addPicker(_ controller: UIViewController, onTextField: UITextField, pickerArray: [String], withCompletionBlock: @escaping pickerCompletionBlock) {
        parentVC = controller
        arrPickerData = pickerArray
        pickerSelectedIndex = 0

        onTextField.tintColor = UIColor.clear
        let keyboardDateToolbar = UIToolbar()
        keyboardDateToolbar.barStyle = .default
        keyboardDateToolbar.isTranslucent = false
        keyboardDateToolbar.barTintColor =  UIColor.Color.appBlueColor
        keyboardDateToolbar.tintColor = .white
        keyboardDateToolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(pickerDone))
        done.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.RobotoMedium(size: FontSize.regular.rawValue)], for: UIControl.State.normal)
        done.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.RobotoMedium(size: FontSize.regular.rawValue)], for: UIControl.State.highlighted)
        done.tintColor = UIColor.white

        let cancel = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(pickerCancel))
        cancel.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.RobotoMedium(size: FontSize.regular.rawValue)], for: UIControl.State.normal)
        cancel.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.RobotoMedium(size: FontSize.regular.rawValue)], for: UIControl.State.highlighted)
        cancel.tintColor = UIColor.white

        keyboardDateToolbar.setItems([cancel, flexSpace, done], animated: true)
        onTextField.inputAccessoryView = keyboardDateToolbar

        pickerDataSource = NSMutableArray(array: pickerArray)
        simplePicker = UIPickerView()
        simplePicker!.backgroundColor = UIColor.white
        simplePicker!.delegate = self
        simplePicker!.dataSource = self

        if let index = pickerArray.firstIndex(of: onTextField.text!) {
            simplePicker!.selectRow(index, inComponent: 0, animated: true)
        }
        onTextField.inputView = simplePicker
        onTextField.becomeFirstResponder()
        pickerBlock = withCompletionBlock
    }

    // MARK: UIPickerView Delegates

    // MARK: 

    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        if pickerDataSource != nil {
            return pickerDataSource!.count
        }
        return 0
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return pickerDataSource![row] as? String
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        pickerSelectedIndex = row
    }

    // MARK: Button Click Events

    // MARK: 

    @objc func pickerDone() {
        if pickerSelectedIndex > arrPickerData.count {
            pickerSelectedIndex = 0
        }
        pickerBlock!(pickerSelectedIndex, arrPickerData[pickerSelectedIndex], false)
        parentVC.view.endEditing(true)
    }

    @objc func pickerCancel() {
        if pickerSelectedIndex > arrPickerData.count {
            pickerSelectedIndex = 0
        }
        pickerBlock!(pickerSelectedIndex, arrPickerData[pickerSelectedIndex], true)
        parentVC.view.endEditing(true)
        
    }
}

