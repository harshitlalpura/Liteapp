//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 03/02/21

import Foundation
import UIKit

extension String {
    /// This will get the Localization String from the string file based on the current language
    ///
    ///        "Your String".localized -> "Localized string from the file" // second week in the current year.
    ///
    var localized: String {
        let strLang: String? = "en"

        // Get the Path for the String file based on language selction
        guard let path = MAIN_BUNDLE.path(forResource: strLang, ofType: "lproj") else {
            return self
        }

        // Get the Bundle Path
        let langBundle = Bundle(path: path)

        // Get the Local String for Key and return it
        return langBundle?.localizedString(forKey: self, value: "", table: nil) ?? self
    }
}
