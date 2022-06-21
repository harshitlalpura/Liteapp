//
//  BaseCollectionView.swift
//  Kutubi
//
//  Created by Navroz Huda 20/01/21.
//  Copyright © 2021 Bryte Ltd. All rights reserved.
//

import UIKit

@objc protocol BaseCollectionViewDelegate {
    
    @objc optional func didPullToRefresh(_ collectionView: BaseCollectionView, refreshControl: UIRefreshControl)

    @objc optional func didTapEmptyView(_ emptyView: UIScrollView, didTap view: UIView)
    
    @objc optional func didTapEmptyButton(_ emptyView: UIScrollView, didTap button: UIView)
}

class BaseCollectionView: UICollectionView, EmptyDataSetSource, EmptyDataSetDelegate {

    var pullToRefreshControl: UIRefreshControl?

    public weak var helperDelegate: BaseCollectionViewDelegate?

    /// Pull To Refresh
    @IBInspectable
    open var pullToRefresh: Bool = false

    /// Message Title to display when No data is Found
    @IBInspectable
    open var emptyMessage: String = "No data available."

    /// Description to display when No data is Found
    @IBInspectable
    open var emptyDescription: String = ""

    /// Button Title when No data is Found
    @IBInspectable
    open var emptyButtonTitle: String = ""

    /// Background Image when No data is Found
    @IBInspectable
    //    open var emptyImage: UIImage = UIImage(named: "no_data")!
    open var emptyImage: UIImage?
        
    @IBInspectable
    open var verticalOffSet: Int = 40

    @IBInspectable
    open var descriptionColor: UIColor = UIColor.Color.blue
    @IBInspectable
    open var titleColor: UIColor = UIColor.Color.blue
    

    override func awakeFromNib() {
        super.awakeFromNib()
        emptyDataSetSource = self
        emptyDataSetDelegate = self

        if pullToRefresh {
            pullToRefreshControl = UIRefreshControl()
            pullToRefreshControl?.tintColor = UIColor.Color.blue
            pullToRefreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            addSubview(pullToRefreshControl!)
        }
    }

    @objc func refreshData() {
        print("Refresh Data")

        if helperDelegate != nil {
            pullToRefreshControl?.endRefreshing()
            helperDelegate?.didPullToRefresh!(self, refreshControl: pullToRefreshControl!)
        }
    }

    // MARK: - EmptyDataSetSource Methods

    func title(forEmptyDataSet _: UIScrollView) -> NSAttributedString? {
        let myAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.RobotoRegular(size: FontSize.regular.rawValue),
                                                          NSAttributedString.Key.foregroundColor:  self.titleColor]
        let myString = NSMutableAttributedString(string: emptyMessage.localized, attributes: myAttribute)
        return myString
    }

    func description(forEmptyDataSet _: UIScrollView) -> NSAttributedString? {
        if emptyDescription.count > 0 {
            let myAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.RobotoRegular(size: FontSize.regular.rawValue), NSAttributedString.Key.foregroundColor: descriptionColor]
            let aStr = emptyDescription.localized
            let myString = NSMutableAttributedString(string: aStr.localized, attributes: myAttribute)
            return myString
        }
        return nil
    }

    func buttonTitle(forEmptyDataSet _: UIScrollView, for _: UIControl.State) -> NSAttributedString? {
        if emptyButtonTitle.count > 0 {
            let myAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.RobotoRegular(size: FontSize.regular.rawValue),
                                                              NSAttributedString.Key.foregroundColor:  UIColor.Color.blue]
            let myString = NSMutableAttributedString(string: emptyButtonTitle.localized, attributes: myAttribute)
            return myString
        }

        return nil
    }

    func image(forEmptyDataSet _: UIScrollView) -> UIImage? {
        if let img = emptyImage {
            return img
        }
        return nil
    }

    func backgroundColor(forEmptyDataSet _: UIScrollView) -> UIColor? {
        return UIColor.clear
    }

    // MARK: - EmptyDataSetDelegate Methods
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        print("didTap button:")
        helperDelegate?.didTapEmptyView?(scrollView, didTap: button)
    }

    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        print("didTap view:")
        helperDelegate?.didTapEmptyView?(scrollView, didTap: view)
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return CGFloat(-verticalOffSet)
    }

}

