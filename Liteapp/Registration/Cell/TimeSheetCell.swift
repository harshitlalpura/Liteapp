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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
