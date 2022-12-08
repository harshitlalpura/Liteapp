//
//  CustomMenuLogoutCell.swift
//  Liteapp
//
//  Created by Apurv Soni on 01/12/22.
//

import UIKit

class CustomMenuLogoutCell: UITableViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var selectedBar: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
