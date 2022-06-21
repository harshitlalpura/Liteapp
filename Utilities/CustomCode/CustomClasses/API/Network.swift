import Foundation
import UIKit
//import Moya
import Alamofire
import SwiftyJSON
/*
// Glabal Data Cashing object
//let cache = Shared.dataCache
//typealias requestCompletionHandler = (UNJSONReponse) -> Void
#if DEBUG
// debug only code

//let provider = MoyaProvider<Service>(manager: APIManager.shared, plugins: [NetworkLoggerPlugin(verbose: true)])
let provider = MoyaProvider<Service>(session: APIManager.shared,
                                     plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])

#else

// release only code
let provider = MoyaProvider<Service>(session: APIManager.shared)

#endif


class APIManager: Alamofire.Session {
    
    static let shared: APIManager = {
        
        let configuration = URLSessionConfiguration.default
        //        configuration.waitsForConnectivity = true
        
        
        // The max time interval to wait between server responses before cancelling the request. All session tasks use this value, but it is really designed for tasks running on a default or ephemeral session. Tasks running on a background session will automatically be retried.
        // The default value is 4 minutes.
        configuration.timeoutIntervalForRequest = 60 * 5 // as seconds, you can set your request timeout. default 5 minutes //
        
        // This property determines the resource timeout interval for all tasks within sessions based on this configuration. The resource timeout interval controls how long (in seconds) to wait for an entire resource to transfer before giving up. The resource timer starts when the request is initiated and counts until either the request completes or this timeout interval is reached, whichever comes first.
        // The default value is 7 days.
        configuration.timeoutIntervalForResource = 604800 // 60*60*24*7 = 604800(seconds)
        
        //        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        let manager = APIManager(configuration: configuration)
        return manager // APIManager(configuration: configuration)
        
    }()
    
}




// MARK: - NETWORK Wraper class

class Network {
    
    
    /// Closure to be executed when a request has completed.
    public typealias Completion = (JSON?) -> Void
    
    
    
    static func getMetaData() -> [String: String] {
        
        return ["platform": "iOS",
                "timestamp": Utility.headerTimeStamp,
                "appVersion": Utility.appVersion ?? "1.0.0",
                "device": device.description,
              //  "deviceUniqueId": UserManager.shared.deviceID,
                "osVersion": device.systemVersion ?? "0.0"]
        
    }
    
    // ----------
 
    @discardableResult
    class func request(_ target: Service, isShowLoader: Bool = true, showError: Bool = true, completion: @escaping Completion) -> Cancellable? {
        
        if !Connectivity.shared.isConnected {
            AlertMesage.showInternetNotConnected(message: "Please check your network")
            completion(nil)
            return nil
        }
        
        print("==== URL ===== \(target.baseURL)")
        print("==== PATH ==== \(target.path)")
        print("==== METHOD ==== \(target.method.rawValue)")
        print("==== HEADER ==== \(target.headers ?? [:])")
        print("==== PARAMETER ==== \(target.task)")
       
        
        if isShowLoader {
            // show loader here
            ProgressHUD.show()
        }
        
        return provider.request(target) { (result) in
            
            if isShowLoader {
                // hide loader here
                ProgressHUD.hide()
            }
            switch result {
            case .success(let response):
                Logger.log(response.statusCode)
                
                let json: JSON? = try? JSON(data: response.data)
                Logger.log(json ?? "--NA--")
                
                switch response.statusCode {
                case 200...300:
                    // ✅ - Success Response
                    guard let aResponse = json?.dictionary else {
                        // 🚨 Unable to fetch dictionary response.
                        if showError {
                            AlertMesage.show(.error, message: Localizable.info.tryAfterSometime)
                        }
                        completion(nil)
                        return
                    }
                    
                    if let aDictData = aResponse[API.Response.data]?.dictionary, !aDictData.isEmpty {
                        // Dictionary Data is received from the server.
                        completion(json)
                    } else if (aResponse[API.Response.status]?.int) != nil {
                        // Array Data is received from the server.
                        completion(json)
                    } else if let aArrData = aResponse[API.Response.extraMeta]?.dictionary, !aArrData.isEmpty {
                        // Array Data is received from the server.
                        completion(json)
                    } else if let aStringData = aResponse[API.Response.data]?.string, !aStringData.isEmpty {
                        // Array Data is received from the server.
                        completion(json)
                    } else {
                        // 🚨 A blank dictionary is recevied from the server.

//                        if showError {
//                            AlertMesage.show(.error, message: Localizable.info.tryAfterSometime)
//                        }

                        if showError {
                            if let aDictextraMeta = aResponse[API.Response.extraMeta]?.dictionary, let strMessage = aDictextraMeta[API.Response.message]?.string {
                                AlertMesage.show(.error, message: strMessage)
                            }
                        }
                        completion(nil)
                    }
                    break
                    
                case 400, 402...499:
                    // ⚠️ - Error response
                    
                    guard let aResponse = json?.dictionary else {
                        // 🚨 Unable to fetch dictionary response.
                        if showError {
                            AlertMesage.show(.error, message: Localizable.info.tryAfterSometime)
                        }
                        completion(nil)
                        return
                    }
                    
                    if let aDictError = aResponse[API.Response.error]?.dictionary, let strMessage = aDictError[API.Response.message]?.string {
                        // Display message to the user.
                        if showError {
                            AlertMesage.show(.error, message: strMessage)
                        }
                    } else {
                        // 🚨 A blank dictionary is recevied from the server.
                        if showError {
                            AlertMesage.show(.error, message: Localizable.info.tryAfterSometime)
                        }
                    }
                    completion(nil)
                    break
                case 401:
                    // 🚨 - Error response from the server.
                    // -- Possible cases
                    // - Authentication token is no longer valid. Please ask the user to login again in the application.
                    
                    // -- Cancel all the active task if there are any!
                    APIManager.shared.session.getAllTasks(completionHandler: { (arrAllTasks) in
                        for aTask in arrAllTasks {
                            aTask.cancel()
                        }
                    })
                    
                    UIAlertController.showAlertWithOkButton(controller: Utility().topMostController(), message: Localizable.AlertMsg.sessionExpired) { (_, _) in
                        // Move to Login screen directly as user's previous login is expired.
                      //  UserManager.shared.removeUser()
                        Utility.setRootScreen()
                    }
                    completion(nil)
                    break
                    
                default:
                    // ⚠️ - Something un-expected just received.
                    completion(nil)
                    break
                }
                
            case .failure(let error):
                // 🚨 - Failed to execute the request.
                if showError {
                    AlertMesage.show(.warning, message: error.localizedDescription)
                }
                completion(nil)
            }
            
        } as Cancellable

    }
}

enum Results<Value> {
    case success(Value)
    case error(Value)
    case failure(Error)
}


struct MyError: LocalizedError, Equatable {
    
    private var description: String!
    
    init(description: String) {
        self.description = description
    }
    
    var errorDescription: String? {
        return description
    }
    
    public static func ==(lhs: MyError, rhs: MyError) -> Bool {
        return lhs.description == rhs.description
    }
    
}

extension MyError {
    
    static let noConnection = MyError(description: NSLocalizedString("No internet connection",comment: ""))
    
    static let requestCancelled = MyError(description: NSLocalizedString("Request Cancelled",comment: ""))
    
    static let requestFailed = MyError(description: NSLocalizedString("Request failed",comment: ""))
    
    static let somethingWentWrong = MyError(description: NSLocalizedString("Something went wrong. Please try again later",comment: ""))

}
*/
