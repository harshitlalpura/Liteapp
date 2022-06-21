import Foundation
//import Moya
import Alamofire
import SwiftyJSON
import UIKit


// 1:
// MARK: - API Services
/*
enum Service {
    
    
    // -- User Login
    
    // Login user to the application.
    case login(param: [String: Any])
    
    // get dashboard data
    case dashboad(param: [String: Any])
    
    // create event
    case createevent(param: [String: Any])
    
    // timesheet correction
    case timesheetCorrect(param: [String: Any])
    
    
    // get event data
    case gettimelie(param: [String: Any])
    
    case getSplashScreen(param: [String: Any])
}


// 2:
extension Service: TargetType {
    
    /// The type of HTTP task to be performed.
    var task: Task {
        
        switch self {
        
        case .login(let param),
             .createevent(let param),
             .gettimelie(let param),
             .timesheetCorrect(let param),
             .dashboad(let param),
             .getSplashScreen(let param):

        return .requestParameters(parameters: param, encoding: JSONEncoding.default)
     
        }
    }
    
    /// The target's base `URL`.
    var baseURL: URL {
        
        if let url = URL(string: API.URL.BASE_URL) {
            return url
        }
        fatalError("UNABLE TO CREATE URL FOR API CALL")
    }
    
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        
        switch self {
        
        // User Login Registration
        case .login:
            return "webservices/login"
            
        case .dashboad:
            return "webservices/dashboard"
            
        case .createevent:
            return "webservices/createevent"
            
        case .gettimelie:
            return "webservices/timelinebydate"
            
        case .timesheetCorrect:
            return "webservices/corrections"

        case .getSplashScreen:
            return "webservices/merchant"
      
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        
        switch self {
        
        default:
            return .post
        }
    }
    
    /// Provides stub data for use in testing.
    var sampleData: Data {
        return Data()
    }
    
    /// The headers to be used in the request.
    var headers: [String: String]? {
        

        return ["Content-Type": "application/json"] //+ aDictMetaData
    }
    
    func uploadTask(param: [String: Any]) -> Task {
        
        var arrBodyData: [Moya.MultipartFormData] = []
        for (key, value) in param {
            if let img = value as? UIImage {
                if let data: Data = img.jpegData(compressionQuality: 0.8) {
                    let strImageName = "thumbImage_\(Utility.timestamp).jpeg"
                    
                    arrBodyData.append(MultipartFormData(provider: .data(data), name: key, fileName: strImageName, mimeType: MimeType.ImageJPG.type))
                }
            } else if let aUrl = value as? URL {
                if let videoData = try? Data(contentsOf: aUrl) {
                    
                    let lastpath = aUrl.lastPathComponent.lowercased()
                    
                    arrBodyData.append(MultipartFormData(provider: .data(videoData), name: key, fileName: lastpath, mimeType: aUrl.mimeType()))
                }
            } else {
                arrBodyData.append(MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key))
            }
        }
        return .uploadMultipart(arrBodyData)
    }
}
*/

