//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 08/02/21

import UIKit

class UserInteractedView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.point(inside: point, with: event) {
            return nil
        }

        for subview in self.allSubViewsOf(type: BaseNormalButton.self) {
            if let frame = self.getConvertedFrame(fromSubview: subview) {
                if frame.contains(point) {
                    return subview
                }
            }
        }

        for subview in self.allSubViewsOf(type: UIButton.self) {
            if let frame = self.getConvertedFrame(fromSubview: subview) {
                if frame.contains(point) {
                    return subview
                }
            }
        }

        for subview in self.allSubViewsOf(type: BaseUIControl.self) {
            if let frame = self.getConvertedFrame(fromSubview: subview) {
                if frame.contains(point) {
                    return subview
                }
            }
        }
        return nil
    }
}
