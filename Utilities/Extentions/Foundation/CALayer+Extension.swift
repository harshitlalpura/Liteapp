//
//  CALayer+Extension.swift
//  Partner
//
//   on 13/07/20.
//  Copyright © 2020  Ltd. All rights reserved.
//

import UIKit

extension CALayer {

    func applySketchShadow(color: UIColor = .black,
                           alpha: Float = 0.5,
                           x: CGFloat = 0,
                           y: CGFloat = 2,
                           blur: CGFloat = 4,
                           spread: CGFloat = 0,
                           oval: Bool = false) {

        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0

        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            if oval {
                shadowPath = UIBezierPath(ovalIn: rect).cgPath
            } else {
                shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 6.0).cgPath
//                shadowPath = UIBezierPath(rect: rect).cgPath
            }
        }

    }

}
