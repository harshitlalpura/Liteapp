//
//  YearPickerView.swift
//  Bryte
//
//   on 22/03/21.
//  Copyright © 2021  Ltd. All rights reserved.
//

import UIKit

class YearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var years = [Int]()
    var minimumDate: Date = Date()
    var maximumDate: Date = Date()
    var selectedDate: Date!

    var year = Calendar.current.component(.year, from: Date()) {
        didSet {
            if let firstYearIndex = years.firstIndex(of: year) {
                selectRow(firstYearIndex, inComponent: 0, animated: true)
            }
        }
    }

    var onDateSelected: ((_ year: Int) -> Void)?

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

        delegate = self
        dataSource = self


        let currentYearIndex = self.years.firstIndex(of: Calendar.current.component(.year, from: selectedDate)) ?? 0
        selectRow(currentYearIndex, inComponent: 0, animated: false)
    }

    // Mark: UIPicker Delegate / Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(years[row])"
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return years.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let year = years[selectedRow(inComponent: 0)]
        if let block = onDateSelected {
            block(year)
        }
        self.year = year
    }

}
