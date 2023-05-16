//
//  TimesheetHeaderCell.swift
//  Liteapp
//
//  Created by Navroz Huda on 18/06/22.
//

import UIKit

class TimesheetHeaderCell: UITableViewCell , NibReusable {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var regularHoursLabel: UILabel!
    @IBOutlet weak var overTimeLabel: UILabel!
    @IBOutlet weak var totalTimeTitleLabel: UILabel!
    @IBOutlet weak var regularHoursTitleLabel: UILabel!
    @IBOutlet weak var overTimeTitleLabel: UILabel!
    @IBOutlet weak var btnAddTimesheet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        totalTimeTitleLabel.text = NSLocalizedString("Total Hours:", comment: "totalTimeTitleLabel")
        regularHoursTitleLabel.text = NSLocalizedString("Regular Hours:", comment: "regularHoursTitleLabel")
        overTimeTitleLabel.text = NSLocalizedString("Overtime Hours:", comment: "overTimeTitleLabel")
        button.setTitle(NSLocalizedString("UNAPPROVED", comment: "button"), for: .normal)
        btnAddTimesheet.setTitle(NSLocalizedString("ADD DAY", comment: "btnAddTimesheet"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
