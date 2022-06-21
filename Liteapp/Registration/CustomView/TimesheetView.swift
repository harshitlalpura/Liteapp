//
//  TimeReportView.swift
//  Bryte
//
//  Created by Navroz Huda on 03/04/22.
//

import UIKit

@IBDesignable class TimesheetView: UIView {
    
    var view: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var btnTimeEdit: MyButton!
    override func awakeFromNib() {
       // profileImageview.cornerRadius = (profileImageview.frame.size.width) / 2
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
      
        let nib = UINib(nibName: "TimesheetView", bundle: Bundle.main)
        view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        addSubview(view)
        print(view.frame)
        view.frame = bounds

    }

}
