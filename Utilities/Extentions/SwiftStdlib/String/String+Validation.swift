//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 03/02/21

import Foundation
import UIKit

public extension String {
    /// Check if string contains one or more letters.
    var hasLetters: Bool {
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// Check if string contains one or more numbers.
    var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    /// Check if string contains only letters.
    var isAlphabetic: Bool {
        return hasLetters && !hasNumbers
    }
    
    /// Check if string contains at least one letter and one number.
    var isAlphaNumeric: Bool {
        return components(separatedBy: CharacterSet.alphanumerics).joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    /// Check if string contains only numbers.
    var isNumeric: Bool {
        return !hasLetters && hasNumbers
    }
    
    /// Check if string is valid Email address or not.
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: Regex.EmailRegex, options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: count)) != nil
        } catch {
            return false
        }
    }
    
    /// Check if string is valid Password or not.
    var isValidPassword: Bool {
        // length > >8-16
               // The password must contain at least three character categories among the following
               // Uppercase characters (A-Z)
               // Lowercase characters (a-z)
               // Digits (0-9)
               // Special characters (~!@#$%^&*_-+=`|(){}[]:;"'<>,.?/)

               let password = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
               let passwordRegex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[\\-_+={}<>\\[\\]().,;:\"'_~^`@$|/!%*#?&])([a-zA-Z0-9\\-_+={}<>\\[\\]().,;:\"'_~^`@$|/!%*#?&]{8,16})$"
               return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    /// Check if string starts with substring.
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    func start(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
    
    /// Check if string is https URL.
    var isHttpsUrl: Bool {
        guard start(with: "https://".lowercased()) else {
            return false
        }
        return URL(string: self) != nil
    }
    
    /// Check if string is http URL.
    var isHttpUrl: Bool {
        guard start(with: "http://".lowercased()) else {
            return false
        }
        return URL(string: self) != nil
    }
    
    /// To check valid password

    func isValidPassword(testStr: String?) -> Bool {
        guard testStr != nil else { return false }

        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
        func isValid8Charecter(testStr: String?) -> Bool {
           guard testStr != nil else { return false }
           // 8 characters total
           let passwordTest = NSPredicate(format: "SELF MATCHES %@", ".{7,}")
           return passwordTest.evaluate(with: testStr)
       }
       func isValidNumber(testStr: String?) -> Bool {
           guard testStr != nil else { return false }
           // 8 characters total
           let passwordTest = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*")
           return passwordTest.evaluate(with: testStr)
       }
        
       func isValidLowercase(testStr: String?) -> Bool {
        guard testStr != nil else { return false }
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
        return passwordTest.evaluate(with: testStr)
           
       }
       func isValidUpercase(testStr: String?) -> Bool {
           guard testStr != nil else { return false }
           // 8 characters total
           let passwordTest = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
           return passwordTest.evaluate(with: testStr)
       }
       
       func isValidSpecialCharecter(testStr: String?) -> Bool {
           guard testStr != nil else { return false }
           // 8 characters total
           let passwordTest = NSPredicate(format: "SELF MATCHES %@", ".*[!@#$%&*()_+=|<>?{}\\[\\]~-]+.*")
           return passwordTest.evaluate(with: testStr)
       }
    
}

extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x3030, 0x00AE, 0x00A9, // Special Characters
        0x1D000 ... 0x1F77F, // Emoticons
        0x2100 ... 0x27BF, // Misc symbols and Dingbats
        0xFE00 ... 0xFE0F, // Variation Selectors
        0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
            return true
            
        default: return false
        }
    }
    
    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}

