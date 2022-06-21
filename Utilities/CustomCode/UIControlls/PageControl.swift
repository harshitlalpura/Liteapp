//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 08/02/21

import UIKit

class PageControl: UIStackView {

    @IBInspectable var currentPageImage: UIImage = UIImage(named: "selectedPage")!
    @IBInspectable var pageImage: UIImage = UIImage(named: "unselectedPage")!
    /**
     Sets how many page indicators will show
     */
    var numberOfPages = 4 {
        didSet {
            layoutIndicators()
        }
    }
    /**
     Sets which page indicator will be highlighted with the **currentPageImage**
     */
    var currentPage = 0 {
        didSet {
            setCurrentPageIndicator()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center

        layoutIndicators()
    }

    private func layoutIndicators() {

        for index in 0..<numberOfPages {

            var imageView = UIImageView()

            if index < arrangedSubviews.count {
                // reuse subview if possible
                if let view = arrangedSubviews[index] as? UIImageView {
                    imageView = view
                }
            } else {
                imageView = UIImageView()
                addArrangedSubview(imageView)
            }

            if index == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }

        // remove excess subviews if any
        let subviewCount = arrangedSubviews.count
        if numberOfPages < subviewCount {
            for _ in numberOfPages..<subviewCount {
                arrangedSubviews.last?.removeFromSuperview()
            }
        }
    }

    private func setCurrentPageIndicator() {

        for index in 0..<arrangedSubviews.count {

            var imageView = UIImageView()
            if let view = arrangedSubviews[index] as? UIImageView {
                imageView = view
            }
            if index == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
    }
}
