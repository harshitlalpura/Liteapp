//
//  AVURLAsset+Extension.swift
//  Partner
//
//   on 13/07/20.
//  Copyright © 2020  Ltd. All rights reserved.
//

import Foundation
import AVFoundation

extension AVURLAsset {

    /// Size in bytes
    /// 1 megabytes = 1048576 bytes
    var fileSize: Double {

        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)

        guard let aSize = resourceValues?.fileSize ?? resourceValues?.totalFileSize else { return 0 }
//        return resourceValues?.fileSize ?? resourceValues?.totalFileSize

        let aSizeInMB = Double(aSize/1000000)

        return aSizeInMB
        // 1 megabytes = 1048576 bytes

    }

}
