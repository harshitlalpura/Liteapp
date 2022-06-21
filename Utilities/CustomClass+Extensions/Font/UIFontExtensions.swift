
import Foundation
import UIKit

enum fontEnum: String {
    case RobotoBlack = "Roboto-Black"
    case RobotoBlackItalic = "Roboto-BlackItalic"
    case RobotoBold = "Roboto-Bold"
    case RobotoBoldItalic = "Roboto-BoldItalic"
    case RobotoItalic = "Roboto-Italic"
    case RobotoLight = "Roboto-Light"
    case RobotoLightItalic = "Roboto-LightItalic"
    case RobotoMedium = "Roboto-Medium"
    case RobotoMediumItalic = "Roboto-MediumItalic"
    case RobotoRegular = "Roboto-Regular"
    case RobotoThin = "Roboto-Thin"
    case RobotoThinItalic = "Roboto-ThinItalic"
    case cooper_black_regular = "Cooper Black"
    case anaktoria = "Anaktoria"
}

extension UIFont {
    
    // HOW TO USE : UIFont.OpenSansRegular(16.0)

    class func NavigationTitlefont(font:String = fontEnum.anaktoria.rawValue) -> UIFont {
        return self.fontWithName(name:font, Size: 30.0)
    }
    
    private class func fontWithName(name : String, Size : CGFloat ) -> UIFont {
      //  return UIFont(name: name, size: Size)!
        return UIFont.systemFont(ofSize:Size)
    }

    // Example font
    // Please update it
    class func RobotoRegular(size : CGFloat) -> UIFont {
        return self.fontWithName(name: fontEnum.RobotoRegular.rawValue, Size: size)
    }
    
    class func Robotolight(size : CGFloat) -> UIFont {
        return self.fontWithName(name: fontEnum.RobotoLight.rawValue, Size: size)
    }
    
    class func Robotobold(size : CGFloat) -> UIFont {
        return self.fontWithName(name: fontEnum.RobotoBold.rawValue, Size: size)
    }
    
    class func RobotoMedium(size : CGFloat) -> UIFont {
        return self.fontWithName(name: fontEnum.RobotoMedium.rawValue, Size: size)
    }
    class func CooperBlackRegular(size : CGFloat) -> UIFont {
        return self.fontWithName(name: fontEnum.cooper_black_regular.rawValue, Size: size)
    }

}

/// Enum for App Font sizes
enum FontSize: CGFloat {
    case regular26 = 26
    
    case medium22 = 22
    
    case regular18,medium18 = 18
    
    case regular = 16
    
    case light = 14
    
    case regularLarge = 20
    
    case regular12 = 12
    
    case regular10 = 13
    
    case regular31 = 31
    
    case bold21 = 21
    
    case bold28 = 35
    
    case bold35 = 36
    
    case bold42 = 42
    
    
}

extension UIFont {

    var bold: UIFont {
        return with(.traitBold)
    }

    var italic: UIFont {
        return with(.traitItalic)
    }

    var boldItalic: UIFont {
        return with([.traitBold, .traitItalic])
    }

    /// This will return the scalled font as per the native iOS setting. Please note that this will work with your custom font as well. :)
    ///
    ///     UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.heavy).scaled
    var scaled: UIFont {
        return UIFontMetrics.default.scaledFont(for: self)
    }

    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

}
