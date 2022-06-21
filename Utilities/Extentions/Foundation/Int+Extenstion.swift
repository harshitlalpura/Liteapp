//
//  Int+Extenstion.swift
//  
//
//   on 13/07/20.
//  Copyright © 2020  Ltd. All rights reserved.
//

import Foundation

extension Int {

    func timeString() -> String {

//        let hour = Int(self) / 3600
        let minute = Int(self) / 60 % 60
        let second = Int(self) % 60

        // return formated string
//        return String(format: "%02i:%02i:%02i", hour, minute, second)

        return String(format: "%02i:%02i", minute, second)

    }

    func formatUsingAbbrevation () -> String? {
        let numFormatter = NumberFormatter()

        typealias Abbrevation = (threshold: Double, divisor: Double, suffix: String)
        let abbreviations: [Abbrevation] = [(0, 1, ""),
                                           (1000.0, 1000.0, "K"),
                                           (100_000.0, 1_000_000.0, "M"),
                                           (100_000_000.0, 1_000_000_000.0, "B")]
                                           // you can add more !
        let startValue = Double(abs(self))
        let abbreviation: Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()

        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1

        return numFormatter.string(from: NSNumber(value: value))
    }

}

extension Int {

    func getLikeCountWith(name: String) -> String {

        if self > 0 {
            if self == 1 {
                return name
            } else if let strLiked = (self-1).formatUsingAbbrevation() {
                var strTitle = name + " + " + strLiked
                if self == 2 {
                    strTitle += " other"
                } else {
                    strTitle += " others"
                }
                return strTitle
            }
        }

        return "No Likes"

    }

    func getLikeCountString() -> String {

        if self > 0 {
            if self == 1 {
                return "1 Like"
            } else if let strLiked = self.formatUsingAbbrevation() {
                return strLiked + " Likes"
            }
        }

        return "No Likes"

    }

    func getCommentCountString() -> String {

        if self > 0 {
            if self == 1 {
                return "1 Comment"
            } else if let strLiked = self.formatUsingAbbrevation() {
                return strLiked + " Comments"
            }
        }

        return "No Comments"

    }

}

// how to use:
// let testValue:[Int] = [598, -999, 1000, -1284, 9940, 9980, 39900, 99880, 399880, 999898, 999999, 1456384, 12383474]
//
// testValue.forEach() {
//    print ("Value : \($0) -> \($0.formatUsingAbbrevation())")
// }

/////
// Result :
// Value : 598 -> 598
// Value : -999 -> -999
// Value : 1000 -> 1K
// Value : -1284 -> -1.3K
// Value : 9940 -> 9.9K
// Value : 9980 -> 10K
// Value : 39900 -> 39.9K
// Value : 99880 -> 99.9K
// Value : 399880 -> 0.4M
// Value : 999898 -> 1M
// Value : 999999 -> 1M
// Value : 1456384 -> 1.5M
// Value : 12383474 -> 12.4M
