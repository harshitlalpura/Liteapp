//
//  TimeReportCVHeaderCell.swift
//  Liteapp
//
//  Created by Navroz Huda on 17/07/22.
//

import UIKit

class TimeReportCVHeaderCell: UICollectionViewCell , NibReusable {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var btnAddTimesheet: UIButton!
    @IBOutlet weak var totalTimeTitle: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var regularHoursTitle: UILabel!
    @IBOutlet weak var regularHoursLabel: UILabel!
    @IBOutlet weak var overTimeTitle: UILabel!
    @IBOutlet weak var overTimeLabel: UILabel!
    @IBOutlet weak var weeklyOverTimeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        totalTimeTitle.text = NSLocalizedString("Total Hours:", comment: "totalTimeTitle")
        regularHoursTitle.text = NSLocalizedString("Regular Hours:", comment: "regularHoursTitle")
        overTimeTitle.text = NSLocalizedString("Overtime Hours:", comment: "overTimeTitle")
        btnAddTimesheet.setTitle(NSLocalizedString("ADD DAY", comment: "btnAddTimesheet"), for: .normal)
    }

}
