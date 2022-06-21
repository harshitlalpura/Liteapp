//
//  Created by Navroz Huda
//  Copyright © Bryte All rights reserved.
//  Created on 02/11/20

import Foundation
import UIKit




enum DateTimeFormat: String {
    case wholeWithZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case time = "h:mm a"
    case h_mm = "h:mm"
    case a = "a"
    case yyyyMMdd = "yyyy/MM/dd"
    case dateTime = "dd MMM \n h:mm a"
    case dd_MM_yy = "dd,MM,yy"
    case MM_dd_yy = "MMM,dd,yyyy"
    case wholedateTime = "yyyy-MM-dd HH:mm:ss"
    case yyyy_MM_dd = "yyyy-MM-dd"
    case dd = "dd"
    case EEEMMMdd = "EEE. MMM dd"
    case MM_dd_yyyy = "MM / dd / yyyy"
    case dd_MM_yyyy = "dd-MM-yyyy"
    case ddMMyyyy = "dd/MM/yyyy"
    case dd_MMMM_yyyy = "dd MMMM yyyy"
    case hh_mm_ss = "HH:mm:ss"
    case hh_mm = "hh/mm"
    case MMMM_dd_yyyy = "MMMM dd, yyyy"
    
    case MM_DD_YYYY = "MM/dd/yyyy"
    case EEEE = "EEEE"
    case MM_yyyy = "MM/yyyy"
    

    case MMM_dd_yyyy = "MMM dd, yyyy"
    case MMMM_yyyy = "MMMM yyyy"


}


public enum RegistationType: String {

    case normal
    case facebook
    case linkedin
    case apple
}



enum MimeType {

    case VideoMP4
    case VideoMOV
    case ImageJPG

    var type: String {
        switch self {
        case .VideoMP4:
            return "video/mp4"
        case .VideoMOV:
            return "video/quicktime"
        case .ImageJPG:
            return "image/jpeg"
        }
    }
}

/// check  in chekcout status
enum UserStatus: String {
    case loggedIN = "I"
    case loggedOut = "O"
    case Inbreak = "B"
    case Endbreak = "S"
}
