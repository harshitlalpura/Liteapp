//
//  TimeReportCell.swift
//  Bryte
//
//  Created by Navroz Huda on 03/04/22.
//

import UIKit

class TimeReportCell: UITableViewCell , NibReusable {

    @IBOutlet weak var stackView: UIStackView!

    
    @IBOutlet weak var totalTimeTitle: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var regularHoursTitle: UILabel!
    @IBOutlet weak var regularHoursLabel: UILabel!
    @IBOutlet weak var overTimeTitle: UILabel!
    @IBOutlet weak var overTimeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var btnDate: MyButton!
    @IBOutlet weak var scrollMainView: UIView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var btnBack: MyButton!
    @IBOutlet weak var btnCancel: MyButton!
    @IBOutlet weak var btnMore: MyButton!
    @IBOutlet weak var btnDeleteTimesheet: MyButton!
    @IBOutlet weak var btnAddShift: MyButton!
    @IBOutlet weak var btnAddbreak: MyButton!
    @IBOutlet weak var addshiftMainView: UIView!
    
    @IBOutlet weak var lblweekDay1: UILabel!
    @IBOutlet weak var lblweekDayDate1: UILabel!
    @IBOutlet weak var btnWeekDay1: MyButton!
    @IBOutlet weak var viewDay1: UIView!
    
    @IBOutlet weak var lblweekDay2: UILabel!
    @IBOutlet weak var lblweekDayDate2: UILabel!
    @IBOutlet weak var btnWeekDay2: MyButton!
    @IBOutlet weak var viewDay2: UIView!
    
    
    @IBOutlet weak var lblweekDay3: UILabel!
    @IBOutlet weak var lblweekDayDate3: UILabel!
    @IBOutlet weak var btnWeekDay3: MyButton!
    @IBOutlet weak var viewDay3: UIView!
    
    
    @IBOutlet weak var lblweekDay4: UILabel!
    @IBOutlet weak var lblweekDayDate4: UILabel!
    @IBOutlet weak var btnWeekDay4: MyButton!
    @IBOutlet weak var viewDay4: UIView!
    
    @IBOutlet weak var lblweekDay5: UILabel!
    @IBOutlet weak var lblweekDayDate5: UILabel!
    @IBOutlet weak var btnWeekDay5: MyButton!
    @IBOutlet weak var viewDay5: UIView!
    
    @IBOutlet weak var lblweekDay6: UILabel!
    @IBOutlet weak var lblweekDayDate6: UILabel!
    @IBOutlet weak var btnWeekDay6: MyButton!
    @IBOutlet weak var viewDay6: UIView!
    
    @IBOutlet weak var lblweekDay7: UILabel!
    @IBOutlet weak var lblweekDayDate7: UILabel!
    @IBOutlet weak var btnWeekDay7: MyButton!
    @IBOutlet weak var viewDay7: UIView!
    
    @IBOutlet weak var weekDaysPopupView: UIView!
    @IBOutlet weak var dailyOverTimeView: UIView!
    
    @IBOutlet weak var btnBackWeekday: MyButton!
    @IBOutlet weak var btncloseWeekday: MyButton!
    var isChangeDate = false
    var weekDates = [CustomDate]()
    override func awakeFromNib() {
        super.awakeFromNib()
        totalTimeTitle.text = NSLocalizedString("Total Hours:", comment: "totalTimeTitle")
        regularHoursTitle.text = NSLocalizedString("Regular Hours:", comment: "regularHoursTitle")
        overTimeTitle.text = NSLocalizedString("Overtime Hours:", comment: "overTimeTitle")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    func setMoreButtonStatus(needToEnable : Bool){
        if needToEnable{
            btnMore.isEnabled = true
            btnMore.isUserInteractionEnabled = true
        }
        else{
            btnMore.isEnabled = false
            btnMore.isUserInteractionEnabled = false
        }
        
    }
    
    func hideAllDayViews(){
        viewDay1.isHidden = true
        viewDay2.isHidden = true
        viewDay3.isHidden = true
        viewDay4.isHidden = true
        viewDay5.isHidden = true
        viewDay6.isHidden = true
        viewDay7.isHidden = true
    }
    
    func setWeekDays(days:[CustomDate]){
        hideAllDayViews()
        var dates = days
        dates.removeLast()
        for (i,weekDay) in dates.enumerated(){
            switch i {
            case 0:
                self.lblweekDay1.text = weekDay.dayName ?? ""
                self.lblweekDayDate1.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay1.tag = 1
                self.viewDay1.isHidden = false
                break
            case 1:
                self.lblweekDay2.text = weekDay.dayName ?? ""
                self.lblweekDayDate2.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay2.tag = 2
                self.viewDay2.isHidden = false
                break
            case 2:
                self.lblweekDay3.text = weekDay.dayName ?? ""
                self.lblweekDayDate3.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay3.tag = 3
                self.viewDay3.isHidden = false
                break
            case 3:
                self.lblweekDay4.text = weekDay.dayName ?? ""
                self.lblweekDayDate4.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay4.tag = 4
                self.viewDay4.isHidden = false
                break
            case 4:
                self.lblweekDay5.text = weekDay.dayName ?? ""
                self.lblweekDayDate5.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay5.tag = 5
                self.viewDay5.isHidden = false
                break
            case 5:
                self.lblweekDay6.text = weekDay.dayName ?? ""
                self.lblweekDayDate6.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay6.tag = 6
                self.viewDay6.isHidden = false
                break
            case 6:
                self.lblweekDay7.text = weekDay.dayName ?? ""
                self.lblweekDayDate7.text = weekDay.datestringForDisplay ?? ""
                self.btnWeekDay7.tag = 7
                self.viewDay7.isHidden = false
                break
            default:
                break
            }
        }
      //  self.weekDaysPopupView.isHidden = false
  
    }
}
