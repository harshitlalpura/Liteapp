//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 03/02/21

import Foundation
import UIKit

extension String {
    /// This method will check that if the string is Empty / Blank or not.
    ///
    ///     "This is your String!".isBlank      // Returns false
    ///
    var isBlank: Bool {
        return trimmed.isEmpty
    }

    /// Remove Whitespace from string.
    ///
    ///     " This is your String! ".trimWhitespace     // Returns This is your String!
    ///
    var trimWhitespace: String {
        let trimmedString = trimmingCharacters(in: .whitespaces)
        return trimmedString
    }

    /// String with no spaces or new lines in beginning and end.
    ///
    ///     "This is your String!\n ".isBlank      // Returns This is your String!
    ///
    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// String decoded from NSAttributedStringase64  (if applicable).
    var base64Decoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        guard let decodedData = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: decodedData, encoding: .utf8)
    }

    /// String encoded in base64 (if applicable).
    var base64Encoded: String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }

    /// This method will replace the string with other string.
    ///
    /// - Parameters:
    ///   - string: String which you wanted to replace.
    ///   - withString: String by which you want to replace 1st string.
    /// - Returns: Returns new string by replacing string
    func replace(string: String, withString: String) -> String {
        return replacingOccurrences(of: string, with: withString)
    }
    
    /// Double value from string (if applicable).
    var double: Double? {
        let formatter = NumberFormatter()
        return formatter.number(from: self) as? Double
    }

    /// Double value from string (if applicable).
    var doubleZeroDecimal: Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self) as? Double
    }

    /// Integer value from string (if applicable).
    var int: Int? {
        return Int(self)
    }

    /// URL from string (if applicable).
    var url: URL? {
        return URL(string: self)
    }

    /// Get length of string
    ///
    ///     let phrase = "The rain in Spain"
    ///     print(phrase.length)
    ///
    var length: Int {
        return count
    }

    /// Leading and Tralling from spaces from string
    ///
    /// - Returns: Update trimmed string
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    /// To triming / removing particular character
    ///
    /// - Parameter char: Character to trim
    /// - Returns: Updated string
    func trim(char: Character) -> String {
        return trimmingCharacters(in: CharacterSet(charactersIn: "\(char)"))
    }

    /// To triming / removing string
    ///
    /// - Parameter charsInString: String to trim
    /// - Returns: Updated string
    func trim(charsInString: String) -> String {
        return trimmingCharacters(in: CharacterSet(charactersIn: charsInString))
    }
    
    /// Convert json string to json object
    ///
    /// - Parameter
    /// - Returns: Json Object
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    
    
    
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
extension String {
    static var bullet: String {
        return "  •  "
    }
    func toDate(format: String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
    func toLocalDate(format:String) -> Date {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = format
         dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
         let date = dateFormatter.date(from: self)
         return date ?? Date()
    }
    func getDate() -> String? {
      
        let formatter = DateFormatter()
        formatter.dateFormat = DateTimeFormat.wholedateTime.rawValue
        let date = formatter.date(from: self) ?? Date()
        let str = Date().offset(from:date)
        return "\(str)"
    }
}
extension Date {
    
    
    func toString(format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self) 
    }
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date, tillMonth:Bool = false) -> String {
        if tillMonth{
            if years(from: date)  >= 1 || months(from: date) >= 1{
                return date.toString(format:DateTimeFormat.MMM_dd_yyyy.rawValue)
            }
        }else{
            if years(from: date)   > 1 {
                return "\(years(from: date)) Years ago"
            }else if  years(from: date) == 1 {
                return "\(years(from: date)) Year ago"
            }
            
            if months(from: date)  > 1 { return "\(months(from: date)) Months ago"  }
            else if  months(from: date) == 1 {
                return "\(months(from: date)) Month ago"
            }
        }
        if weeks(from: date)   > 1 { return "\(weeks(from: date)) Weeks ago"   }
        else if  weeks(from: date) == 1 {
            return "\(weeks(from: date)) Week ago"
        }
        
        if days(from: date)  > 1 { return "\(days(from: date)) Days ago"    }
        else if  days(from: date) == 1 {
            return "\(days(from: date)) Day ago"
        }
        
        if hours(from: date)   > 1 { return "\(hours(from: date)) Hours ago"   }
        else if  hours(from: date) == 1 {
            return "\(hours(from: date)) Hour ago"
        }
        if minutes(from: date) > 1 { return "\(minutes(from: date)) Minutes ago" }
        else if  minutes(from: date) == 1 {
            return "\(minutes(from: date)) Minute ago"
        }
        
        if seconds(from: date) > 1 { return "\(seconds(from: date)) Seconds ago" }
        else if  seconds(from: date) == 1 {
            return "\(seconds(from: date)) Second ago"
        }
        return ""
    }
}
