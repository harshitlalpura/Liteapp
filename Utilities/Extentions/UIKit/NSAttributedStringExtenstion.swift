//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 05/03/21

import UIKit

// MARK: - Properties
public extension NSAttributedString {

    #if os(iOS)
    /// Bolded string.
    ///
    ///     var attributedString = NSAttributedString.init(string: "test")
    ///     attributedString = attributedString.bolded
    ///
    var bolded: NSAttributedString {
        return applying(attributes: [.font: UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif

    /// Underlined string.
    ///
    ///     var attributedString = NSAttributedString.init(string: "test")
    ///     attributedString = attributedString.underlined
    ///
    var underlined: NSAttributedString {
        return applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }

    #if os(iOS)
    /// Italicized string.
    ///
    ///     var attributedString = NSAttributedString.init(string: "test")
    ///     attributedString = attributedString.italicized
    ///
    var italicized: NSAttributedString {
        return applying(attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif

    /// Struckthrough string.
    ///
    ///     var attributedString = NSAttributedString.init(string: "test")
    ///     attributedString = attributedString.struckthrough
    ///
    var struckthrough: NSAttributedString {
        return applying(attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }

    /// Shadow string.
    ///
    ///     var attributedString = NSAttributedString.init(string: "test")
    ///     attributedString = attributedString.shadow
    ///
    var shadow: NSAttributedString {
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
        return applying(attributes: [ NSAttributedString.Key.shadow: myShadow ])
    }

    /// Dictionary of the attributes applied across the whole string
    ///
    ///     attributedString.attributes
    ///
    var attributes: [NSAttributedString.Key: Any] {
        guard self.length > 0 else { return [:] }
        return attributes(at: 0, effectiveRange: nil)
    }

}

// MARK: - Methods
public extension NSAttributedString {

    /// Applies given attributes to the new instance of NSAttributedString initialized with self object
    ///
    /// - Parameter attributes: Dictionary of attributes
    /// - Returns: NSAttributedString with applied attributes
    fileprivate func applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = (string as NSString).range(of: string)
        copy.addAttributes(attributes, range: range)

        return copy
    }

    #if os(macOS)
    /// Add color to NSAttributedString.
    ///
    ///     var attributedString = NSAttributedString.init(string: "test .")
    ///     attributedString = attributedString.colored(with: .red)
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    func colored(with color: NSColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    #else
    /// Add color to NSAttributedString.
    ///
    ///     var attributedString = NSAttributedString.init(string: "test .")
    ///     attributedString = attributedString.colored(with: .red)
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    func colored(with color: UIColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    #endif

    /// Add Font to NSAttributedString.
    ///
    ///     var attributedString = NSAttributedString.init(string: "test.")
    ///     attributedString = attributedString.font(with: UIFont.systemFont(ofSize: 12))
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString colored with given color.
    func font(with font: UIFont) -> NSAttributedString {
        return applying(attributes: [.font: font])
    }

    /// Apply attributes to substrings matching a regular expression
    ///
    ///     let myAttribute = [ NSAttributedStringKey.backgroundColor: UIColor.yellow ]
    ///     attributedString = attributedString.applying(attributes: myAttribute, toRangesMatching: "test")
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - pattern: a regular expression to target
    /// - Returns: An NSAttributedString with attributes applied to substrings matching the pattern
    func applying(attributes: [NSAttributedString.Key: Any], toRangesMatching pattern: String) -> NSAttributedString {
        guard let pattern = try? NSRegularExpression(pattern: pattern, options: []) else { return self }

        let matches = pattern.matches(in: string, options: [], range: NSRange(0..<length))
        let result = NSMutableAttributedString(attributedString: self)

        for match in matches {
            result.addAttributes(attributes, range: match.range)
        }

        return result
    }

    /// Apply attributes to occurrences of a given string
    ///
    /// - Parameters:
    ///   - attributes: Dictionary of attributes
    ///   - target: a subsequence string for the attributes to be applied to
    /// - Returns: An NSAttributedString with attributes applied on the target string
    func applying<T: StringProtocol>(attributes: [NSAttributedString.Key: Any], toOccurrencesOf target: T) -> NSAttributedString {
        let pattern = "\\Q\(target)\\E"
        return applying(attributes: attributes, toRangesMatching: pattern)
    }

}

// MARK: - Operators
public extension NSAttributedString {

    /// Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: NSAttributedString to add.
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        lhs = ns
    }

    /// Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: NSAttributedString to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        return NSAttributedString(attributedString: ns)
    }

    /// Add a NSAttributedString to another NSAttributedString.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add to.
    ///   - rhs: String to add.
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// Add a NSAttributedString to another NSAttributedString and return a new NSAttributedString instance.
    ///
    /// - Parameters:
    ///   - lhs: NSAttributedString to add.
    ///   - rhs: String to add.
    /// - Returns: New instance with added NSAttributedString.
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
}

extension NSAttributedString {

    /// Get height of the string for given attributed string
    ///
    /// - Parameter width: width of the label
    /// - Returns: expected height for the given string
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    /// Get width of the string for given attributed string
    ///
    /// - Parameter width: height of the label
    /// - Returns: expected width for the given string
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }

    /// Add line space to NSAttributedString
    ///
    /// - Parameter space: The distance in points between the bottom of one line fragment and the top of the next.
    /// - Returns: a NSAttributedString after applying line space
    func lineSpace(of space: CGFloat, alignment: NSTextAlignment = .center) -> NSAttributedString {

        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()

        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = space // Whatever line spacing you want in points

        // *** set Text Allignment ***
        paragraphStyle.alignment = alignment

        // *** Apply attribute to string ***
        return applying(attributes: [.paragraphStyle: paragraphStyle])

    }
}
public extension NSAttributedString {

    static func emptryDataTitle(_ string: String) -> NSAttributedString {

        var attributedString = NSMutableAttributedString(string: string)
        attributedString = attributedString.font(with: UIFont.RobotoRegular(size: FontSize.regularLarge.rawValue)) as! NSMutableAttributedString
        attributedString = attributedString.colored(with: UIColor.Color.blue) as! NSMutableAttributedString
        attributedString = attributedString.lineSpace(of: 10.0) as! NSMutableAttributedString
        return attributedString

    }

    static func emptryDataMessage(_ string: String) -> NSAttributedString {

        var attributedString = NSMutableAttributedString(string: string)
        attributedString = attributedString.font(with: UIFont.RobotoRegular(size: FontSize.regularLarge.rawValue)) as! NSMutableAttributedString
        attributedString = attributedString.colored(with: UIColor.Color.white) as! NSMutableAttributedString
        attributedString = attributedString.lineSpace(of: 10.0) as! NSMutableAttributedString
        return attributedString

    }

}
