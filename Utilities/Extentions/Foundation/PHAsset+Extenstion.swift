//
//  PHAsset+Extenstion.swift
//  Partner
//
//   on 13/07/20.
//  Copyright © 2020  Ltd. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension PHAsset {

    var fileSize: Float {
        get {
            let resource = PHAssetResource.assetResources(for: self)
            let imageSizeByte = resource.first?.value(forKey: "fileSize") as? Float ?? 0
            let imageSizeMB = imageSizeByte / (1024.0*1024.0)
            return imageSizeMB
        }
    }

    var image: UIImage {

        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        imageManager.requestImage(for: self,
                                  targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                                  contentMode: .aspectFit,
                                  options: options,
                                  resultHandler: { image, _ in
                                    thumbnail = image!
        })

        return thumbnail

    }

}
