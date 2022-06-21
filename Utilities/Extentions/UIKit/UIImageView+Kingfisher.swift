//
//  UIImageView+Kingfisher.swift
//  Bryte
//
//  Created by Navroz Huda 12/04/21.
//  Copyright © 2021 Bryte Ltd. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    /// - Util function to add image with caching
    func setImageUsingKF(string: String?, placeholder: UIImage?) {
        ///  ====  Append base media path here
        let updatedString = API.URL.imgURL + (string ?? "")
        self.kf.setImage(with: URL(string: updatedString), placeholder: placeholder, options: [.cacheOriginalImage])
    }
    /// for image rounde
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
