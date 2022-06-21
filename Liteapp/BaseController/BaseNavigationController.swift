//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 28/06/21


import UIKit

/// BaseNavigationController use for hanle all the navation stack and top bar

class BaseNavigationController: UINavigationController {

    /// This variable for set status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    var statusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
