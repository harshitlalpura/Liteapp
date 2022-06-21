//
//  MonthPickerView.swift
//  Bryte
//
//   on 22/03/21.
//  Copyright © 2021  Ltd. All rights reserved.
//

import UIKit

class MonthPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var months = [String]()
    var minimumDate: Date = Date()
    var selectedDate: Date!

    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month - 1, inComponent: 0, animated: false)
        }
    }

    var year = Calendar.current.component(.year, from: Date())

    var onDateSelected: ((_ month: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func commonSetup() {
        self.width = device.width
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months

        delegate = self
        dataSource = self

        let currentMonth = Calendar.current.component(.month, from: selectedDate)
        selectRow(currentMonth - 1, inComponent: 0, animated: false)
    }

    // Mark: UIPicker Delegate / Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = selectedRow(inComponent: 0) + 1
        if let block = onDateSelected {
            block(month)
        }

        self.month = month
    }

}
