//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 26/03/21


import UIKit

class AppBaseLabel: UILabel {
    enum LabelType: Int {
        
        case regular16 = 1
        case light14 = 2
        case regular26 = 3
        case mediaum16 = 4
        case mediaum22 = 5
        case regular14 = 6
        case regular18 = 7
        case bold14 = 8
        case regular12 = 9
        case regular10 = 10
        case regular31 = 11
        case bold21 = 12
        case bold28 = 13
        case regular22 = 14
        case bold35 = 15
        case bold42 = 16
        case mediaum18 = 17
    }

    // Programmatically: use the enum
    private var labelType: LabelType = .regular16

    // Left Padding Of Label
    @IBInspectable var leftInset: CGFloat = 0 {
        didSet {
            initialSetup()
        }
    }

    // Right Padding Of Label
    @IBInspectable var rightInset: CGFloat = 0 {
        didSet {
            initialSetup()
        }
    }

    // Change Style with Rounded Border, set by default yes
    @IBInspectable var isLabelRounded: Bool = false {
        didSet {
            initialSetup()
        }
    }

    // Change Style with Background Border, set by default clear
    @IBInspectable var labelBackgroundColor: UIColor = .clear {
        didSet {
            initialSetup()
        }
    }

    // IB: use the adapter
    @IBInspectable var labelFontType: Int {
        get {
            return self.labelType.rawValue
        }
        set( shapeIndex) {
            self.labelType = LabelType(rawValue: shapeIndex) ?? .regular16
            initialSetup()
        }
    }

    override var text: String? {
        didSet {
            if text != nil {
                initialSetup()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
        

    }

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
        super.drawText(in: rect.inset(by: insets))

    }

    private func initialSetup() {

        switch labelType {
        
        case .regular16:
            font = UIFont.RobotoRegular(size: FontSize.regular.rawValue)
            
        case .regular18:
            font = UIFont.RobotoRegular(size: FontSize.regular18.rawValue)
        
        case .regular14:
            font = UIFont.RobotoRegular(size: FontSize.light.rawValue)
            
            
        case .regular26:
            font = UIFont.RobotoRegular(size: FontSize.regular26.rawValue)
            
        case .light14:
            font = UIFont.Robotolight(size: FontSize.light.rawValue)
        
            
        case .mediaum16:
            font = UIFont.RobotoMedium(size: FontSize.regular.rawValue)
            
        case .mediaum22:
            font = UIFont.RobotoMedium(size: FontSize.medium22.rawValue)
            
            
        case .bold14:
            font = UIFont.Robotobold(size: FontSize.light.rawValue)

        case .regular12:
            font = UIFont.RobotoRegular(size: FontSize.regular12.rawValue)
            
        case .regular10:
            font = UIFont.RobotoRegular(size: FontSize.regular10.rawValue)
            
        case .regular31:
            font = UIFont.RobotoRegular(size: FontSize.regular31.rawValue)
            
        case .bold21:
            font = UIFont.Robotobold(size: FontSize.bold21.rawValue)
            
        case .bold28:
            font = UIFont.Robotobold(size: FontSize.bold28.rawValue)
            
        case .regular22:
            font = UIFont.RobotoRegular(size: FontSize.regularLarge.rawValue)
            
        case .bold35:
            font = UIFont.RobotoRegular(size: FontSize.bold35.rawValue)
            
        case .bold42:
            font = UIFont.RobotoRegular(size: FontSize.bold42.rawValue)
            
        case .mediaum18:
            font = UIFont.RobotoMedium(size: FontSize.medium18.rawValue)
            
            
            
        }

        if isLabelRounded {
            layer.cornerRadius = self.height / 2
            layer.masksToBounds = true
        }
//        backgroundColor = labelBackgroundColor
//        guard let aStrTitle = text?.localized else {
//            print(" ========================== \(String(describing: text!)) NOT FOUND IN Language FILE ==========================")
//            return
//        }
        // Stop infinity loop generated from didSet
        if let aStrTitle = text?.localized {
            guard aStrTitle != text! else { return }
            text = aStrTitle
        }
    }
}
