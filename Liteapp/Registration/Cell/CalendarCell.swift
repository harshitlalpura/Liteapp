//
//  CalendarCell.swift
//  Liteapp
//
//  Created by Navroz Huda on 11/06/22.
//

import Foundation
import UIKit

class CalendarCell: UICollectionViewCell {
    static let reuseIdentifier = "CalendarCell"
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
//    override var isSelected: Bool{
//        didSet{
//            if self.isSelected{
//                self.dateLabel.layer.borderWidth = 1.0
//                self.dateLabel.layer.cornerRadius = dateLabel.bounds.height / 2
//                self.dateLabel.clipsToBounds = true
//                self.dateLabel.backgroundColor = UIColor.Color.blueDash
//                self.dateLabel.textColor = UIColor.white
//                self.dateLabel.layer.borderColor = UIColor.white.cgColor
//            }
//            else{
//                self.dateLabel.layer.borderWidth = 0.0
//                self.dateLabel.layer.cornerRadius = 0.0
//                self.dateLabel.backgroundColor = UIColor.clear
//                self.dateLabel.textColor =  UIColor.Color.darkblacklight
//                self.dateLabel.layer.borderColor = UIColor.clear.cgColor
//            }
//        }
//        willSet{
//            super.isSelected = newValue
//            if newValue
//            {
//                self.dateLabel.layer.borderWidth = 1.0
//                self.dateLabel.layer.cornerRadius = dateLabel.bounds.height / 2
//                self.dateLabel.clipsToBounds = true
//                self.dateLabel.backgroundColor = UIColor.Color.blueDash
//                self.dateLabel.textColor = UIColor.white
//                self.dateLabel.layer.borderColor = UIColor.white.cgColor
//            }
//            else
//            {
//                self.dateLabel.layer.borderWidth = 0.0
//                self.dateLabel.layer.cornerRadius = 0.0
//                self.dateLabel.backgroundColor = UIColor.clear
//                self.dateLabel.textColor =  UIColor.Color.darkblacklight
//                self.dateLabel.layer.borderColor = UIColor.clear.cgColor
//            }
//        }
//    }
    func setCellUIForSelection(){
        if self.isSelected{
            self.dateLabel.layer.borderWidth = 1.0
            self.dateLabel.layer.cornerRadius = dateLabel.bounds.height / 2
            self.dateLabel.clipsToBounds = true
            self.dateLabel.backgroundColor = UIColor.Color.blueDash
            self.dateLabel.textColor = UIColor.white
            self.dateLabel.layer.borderColor = UIColor.white.cgColor
        }
        else{
            self.dateLabel.layer.borderWidth = 0.0
            self.dateLabel.layer.cornerRadius = 0.0
            self.dateLabel.backgroundColor = UIColor.clear
            self.dateLabel.textColor =  UIColor.Color.darkblacklight
            self.dateLabel.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
class calendarView: UICollectionView {
     var cellSize = CGSize()
    
}
extension UICollectionView {
    func scrollToNextItem() {
        
        var contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        if contentOffset + self.bounds.size.width > self.contentSize.width{
            contentOffset = self.contentSize.width - self.bounds.size.width
        }
        self.moveToFrame(contentOffset: contentOffset)
    }
    func moveToFrame(contentOffset : CGFloat) {
            self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
    func scrollToPrevItem() {
        var contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        if contentOffset < 0{
            contentOffset  = 0
        }
        self.moveToFrame(contentOffset: contentOffset)
    }
}

