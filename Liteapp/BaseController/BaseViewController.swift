//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 28/06/21


import UIKit
import Kingfisher

typealias CompletionHandler = (_ success:Bool) -> Void
class BaseViewController: UIViewController {
    
    
    // MARK: Controllers override methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigurationOnViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    /// set configration needed in all controller
    public func setConfigurationOnViewDidLoad(isWhiteBG: Bool = false) {
        
        setNavigationBlueTheme()
        // set navigation theme
//        if isWhiteBG {
//            setNavigationWhiteTheme()
//        } else if UDManager.isUserLogin {
//            setNavigationBlueTheme()
//        }
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Button Action Methods
    
    /// Button Action method for dismiss to view controller
    /// - Parameter sender: Object of the Button
    @IBAction func btnDismissVIewTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnPopController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    open
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }

    /// add keyboard observe for this controller to handle scroll on keyboard open
     func addKeyboardObserver() {
        NOTIFICATION_CENTER.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NOTIFICATION_CENTER.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    /// remove keyboard observe for this controller
     func removeKeyboardObserver() {
        NOTIFICATION_CENTER.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NOTIFICATION_CENTER.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }



    public func findFirstScrollableView() -> UIScrollView? {
        for view in self.view.subviews {
            if let scrollableView = view as? UIScrollView {
                return scrollableView
            }
            if let scrollableView = view as? UITableView {
                return scrollableView
            }
            if let scrollableView = view as? UICollectionView {
                return scrollableView
            }
        }
        return nil
    }

    @objc func keyboardWillShow(notification: Notification) {

    }

    @objc func keyboardWillHide(notification: Notification) {

    }
}

extension UIViewController {
    /// set blue background with white text navigation
    func setNavigationBlueTheme() {
        self.navigationController?.navigationBar.setNavigationBar(background: UIColor.Color.themebg, text: .white)

        (navigationController as? BaseNavigationController)?.statusBarStyle = .lightContent
        
      /*if #available(iOS 15, *){
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.Color.themebg
            appearance.titleTextAttributes = [.font:
                                                UIFont.boldSystemFont(ofSize: 20.0),
                                      .foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationBar.isTranslucent = false
        }*/
        
    }
//    func setFont(font:UIFont = UIFont.NavigationTitlefont())
//    {
//        if #available(iOS 14, *){
//             let appearance = UINavigationBarAppearance()
//             appearance.configureWithOpaqueBackground()
//             appearance.backgroundColor = UIColor.Color.themebg
//             appearance.titleTextAttributes = [NSAttributedString.Key.font: font ,NSAttributedString.Key.foregroundColor: UIColor.Color.green]
//             self.navigationController?.navigationBar.standardAppearance = appearance
//             self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//             self.navigationController?.navigationBar.isTranslucent = false
//        }else{
//            self.navigationController?.navigationBar.titleTextAttributes =
//                [NSAttributedString.Key.font: font ,NSAttributedString.Key.foregroundColor: UIColor.Color.green]
//        }
//    }
    /// set white background with black text navigation
    func setNavigationWhiteTheme() {
        self.navigationController?.navigationBar.setNavigationBar(background: UIColor.Color.white, text: UIColor.Color.white)

        (navigationController as? BaseNavigationController)?.statusBarStyle = .lightContent
    }

