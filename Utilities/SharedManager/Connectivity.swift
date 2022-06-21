import Foundation
import UIKit

class Connectivity {
    
    static let shared: Connectivity = Connectivity()
    
    
    private var currentConnected: Bool = true
    
    public var isConnected: Bool {
        return currentConnected
    }
    
    private init() {
        
    }
    
    public func manageInternetConnectionState() {
        
        self.currentConnected = !(reachability.connection == .unavailable)
        Logger.log("manageInternetConnectionState:: ", self.currentConnected)
        
        // Start the notifier for the internet connections.
        do {
            try reachability.startNotifier()
        } catch {
            Logger.log("Unable to start notifier")
        }
        
        reachability.whenUnreachable = { _ in
            // Internet is NOT connected.
            Logger.log("Not reachable")
            self.currentConnected = false
            AlertMesage.showInternetNotConnected(message: "Please check your network")
        }
        
        reachability.whenReachable = { _ in
            // Internet is connected.
            Logger.log("Internet Connected")
            self.currentConnected = true
        }
        
    }
    
    
//    class func isConnectedToWifi() -> Bool {
//        return ((reachability.connection != .unavailable) && (reachability.connection == .wifi))
//        //        return NetworkReachabilityManager()!.isReachableOnEthernetOrWiFi
//    }
//
//    class func isConnectedToInternet() -> Bool {
//
//        if reachability.connection == .unavailable {
//            return false
//        } else {
//            return true
//        }
//
//    }
    
}
