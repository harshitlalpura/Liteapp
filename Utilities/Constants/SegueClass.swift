//
//  Created by CustomTabbar
//  Copyright © CustomTabbar All rights reserved.
//  Created on 01/05/20

import UIKit

class SegueClass: UIStoryboardSegue {

    override func perform() {
        
    }
}

class RootVCSegue: UIStoryboardSegue {


    override func perform() {

        guard let aWindow = APP_DELEGATE.window else { return }

//        UIView.transition(with: aWindow,
//                          duration: 0.55,
//                          options: .transitionCrossDissolve,
//                          animations: {
                            aWindow.rootViewController = self.destination
//        })
    }

}