extension String {
    var glyphCount: Int {
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    var isSingleEmoji: Bool {
        return glyphCount == 1 && containsEmoji
    }
    
    /// Check if string contains the Emojis or not
    ///
    /// ## HOW TO USE:
    ///     "Sample".containsEmoji // returns false
    ///
    var containsEmoji: Bool {
        return !unicodeScalars.filter { $0.isEmoji }.isEmpty
    }
    
    /// Check if string contains Only Emojis or not
    ///
    /// ## HOW TO USE:
    ///     "Sample".containsOnlyEmoji // returns false
    ///
    var containsOnlyEmoji: Bool {
        return unicodeScalars.first(where: { !$0.isEmoji && !$0.isZeroWidthJoiner }) == nil
    }
    
    // The next tricks are mostly to demonstrate how tricky it can be to determine emoji's
    // If anyone has suggestions how to improve this, please let me know
    var emojiString: String {
        return emojiScalars.map { String($0) }.reduce("", +)
    }
    
    var emojis: [String] {
        var scalars: [[UnicodeScalar]] = []
        var currentScalarSet: [UnicodeScalar] = []
        var previousScalar: UnicodeScalar?
        
        for scalar in emojiScalars {
            if let prev = previousScalar, !prev.isZeroWidthJoiner, !scalar.isZeroWidthJoiner {
                scalars.append(currentScalarSet)
                currentScalarSet = []
            }
            currentScalarSet.append(scalar)
            
            previousScalar = scalar
        }
        
        scalars.append(currentScalarSet)
        
        return scalars.map { $0.map { String($0) }.reduce("", +) }
    }
    
    fileprivate var emojiScalars: [UnicodeScalar] {
        var chars: [UnicodeScalar] = []
        var previous: UnicodeScalar?
        for cur in unicodeScalars {
            if let previous = previous, previous.isZeroWidthJoiner, cur.isEmoji {
                chars.append(previous)
                chars.append(cur)
                
            } else if cur.isEmoji {
                chars.append(cur)
            }
            
            previous = cur
        }
        
        return chars
    }
}

extension String {
    // All Regex
    struct Regex {
        static let
        
        // Email
        EmailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
        PasswordRegex: String = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,16}",
        AlphaRegex: String = "[a-zA-Z]+",
        Base64Regex: String = "(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?",
        CreditCardRegex: String = "(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})",
        HexColorRegex: String = "#?([0-9A-F]{3}|[0-9A-F]{6})",
        HexadecimalRegex: String = "[0-9A-F]+",
        ASCIIRegex: String = "[\\x00-\\x7F]+",
        NumericRegex: String = "[-+]?[0-9]+",
        FloatRegex: String = "([\\+-]?\\d+)?\\.?\\d*([eE][\\+-]\\d+)?",
        IPRegex: [String: String] = [
            "4": "(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})\\.(25[0-5]|2[0-4]\\d|1\\d{2}|\\d{1,2})",
            "6": "[0-9A-Fa-f]{1,4}"
        ],
        ISBNRegex: [String: String] = [
            "10": "(?:[0-9]{9}X|[0-9]{10})",
            "13": "(?:[0-9]{13})"
        ],
        AlphanumericRegex: String = "[\\d[A-Za-z]]+",
        WebUrl: String = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$", //"((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+", 
        
        // Credit/Debit Card Identify Regex
        Amex: String = "^3[47][0-9]{5,}$",
        Visa: String = "^4[0-9]{6,}([0-9]{3})?$",
        MasterCard: String = "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$",
        Diners: String = "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$",
        Discover: String = "^6(?:011|5[0-9]{2})[0-9]{3,}$",
        JCB: String = "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$",
        UnionPay: String = "^(62|88)[0-9]{5,}$",
        Hipercard: String = "^(606282|3841)[0-9]{5,}$",
        Elo: String = "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        
        private init() {}
    }
    
    /// This will check what if String has the maximum character length or not.
    ///
    /// ## HOW TO USE:
    ///     "Sample".checkMax(length: 12) // returns true
    ///
    /// - Parameter length: Number of max length which you wanted to check
    /// - Returns: true if string has not exceeded the max length.
    func checkMax(length: Int) -> Bool {
        let str = trimmed
        return str.count <= length
    }
    
    /// This will check what if String has the minimum character length or not.
    ///
    /// ## HOW TO USE:
    ///     "Sample".checkMin(length: 12) // returns false
    ///
    /// - Parameter length: Number of min length which you wanted to check
    /// - Returns: true if string has at least min defined length
    func checkMin(length: Int) -> Bool {
        let str = trimmed
        return str.count >= length
    }
    
    /// To check valid url
    ///
    /// ## HOW TO USE:
    ///     "Sample".isValidUrl() // returns false
    ///
    /// - Parameter text: Url string
    /// - Returns: true for valid and false
    func isValidUrl() -> Bool {
        let urlRegEx = Regex.WebUrl
        
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        
        if urlTest.evaluate(with: self) {
            return urlTest.evaluate(with: self)
        }
        
        return false
    }
}

