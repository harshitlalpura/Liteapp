//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 04/02/21

import UIKit

class ProgressHUD {
    
    class func show() {
        self.displaySpinner()
    }
    
    class func hide() {
        self.removeSpinner()
    }
    
    private class func displaySpinner() {
        DispatchQueue.main.async {
            guard let keyWindow = KEY_WINDOW else {return}
            for view in (keyWindow.subviews) where view.tag == 500 {
                view.removeFromSuperview()
            }
            let blurView = UIView()
            let point = keyWindow.center
         //   blurView.frame = (keyWindow.bounds)
            blurView.frame = CGRect(x:point.x - 50.0, y: point.y - 60.0, width: 100.0, height: 120.0)
            
           
            blurView.tag = 500
            blurView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
            blurView.cornerRadius = 10.0
            activityIndicatorView.color = UIColor.Color.white
            activityIndicatorView.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
            activityIndicatorView.center = blurView.center
            activityIndicatorView.tag = 500
            blurView.clipsToBounds = true
           // blurView.addSubview(activityIndicatorView)
            KEY_WINDOW?.addSubview(blurView)
            KEY_WINDOW?.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
        }
    }
    
    private class func removeSpinner() {
        DispatchQueue.main.async {
            if let loaderView = KEY_WINDOW?.subviews {
                for view in loaderView where view.tag == 500 {
                    view.removeFromSuperview()
                }
            }
        }
    }
}
