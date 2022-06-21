//
//  TimeIntervalExtension.swift
//  Partner
//
//   on 13/07/20.
//  Copyright © 2020  Ltd. All rights reserved.
//

import Foundation
import UIKit

extension TimeInterval {

    // TimeInterval.stringFromTimeInterval()
    func stringFromTimeInterval() -> String {

        let time = NSInteger(self)

        //        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        if hours > 0 {
            return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        } else {
            return String(format: "%0.2d:%0.2d", minutes, seconds)
        }

        //        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms) // 00:00:00.000
        //        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)

    }

    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }

    private var seconds: Int {
        return Int(self) % 60
    }

    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    private var hours: Int {
        return Int(self) / 3600
    }

    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes != 0 {
            return "\(minutes)m \(seconds)s"
        } else if milliseconds != 0 {
            return "\(seconds)s \(milliseconds)ms"
        } else {
            return "\(seconds)s"
        }
    }

}
