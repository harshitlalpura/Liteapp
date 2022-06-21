//
//  MonthYearPickerView.swift
//  Bryte
//
//   on 22/03/21.
//  Copyright © 2021  Ltd. All rights reserved.
//

import UIKit

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var months = [String]()
    var years = [Int]()
    var selectedDate: Date = Date()

    var minimumDate: Date = Date()
    var maximumDate: Date = Date()
    var month = Calendar.current.component(.month, from: Date()) {
        didSet {
            selectRow(month - 1, inComponent: 0, animated: false)
        }
    }

    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            if let firstYearIndex = years.firstIndex(of: year) {
                selectRow(firstYearIndex, inComponent: 1, animated: true)
            }
        }
    }

    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func commonSetup() {
        self.width = device.width

        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = Calendar.current.component(.year, from: minimumDate)
            for _ in 1...Utility.yearsBetweenDates(startDate: minimumDate, endDate: maximumDate) {
                years.append(year)
                year += 1
            }
        }
        self.years = years

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
        let currentYearIndex = self.years.firstIndex(of: Calendar.current.component(.year, from: selectedDate)) ?? 0

        selectRow(currentMonth - 1, inComponent: 0, animated: false)
        selectRow(currentYearIndex, inComponent: 1, animated: false)

    }

    // Mark: UIPicker Delegate / Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = selectedRow(inComponent: 0) + 1
        let year = years[selectedRow(inComponent: 1)]
        if let block = onDateSelected {
            block(month, year)
        }

        self.month = month
        self.year = year
    }

}
