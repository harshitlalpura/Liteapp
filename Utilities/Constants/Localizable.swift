import UIKit

struct Localizable {
    struct validation {
        static let comment = "Enter your comment" // = "Enter valid Email or Phone Number to continue!";

        
        static let noTimeSheet = "No timesheet found" // = "Enter valid Email or Phone Number to continue!";
        
        static let correctionStatus = "Select correction status" // = "Enter valid Email or Phone Number to continue!";
        
        static let corectTime = "Select correction time" // = "Enter valid Email or Phone Number to continue!";
        
        static let correctionDate = "Select correction date" // = "Enter valid Email or Phone Number to continue!";

        
        static let username = "Enter user to contine" // = "Enter valid Email or Phone Number to continue!";

        
        static let validEmail = "Enter valid email to contine" // = "Enter valid Email or Phone Number to continue!";
        
        
        static let validpassword = "Enter password to contine" // = "Enter valid Email or Phone Number to continue!";
        
    }
    
    struct Clockin {
        static let totalHours = "Total".localized
        static let clockedout = "You are clocked out".localized
        static let clockedin  = "You are clocked in".localized
        static  let btnCheckin = "CLOCK IN".localized
        static  let btnCheckout = "CLOCK OUT".localized
        static  let btnStartBreak = "START BREAK".localized
        static  let btnEndreak = "END BREAK".localized
        
        static  let clokcin = "You are clocked in!".localized
        static  let clokcout = "You are clocked out!".localized
        
        
        static  let shifstart = "Shift Start".localized
        static  let breakstart = "Break Start".localized
        static  let breakend = "Break End".localized
        static  let shiftend = "Shift End".localized
        static  let totalHoursTimesheet = "Total Hours:".localized
        
        static let clockedoutAt = "You are clocked out at".localized
        static let clockedinAt = "You are clocked in at".localized
        
        static let btnInAt = "You are on break at".localized
        
        
    }
    
    //MARK:- -App AlertBtns-
    struct AlertBtns {
        static let Ok = "Ok".localized
        static let cancel = "Cancel".localized
        static let logout = "Logout".localized
        static let block = "Block".localized
        static let delete = "DELETE".localized
        static let camera = "Take Photo".localized
        static let gallery = "Choose from library".localized
        static let settings = "SETTINGS".localized
        static let confirm = "CONFIRM".localized
        static let update = "UPDATE".localized
        static let yes = "Yes".localized
        static let no = "No".localized
        static let done = "DONE".localized
        static let closeAccount = "Close Account".localized
        static let GoToSetting = "Go To Settings".localized
        static let resendOTP = "resendOTP" // "Resend OTP?"
        static let report = "Report".localized
        static let edit = "Edit".localized
        static let deletee = "Delete".localized
        static let next = "btn_next".localized
        static let save = "Save".localized
        static let discard = "Discard".localized
        static let image = "Image".localized
        static let video = "Video".localized
        static let pdf = "PDF".localized
        static let UnFollow = "Unfollow".localized
        static let Follow = "Follow".localized
    }
    struct info {
        static let tryAfterSometime = "Unexpected error occurred while processing your request. Pelase try after again."

    }
    
    //MARK:- -Constant Message Declaration-
    struct AlertMsg {
        static let sessionExpired = "Your session has expired. Please sign in again.".localized
        

        static let selectPhoto = "selectPhoto".localized
        static let selectOptions = "selectOptions".localized
        static let needPhotoAccess = "needPhotoAccess".localized
        static let needCameraAccess = "needCameraAccess".localized
    }

    struct EmptyDataSet {
        static let noRecordFound = "str-no-record-found"
        static let tryAgain = "str-try-again"
        static let feeds = "str-emptyData-feeds"
        static let investment = "str-emptyData-investment"
        static let teamMembers = "str-emptyData-teamMembers"
        static let myVideos = "str-emptyData-myVideos"
        static let myPages = "str-emptyData-mypage"
        static let meetings = "str-emptyData-meetings"
        static let investors = "str-emptyData-investors"
        
    }
    
    
}
