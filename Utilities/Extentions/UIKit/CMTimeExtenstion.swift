//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 22/02/21

import UIKit
import AVFoundation
extension CMTime {

    /// convert cmtime to string formate
    /// - Returns: String
    func convertToStringFormate() -> String {
        if CMTIME_IS_VALID(self) {
            let totalSeconds = CMTimeGetSeconds(self)
            if totalSeconds > 0 {
                let hours: Int = Int(totalSeconds / 3600)
                let minutes: Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
                let seconds: Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))

                if hours > 0 {
                    return String(format: "%i:%02i:%02i", hours, minutes, seconds)
                } else {
                    return String(format: "%02i:%02i", minutes, seconds)
                }
            }
        }
        return "00:00"
    }
}

