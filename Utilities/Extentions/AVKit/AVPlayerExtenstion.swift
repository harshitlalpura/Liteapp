//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 22/02/21

import AVKit

extension AVPlayer {

    /// check is player playing or not
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
