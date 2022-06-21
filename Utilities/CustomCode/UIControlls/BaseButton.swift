//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 04/02/21

import Foundation
import UIKit

class BaseButton: UIButton {

    @IBInspectable var enableClick: Bool = true {
        didSet {
            setupUI()
        }
    }
    // Change Style with Background Border, set by default clear
    @IBInspectable var buttonBackgroundColor: UIColor =  UIColor.clear {
        didSet {
            setupUI()
        }
    }
    @IBInspectable var buttonTextolor: UIColor =  UIColor.black {
        didSet {
            setupUI()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 12
        backgroundColor = buttonBackgroundColor
        self.isEnabled =  enableClick
        setTitleColor(buttonTextolor, for: .normal) //buttonTextolor
        titleLabel?.font = UIFont.Robotobold(size: 22)
        if let aStrTitle = title(for: .normal)?.localized {
            if title(for: .normal)! != aStrTitle {
//                setTitle(aStrTitle.uppercased(), for: .normal)
                setTitle(aStrTitle, for: .normal)
                titleLabel?.adjustsFontSizeToFitWidth = true
            } else {
                return
            }
        }
    }
}

class BaseNormalButton: UIButton {

    @IBInspectable var isBold: Bool = false {
        didSet {
            setupUI()
        }
    }
    @IBInspectable var isSemibold: Bool = false {
        didSet {
            setupUI()
        }
    }
    
    @IBInspectable var isSemiboldLarge: Bool = false {
        didSet {
            setupUI()
        }
    }
    @IBInspectable var regularTitle: Bool = false {
        didSet {
            setupUI()
        }
    }
    
    @IBInspectable var cornerRounded: CGFloat = 8 {
        didSet {
            setupUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        titleLabel?.font =  UIFont.RobotoRegular(size: FontSize.regularLarge.rawValue)
        if isSemibold {
            titleLabel?.font = UIFont.Robotobold(size: FontSize.regularLarge.rawValue)
                
        }
        if isSemiboldLarge {
            titleLabel?.font = UIFont.Robotobold(size: FontSize.regularLarge.rawValue)
        }
        if regularTitle {
            titleLabel?.font = UIFont.RobotoRegular(size: FontSize.regularLarge.rawValue)
        }
        
        layer.cornerRadius = cornerRounded
        
        if let aStrTitle = title(for: .normal)?.localized {
            if title(for: .normal)! != aStrTitle {
                setTitle(aStrTitle, for: .normal)
                titleLabel?.adjustsFontSizeToFitWidth = true
            } else {
                return
            }
            
        }
    }
}
class BaseSmallButton: UIButton {


    @IBInspectable var cornerRounded: CGFloat = 22 {
        didSet {
            setupUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        titleLabel?.font =  UIFont.RobotoRegular(size: FontSize.regular.rawValue)
        layer.cornerRadius = cornerRounded
        
        self.imageView?.contentMode = .center
        if let aStrTitle = title(for: .normal)?.localized {
            if title(for: .normal)! != aStrTitle {
                setTitle(aStrTitle, for: .normal)
                titleLabel?.adjustsFontSizeToFitWidth = true
            } else {
                return
            }

        }
    }
}
