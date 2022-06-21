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
    @IBOutlet weak var btnAddTimesheet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