    /// set white background with black text navigation
    func setNavigationTransperentTheme() {
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.Color.white
        self.navigationController?.navigationBar.tintColor = UIColor.Color.white
        var attrs = [NSAttributedString.Key: Any]()
        attrs[.font] = UIFont.RobotoRegular(size: FontSize.regularLarge.rawValue)
        attrs[.foregroundColor] = UIColor.Color.white
        self.navigationController?.navigationBar.titleTextAttributes = attrs
        (navigationController as? BaseNavigationController)?.statusBarStyle = .darkContent
    }
    func downloadImage(with urlString : String , imageCompletionHandler: @escaping (UIImage?) -> Void){
            guard let url = URL.init(string: urlString) else {
                return  imageCompletionHandler(nil)
            }
            let resource = ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    imageCompletionHandler(value.image)
                case .failure:
                    imageCompletionHandler(nil)
                }
            }
     }
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.Robotobold(size:24)]
        let range = (string.lowercased() as NSString).range(of: boldString.lowercased())
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
      
    }
    func getTime()->String{
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12 : return "Morning"
        case 12..<17 : return "Afternoon"
        case 17..<23 : return "Evening"
        default: return "Evening"
        }
       
    }
    class var storyboardID: String {
        return "\(self)"
    }

    static func instantiate(fromStoryboard: StoryboardName) -> Self {
        return fromStoryboard.instantiate(viewController: self)
    }
}
class SplashView:UIView{
    /// The icon image to show and reveal with
    open var logoImage: UIImage? {
        
        didSet{
            if let iconImage = self.logoImage{
                imageView?.image = iconImage
                backgroundImageView?.clipsToBounds = true
            }
        }
        
    }
    
    open var backgroundImage: UIImage? {
        
        didSet{
            if let iconImage = self.backgroundImage{
                backgroundImageView?.image = iconImage
                backgroundImageView?.clipsToBounds = true
            }
        }
        
    }
    open var text: String? {
        
        didSet{
            if let text = self.text{
                textLabel?.text = text
            }
        }
        
    }
    ///The initial size of the icon. Ideally it has to match with the size of the icon in your LaunchScreen Splash view
    open var iconInitialSize: CGSize = CGSize(width: 60, height: 60) {
        
        didSet{
            
             imageView?.frame = CGRect(x: 0, y: 0, width: iconInitialSize.width, height: iconInitialSize.height)
        }
    }
    /// The image view containing the background Image
    open var backgroundImageView: UIImageView?
    
    /// The image view containing the background Image
    open var textLabel: UILabel?
    
    /// THe image view containing the icon Image
    open var imageView: UIImageView?
    
    open var duration: Double = 0.0
    
    var labelHeight:CGFloat = 75.0
    public init(logoImage: UIImage,backgroundImage: UIImage, iconInitialSize:CGSize)
    {
        //Sets the initial values of the image view and icon view
        self.imageView = UIImageView()
        self.logoImage = logoImage
        self.iconInitialSize = iconInitialSize
        //Inits the view to the size of the screen
        super.init(frame: (UIScreen.main.bounds))
        
        imageView?.image = logoImage
        //Set the initial size and position
        imageView?.frame = CGRect(x: 0, y: 0, width: iconInitialSize.width, height: iconInitialSize.height)
        //Sets the content mode and set it to be centered
        imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        imageView?.center = CGPoint(x: self.center.x, y: self.center.y - labelHeight/2)
        
        
        //Sets the background image
        self.backgroundImageView = UIImageView()
        backgroundImageView?.image = backgroundImage
        backgroundImageView?.frame = UIScreen.main.bounds
        backgroundImageView?.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(backgroundImageView!)
        
        //Adds the icon to the view
        self.addSubview(imageView!)
        
        //Sets the background image
        self.textLabel = UILabel()
        textLabel?.text = "Learn words like a boss"
        textLabel?.frame = CGRect(x: 0, y:self.center.y + labelHeight/2.0, width: UIScreen.main.bounds.width, height: labelHeight)
        textLabel?.textAlignment = .center
        textLabel?.font = UIFont.CooperBlackRegular(size:28)
        textLabel?.textColor = .white
        self.addSubview(textLabel!)
        //Sets the background color
        self.backgroundColor = backgroundColor
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func startAnimattion(completionHandler:@escaping CompletionHandler) {
        
        imageView?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        UIView.animate(withDuration: duration,delay: 0,usingSpringWithDamping: CGFloat(0.20),initialSpringVelocity: CGFloat(8.0),options: UIView.AnimationOptions.allowUserInteraction,animations: {
            self.imageView?.transform = CGAffineTransform.identity
            self.imageView?.image = self.logoImage

            },
           completion: {_ in
            self.imageView?.image = self.logoImage
            completionHandler(true)
               self.removeFromSuperview()
           }
        )
    
    }
}
