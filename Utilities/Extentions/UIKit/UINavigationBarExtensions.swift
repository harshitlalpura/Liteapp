//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 03/02/21

import Foundation
import UIKit

// MARK: - Methods

public extension UINavigationBar {

    /// set Navigation bar theme
    /// - Parameters:
    ///   - barColor: bard color of navigationbar
    ///   - tintColor: tintColorOfNavigationBar
    func setNavigationBar(background: UIColor, text: UIColor) {
        self.setColors(background: background, text: text)
        self.setTitleFont(UIFont.Robotobold(size: FontSize.regularLarge.rawValue), color: text)
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
//        navigationItem.title = navigationItem.title?.localized
//        navigationItem.leftBarButtonItem?.title = navigationItem.leftBarButtonItem?.title?.localized
    }

    /// This method will set the Shadow to Navigation Bar
    ///
    /// - Parameter color: Color of the shadow
    func setShadow(color: UIColor) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 4
    }

    /// Set Navigation Bar title, title color and font.
    ///
    /// - Parameters:
    ///   - font: title font
    ///   - color: title text color (default is .black).
    func setTitleFont(_ font: UIFont, color: UIColor = UIColor.black) {
        var attrs = [NSAttributedString.Key: Any]()
        attrs[.font] = font
        attrs[.foregroundColor] = color
        titleTextAttributes = attrs
    }

    /// Make navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    func makeTransparent(withTint tint: UIColor = .white) {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        tintColor = tint
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: tint]
    }

    /// Set navigationBar background and text colors
    ///
    /// - Parameters:
    ///   - background: backgound color
    ///   - text: text color
    func setColors(background: UIColor, text: UIColor) {
        isOpaque = true
        isTranslucent = false
        backgroundColor = background
        barTintColor = background
        setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        tintColor = text
        titleTextAttributes = [.foregroundColor: text]
    }
    
    /// Set navigationBar background and text colors
    ///
    /// - Parameters:
    ///   - background: backgound color
    ///   - text: text color
    func resetColors() {
        isTranslucent = true
        backgroundColor = .clear
        barTintColor = .clear
        tintColor = .black
        titleTextAttributes = [.foregroundColor: UIColor.black]
    }
}
