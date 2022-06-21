import Foundation

//let log = SwiftyBeaver.self

class Logger {
    
    
    //    @discardableResult
    //    init() {
    //
    //        // add log destinations. at least one is needed!
    //        let console = ConsoleDestination()  // log to Xcode Console
    //
    //        #if DEBUG
    //        // debug only code
    //
    //        #else
    //        // release only code
    //
    //
    //        console.minLevel = .warning // just log  .warning & .error
    //
    //        let file = FileDestination()  // log to default swiftybeaver.log file
    //
    //        if var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
    //            url.appendPathComponent("respa_yoga_application.log")
    //            print("url :: ", url)
    //            file.logFileURL = url
    //        }
    //
    //        log.addDestination(file)
    //
    //        #endif
    //
    //
    //        // add the destinations to SwiftyBeaver
    //        log.addDestination(console)
    //
    //    }
    
    
    class func log(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, function: String = #function, line: Int = #line) {
        
        
        #if DEBUG || STAGING
        
        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
        //        let queue = Thread.isMainThread ? "UI" : "BG"
        let gFormatter = DateFormatter()
        gFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS Z"
        let timestamp = gFormatter.string(from: Date())
        
        items.forEach { item in
            //            Swift.print(">>> \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]: \(item)", separator: separator, terminator: terminator)
            Swift.print("\(timestamp) | \(fileURL) > \(function)[\(line)] : \(item)", separator: separator, terminator: terminator)
        }
        
        #endif
        
    }
    
    
}
