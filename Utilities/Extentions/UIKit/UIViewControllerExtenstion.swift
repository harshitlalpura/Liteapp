//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 13/02/21

import UIKit
import FittedSheets

extension UIViewController {

    /// This property will used to enable and disable Inreractive Pop Gesture.
    ///
    ///        enableInreractivePopGesture = false
    ///
    var enableInreractivePopGesture: Bool {
        get {
            return navigationController?.interactivePopGestureRecognizer?.isEnabled ?? false
        } set {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            navigationController?.interactivePopGestureRecognizer?.isEnabled = newValue
        }
    }

    /// presentcontroller with navigation as root
    /// - Parameter controller: UIViewController
    func presentVC(controller: UIViewController, presentStyle: UIModalPresentationStyle = .overFullScreen) {
        let navigationController = BaseNavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = presentStyle
        self.present(navigationController, animated: true, completion: nil)
    }
    
    /// presentcontroller with navigation as pop up
    /// - Parameter controller: UIViewController
    func presentPopUpVC(controller: UIViewController) {
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }

    /// push controller
    /// - Parameter controller: UIViewController
    func pushVC(controller: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(controller, animated: animated)
    }

    /// pop controller
    /// - Parameter controller: UIViewController
    func popVC(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    func poptoVC(controller:UIViewController, animated: Bool = true) {
        self.navigationController?.popToViewController(controller, animated: animated)
    }
    
    /// dimiss controller
    /// - Parameter controller: UIViewController
    func poptoDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    


    /// open bottom sheet
    /// - Parameter controller: UIViewController
    func openBottomSheet(controller: UIViewController, isVariableHeight: Bool = false,fixedHeight:CGFloat = 400) {
        var sheetController: SheetViewController?
        if isVariableHeight {
            sheetController = SheetViewController(
                controller: controller,
                sizes: [.percent(0.5), .fullscreen],
                options: SheetOptions(useInlineMode: nil))
        } else {
        sheetController = SheetViewController(controller: controller, sizes: [.fixed(fixedHeight)])
        }
        guard let sheet = sheetController else {
            return
        }
        sheet.overlayColor = UIColor.Color.gray
        sheet.gripColor = UIColor.clear
        sheet.cornerRadius = Constant.BOTTOMSHEET_RADIUS
        self.present(sheet, animated: true, completion: nil)
    }
    
    
    
    
}
extension UIViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
}
