//
//  EmployeeCell.swift
//  Liteapp
//
//  Created by Navroz Huda on 12/06/22.
//

import UIKit

class EmployeeCell: UITableViewCell {
    static let reuseIdentifier = "EmployeeCell"
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      //  mainView.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class TimesheetDetailsCell: UITableViewCell {
    static let reuseIdentifier = "TimesheetDetailsCell"
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbltotal: UILabel!
    @IBOutlet weak var lblapprove: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var btnCheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
      //  mainView.dropShadow()
        btnCheck.setImage(UIImage.checkImage, for: .selected)
        btnCheck.setImage(UIImage.uncheckImage, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
class ContactCell: UITableViewCell {
    static let reuseIdentifier = "ContactCell"
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var imageview: UIImageView!
  
    @IBOutlet weak var btnCheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        btnCheck.setImage(UIImage.checkImage, for: .selected)
        btnCheck.setImage(UIImage.uncheckImage, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
