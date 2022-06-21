import Alamofire
import UIKit

@objc protocol BaseTableViewDelegate {
    @objc optional func didPullToRefresh(_ tableView: BaseTableView, refreshControl: UIRefreshControl) -> Void

    @objc optional func didTapEmptyView(_ emptyView: UIScrollView, didTap view: UIView) -> Void

    @objc optional func didTapEmptyButton(_ emptyView: UIScrollView, didTap button: UIView) -> Void
}

class BaseTableView: UITableView, EmptyDataSetSource, EmptyDataSetDelegate {
    var pullToRefreshControl: UIRefreshControl?

    public weak var helperDelegate: BaseTableViewDelegate?

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
                                                          NSAttributedString.Key.foregroundColor:  UIColor.Color.blue ]
        let myString = NSMutableAttributedString(string: emptyMessage.localized, attributes: myAttribute)
        return myString
    }

    func description(forEmptyDataSet _: UIScrollView) -> NSAttributedString? {
        if emptyDescription.count > 0 {
            let myAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.RobotoRegular(size: FontSize.regular.rawValue), NSAttributedString.Key.foregroundColor: descriptionColor]
            var aStr = emptyDescription.localized
            if !(NetworkReachabilityManager()?.isReachable ?? true) {
                aStr = "Please check your network"
            }
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
        if !(NetworkReachabilityManager()?.isReachable ?? true) {
            return PlaceHolderImages.noInternetConnection
        } else if let img = emptyImage {
            return img
        }

        return nil
    }


    func backgroundColor(forEmptyDataSet _: UIScrollView) -> UIColor? {
        return UIColor.clear
    }

    func customView(forEmptyDataSet _: UIScrollView) -> UIView? {
        return nil
    }

    /// Asks the data source for a vertical space between elements. Default is 11 pts.
    func spaceHeight(forEmptyDataSet _: UIScrollView) -> CGFloat {
        return 10.0
    }

    // MARK: - EmptyDataSetDelegate Methods

    func emptyDataSetShouldAllowTouch(_: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldFade(in _: UIScrollView) -> Bool {
        return true
    }

    func emptyDataSetShouldAllowScroll(_: UIScrollView) -> Bool {
        return false
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
