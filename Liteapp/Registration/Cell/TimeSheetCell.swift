//
//  TimeSheetCell.swift
//  Liteapp
//
//  Created by Navroz Huda on 18/06/22.
//

import UIKit

class TimeSheetCell: UITableViewCell , NibReusable {

    
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var regularHoursLabel: UILabel!
   
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var btnDate: MyButton!
    @IBOutlet weak var scrollMainView: UIView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var btnBack: MyButton!
    @IBOutlet weak var btnMore: MyButton!
    @IBOutlet weak var btnDeleteTimesheet: MyButton!
    @IBOutlet weak var btnAddShift: MyButton!
    @IBOutlet weak var btnAddbreak: MyButton!
    @IBOutlet weak var addshiftMainView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var lblweekDay1: UILabel!
    @IBOutlet weak var lblweekDayDate1: UILabel!
    @IBOutlet weak var btnWeekDay1: MyButton!
    
    @IBOutlet weak var lblweekDay2: UILabel!
    @IBOutlet weak var lblweekDayDate2: UILabel!
    @IBOutlet weak var btnWeekDay2: MyButton!
    
    @IBOutlet weak var lblweekDay3: UILabel!
    @IBOutlet weak var lblweekDayDate3: UILabel!
    @IBOutlet weak var btnWeekDay3: MyButton!
    
    
    @IBOutlet weak var lblweekDay4: UILabel!
    @IBOutlet weak var lblweekDayDate4: UILabel!
    @IBOutlet weak var btnWeekDay4: MyButton!
    
    @IBOutlet weak var lblweekDay5: UILabel!
    @IBOutlet weak var lblweekDayDate5: UILabel!
    @IBOutlet weak var btnWeekDay5: MyButton!
    
    @IBOutlet weak var lblweekDay6: UILabel!
    @IBOutlet weak var lblweekDayDate6: UILabel!
    @IBOutlet weak var btnWeekDay6: MyButton!
    
    @IBOutlet weak var lblweekDay7: UILabel!
    @IBOutlet weak var lblweekDayDate7: UILabel!
    @IBOutlet weak var btnWeekDay7: MyButton!
   
    @IBOutlet weak var weekDaysPopupView: UIView!
    
    @IBOutlet weak var btnBackWeekday: MyButton!
    @IBOutlet weak var btncloseWeekday: MyButton!
    var weekDates = [CustomDate]()
   var isChangeDate = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setWeekDays(days:[CustomDate]){
      
        var dates = days
        dates.removeLast()
        for (i,weekDay) in dates.enumerated(){
            switch i {
            case 0:
                self.lblweekDay1.text = weekDay.dayName ?? ""
                self.lblweekDayDate1.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay1.tag = 1
                break
            case 1:
                self.lblweekDay2.text = weekDay.dayName ?? ""
                self.lblweekDayDate2.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay2.tag = 2
                break
            case 2:
                self.lblweekDay3.text = weekDay.dayName ?? ""
                self.lblweekDayDate3.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay3.tag = 3
                break
            case 3:
                self.lblweekDay4.text = weekDay.dayName ?? ""
                self.lblweekDayDate4.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay4.tag = 4
                break
            case 4:
                self.lblweekDay5.text = weekDay.dayName ?? ""
                self.lblweekDayDate5.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay5.tag = 5
                break
            case 5:
                self.lblweekDay6.text = weekDay.dayName ?? ""
                self.lblweekDayDate6.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay6.tag = 6
                break
            case 6:
                self.lblweekDay7.text = weekDay.dayName ?? ""
                self.lblweekDayDate7.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay7.tag = 7
                break
            default:
                break
            }
        }
      //  self.weekDaysPopupView.isHidden = false
  
    }
    
}
