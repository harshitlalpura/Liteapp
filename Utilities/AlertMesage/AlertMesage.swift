//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 04/02/21

import SwiftMessages
import UIKit

class AlertMesage: NSObject {
    public class func show(_ theme: Theme, title: String? = nil, message: String?) {
        let view: MessageView = MessageView.viewFromNib(layout: .cardView)
        view.backgroundView.layer.cornerRadius = 12.0
        view.configureContent(title: "Info", body: message?.localized, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "", buttonTapHandler: {  _ in SwiftMessages.hide() })

        let iconStyle: IconStyle = .subtle

        // Theme
        switch theme {
        case .info:
            view.configureTheme(backgroundColor: UIColor.Color.yellow, foregroundColor: .white, iconImage: iconStyle.image(theme: .info), iconText: nil)
            view.titleLabel?.text = "Info"

        case .success:
//            view.configureTheme(backgroundColor: UIColor.green, foregroundColor: .white, iconImage: iconStyle.image(theme: .success), iconText: nil)
//            view.titleLabel?.text = "Success"
            
            view.configureTheme(backgroundColor: UIColor.Color.green, foregroundColor: .white, iconImage: iconStyle.image(theme: .warning), iconText: nil)
            view.iconImageView?.image = view.iconImageView?.image!.withRenderingMode(.alwaysTemplate)
            view.iconImageView?.tintColor = UIColor.Color.blue
            view.titleLabel?.text = "Success"
            view.bodyLabel?.textColor = UIColor.white
            view.titleLabel?.textColor = UIColor.white

        case .warning:

            view.configureTheme(backgroundColor: UIColor.Color.red, foregroundColor: .white, iconImage: iconStyle.image(theme: .warning), iconText: nil)
            view.iconImageView?.image = view.iconImageView?.image!.withRenderingMode(.alwaysTemplate)
            view.iconImageView?.tintColor = UIColor.Color.white
            view.titleLabel?.text = "Warning"
            view.bodyLabel?.textColor = UIColor.white
            view.titleLabel?.textColor = UIColor.white

        case .error:
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.error)
            view.configureTheme(backgroundColor: UIColor.Color.red, foregroundColor: .white, iconImage: iconStyle.image(theme: .error), iconText: nil)
            view.titleLabel?.text = "Error"
        }

        view.titleLabel?.text = ""

        if title != nil {
            view.titleLabel?.text = title!
        }

        // Set Font
        view.titleLabel?.font = UIFont.RobotoRegular(size: 18)
        view.bodyLabel?.font = UIFont.RobotoRegular(size: 14)
        //
        // Set Shadow
        view.configureDropShadow()

        // Set Button
        view.button?.isHidden = true

        // Show Icon
        view.iconImageView?.isHidden = true
        view.iconLabel?.isHidden = true

        // Show Title
        view.titleLabel?.isHidden = false

        // Show Body
        view.bodyLabel?.isHidden = false

        // -- Config setup

        var config = SwiftMessages.defaultConfig

        // Presentation
        config.presentationContext = .window(windowLevel: UIWindow.Level.normal)

        // Duration

        config.duration = .seconds(seconds: 1.5)

        // Rotation
        config.shouldAutorotate = true

        // Hide on Interaction
        config.interactiveHide = true

        // Show Message Bar
        DispatchQueue.main.async {
           SwiftMessages.show(config: config, view: view)
        }
    }

    public class func hideSBMessage() {
        SwiftMessages.hideAll()
    }
    
    public class func showInternetNotConnected(message: String = "Internet Connection Lost") -> Void {

        // -- View setup
        let view: MessageView = MessageView.viewFromNib(layout: .statusLine)

        view.configureContent(title: nil,
                              body: message,
                              iconImage: nil,
                              iconText: nil,
                              buttonImage: nil,
                              buttonTitle: nil,
                              buttonTapHandler: { _ in SwiftMessages.hide() })

        view.configureTheme(backgroundColor: UIColor.Color.red,
                            foregroundColor: .white,
                            iconImage: nil,
                            iconText: nil)

        view.titleLabel?.text = ""
        view.bodyLabel?.numberOfLines = 2

        // Set Font
        view.bodyLabel?.font = UIFont.RobotoRegular(size: 14)
        // Button
        view.button?.isHidden = true

        // Show Icon
        view.iconImageView?.isHidden = true
        view.iconLabel?.isHidden = true

        // Show Title
        view.titleLabel?.isHidden = true

        // Show Body
        view.bodyLabel?.isHidden = false

        // Add a drop shadow.
//        view.configureDropShadow()


        // -- Config setup

        var config = SwiftMessages.defaultConfig

        // Presentation
        config.presentationStyle = .top

        // Specify a status bar style to if the message is displayed directly under the status bar.
        config.preferredStatusBarStyle = .default

        // Display in a window at the specified window level: UIWindow.Level.statusBar
        // displays over the status bar while UIWindow.Level.normal displays under.
        config.presentationContext = .window(windowLevel: .statusBar)

        // Duration
        config.duration = .seconds(seconds: 5)

        // Rotation
        config.shouldAutorotate = true

        // Hide on Interaction
        config.interactiveHide = true


        // Show the message.
        DispatchQueue.main.async {
            SwiftMessages.show(config: config, view: view)
        }

    }
}
