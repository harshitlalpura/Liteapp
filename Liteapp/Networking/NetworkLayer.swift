//
//  NetworkLayer.swift
//  Mood
//
//  Created by HOLOTEQ-D02386 on 2/29/20.
//  Copyright © 2020 Matloob. All rights reserved.
//

import UIKit
import Alamofire
//import ObjectMapper
import SwiftyJSON

typealias webApiCallResponsCompletoionHandler = (Bool, [String:AnyObject]? , Error?) -> Void
typealias PromoVideoCompletoionHandler = (Bool, [String:AnyObject]? ,Data?, Error?) -> Void

typealias webApiCallResponsCompletoionHandlerforYoutubeSearch = (Bool, [JSON]? , Error?) -> Void

class NetworkLayer: NSObject {
    
    static let sharedNetworkLayer = NetworkLayer()
    private let semaphore = DispatchSemaphore(value: 1)
    private let dispatchQueue = DispatchQueue(label: "DownloadQueue")
    let REMOTE_URL: String = "https://www.google.com"
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
   
    
    private override init() {
        
    }
    /// Check nework data is available
    /// - Parameter completionHandler: return true
    func pingHost(completionHandler: @escaping (Bool) -> Void) {
        
        if let url = URL(string: REMOTE_URL) {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            let task =  URLSession(configuration: .default)
                .dataTask(with: request) { (_, response, error) in
                    guard error == nil else {
                        print("Error:", error ?? "")
                        completionHandler(false)
                        return
                    }
                    guard (response as? HTTPURLResponse)?
                            .statusCode == 200 else {
                        print("Offline")
                        completionHandler(false)
                        return
                    }
                    print("Online")
                    completionHandler(true)
                }
            task.resume()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                print("Completed time")
                task.cancel()
                task.suspend()
            }
        }
        else {
            completionHandler(false)
        }
    }
    
    func getWebApiCallwithHeader(apiEndPoints:String,param:[String:Any]?, header:HTTPHeaders, completionHandler: @escaping webApiCallResponsCompletoionHandler){
        let urlString = apiEndPoints.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        if reachabilityManager?.isReachable ?? false {
            AF.request(urlString, method:.get, parameters:param, encoding: JSONEncoding.default, headers: header).responseJSON { response in
               // print(response.result.value)
                switch response.result {
                case let .success(value):
                    completionHandler(true, value as? [String : AnyObject], nil)
                case let .failure(error):
                    
                    completionHandler(false,nil,error)
                    break
                }
            }
        }
    }
   
    let headers: HTTPHeaders = [
        "Accept": "application/json",
        "Content-Type" : "application/json",
        "Authorization" : "",
        "version" :"1.2"
    ]
    
    func getWebApiCall(apiEndPoints:String,param:[String:Any]?, completionHandler: @escaping webApiCallResponsCompletoionHandler){
        let urlString = apiEndPoints.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        if reachabilityManager?.isReachable ?? false {
            
            AF.request(urlString, method:.get, parameters:param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                switch response.result {
                case let .success(value):
                    completionHandler(true, value as? [String : AnyObject], nil)
                case let .failure(error):
                    
                    completionHandler(false,nil,error)
                    break
                }
            }
        }
    }
    func postWebApiCall(apiEndPoints:String, param:[String:Any]?, completionHandler: @escaping webApiCallResponsCompletoionHandler){
        ProgressHUD.show()
        if reachabilityManager?.isReachable ?? false {
            AF.request(apiEndPoints, method:.post, parameters:param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                switch response.result {
                case let .success(value):
                    completionHandler(true, value as? [String : AnyObject], nil)
                    ProgressHUD.hide()
                    
                    
                case let .failure(error):
                    completionHandler(false,nil,error)
                    ProgressHUD.hide()
                    break
                }
                
            }
        }
        else{
            ProgressHUD.hide()
            AlertMesage.show(.error, message:"Internet not available" )
        }
    }
    
    func postWebApiCallwithHeader(apiEndPoints:String, param:[String:Any]?, header:HTTPHeaders, completionHandler: @escaping webApiCallResponsCompletoionHandler){
        let headerAuth:HTTPHeaders = ["Authorization":"Bearer \(Defaults.shared.currentUser?.empToken ?? "")"]
        ProgressHUD.show()
        if reachabilityManager?.isReachable ?? false {
            
            AF.request(apiEndPoints, method:.post, parameters:param, encoding: JSONEncoding.default, headers: headerAuth).responseJSON { response in
                
                switch response.result {
                case let .success(value):
                    ProgressHUD.hide()
                    completionHandler(true, value as? [String : AnyObject], nil)
                    
                    
                case let .failure(error):
                    ProgressHUD.hide()
                    completionHandler(false,nil,error)
                    break
                }
                
            }
        }
        else{
            
            
        }
    }
    
    func putWebApiCall(apiEndPoints:String, param:[String:Any]?, completionHandler: @escaping webApiCallResponsCompletoionHandler){
        if reachabilityManager?.isReachable ?? false {
            
            AF.request(apiEndPoints, method:.put, parameters:param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                switch response.result {
                case let .success(value):
                    completionHandler(true, value as? [String : AnyObject], nil)
                    
                    
                case let .failure(error):
                    completionHandler(false,nil,error)
                    break
                }
                
            }
        }
        else{
            
            
        }
    }
    func putWebApiCallwithHeader(apiEndPoints:String, param:[String:Any]?, header:HTTPHeaders, completionHandler: @escaping webApiCallResponsCompletoionHandler){
        if reachabilityManager?.isReachable ?? false {
            
            AF.request(apiEndPoints, method:.put, parameters:param, encoding: JSONEncoding.default, headers: header).responseJSON { response in
                
                switch response.result {
                case let .success(value):
                    completionHandler(true, value as? [String : AnyObject], nil)
                    
                    
                case let .failure(error):
                    completionHandler(false,nil,error)
                    break
                }
                
            }
        }
        else{
           
            
        }
    }
    func uploadImage(apiEndPoints:String,media: UIImage, params: [String:Any], fileName: String, completionHandler: @escaping webApiCallResponsCompletoionHandler){
        if reachabilityManager?.isReachable ?? false == false{
            return
        }
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(media.jpegData(
                    compressionQuality: 1.0)!,
                    withName: fileName,
                    fileName: "\(fileName).jpeg", mimeType: "image/jpeg"
                )
                for param in params {
                    let val = param.value
                    if let value = val as? String{
                        print(param.key)
                        print(value)
                        let value = value.data(using: String.Encoding.utf8)!
                        multipartFormData.append(value, withName: param.key)
                    }
                    
                }
            },
            to: apiEndPoints,
            method: .post ,
            headers: headers
        ).responseJSON { response in
            
            switch response.result {
            case let .success(value):
                completionHandler(true, value as? [String : AnyObject], nil)
                
                
            case let .failure(error):
                completionHandler(false,nil,error)
                break
            }
            
        }
    }
    func downloadFile(urlString:String,folderpath :String,progressUpdate: ((_ percent: Float) -> Void)? = nil,completionHandler:@escaping (Bool, URL?, Error?) -> ()){
        
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 240
        let urlString1 = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let fileURL = URL(string: urlString1)
        if fileURL == nil {
            return
        }
        self.dispatchQueue.async {
            
            let destination: DownloadRequest.Destination = { _, _ in
                let fileManager = FileManager.default
                let lastPathComponent = URL.init(string: urlString1)?.lastPathComponent ?? ""
                let fileNameWithExtension = lastPathComponent
                let directoryURL: URL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let folderPath: URL = directoryURL.appendingPathComponent(folderpath, isDirectory: true)
                
                if !fileManager.fileExists(atPath: folderPath.path) {
                    do {
                        try fileManager.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
                    } catch {
                        NSLog("Couldn't create document directory")
                    }
                }
                
                let desti: URL = folderPath.appendingPathComponent(fileNameWithExtension)
                return (desti, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            
            self.semaphore.wait()
            manager.download(fileURL!, to: destination).downloadProgress { (progress) in
                //self.surahNameKana.text = (String)(progress.fractionCompleted)
                progressUpdate?(Float(progress.fractionCompleted))
            }.response { response in
                print("Audio Download Response :", response.response?.statusCode ?? 0)
                print("Sucessfully saved a Audio  file  at path\(response.fileURL) error \(response.error?.localizedDescription)")
                
                self.semaphore.signal()
                
                if (response.response?.statusCode == 200) {
                    //success(response.destinationURL)
                    completionHandler(true,response.fileURL,nil)
                }else{
                    completionHandler(false,nil,nil)
                }
            }
            
        }
    }
    
 
    
    
    
    func postWebApiCallWithHeader(apiEndPoints:String,param:[String:Any]?, header:HTTPHeaders, completionHandler: @escaping webApiCallResponsCompletoionHandler){
        let urlString = apiEndPoints.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        if reachabilityManager?.isReachable ?? false {
            AF.request(urlString, method:.post, parameters:param, encoding: JSONEncoding.default, headers: header).responseJSON { response in
              
                switch response.result {
                case let .success(value):
                    completionHandler(true, value as? [String : AnyObject], nil)
                case let .failure(error):
                    
                    completionHandler(false,nil,error)
                    break
                }
            }
        }
    }
    
}
