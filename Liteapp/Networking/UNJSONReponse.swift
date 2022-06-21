//
//  EMJSONReponse.swift


import Foundation

/*
class UNJSONReponse {
    let data: Dictionary<String, AnyObject>?
    let response: URLResponse?
    var error: Error?
    var message : String?
    
    init(data: Dictionary<String, AnyObject>?, response: URLResponse?,error: Error?){
        self.data = data
        self.response = response
        self.error = error
        
        //If not error
        if (self.error == nil) {
            
            if let feedDict = data {
                
                let baseModel = EMBaseModel.init(jsonDict: feedDict)
                message = baseModel.message
                //If feed retrival is success
                if(baseModel.status != true){
                    if let message  = baseModel.message {
                        if self.HTTPResponse.statusCode != 200 {
                            self.error = NSError(domain:UNTZError.domain, code: self.HTTPResponse.statusCode, userInfo:[NSLocalizedDescriptionKey:message])
                        } else {
                            self.error = NSError(domain:UNTZError.domain, code:7777 , userInfo:[NSLocalizedDescriptionKey:message])
                        }
                    }
                }
                
            }
            
        }
    }
    
    init(error: Error? ,dataDict : NSDictionary ){
        self.data = nil
        self.response = nil
        self.error = error
    }
    
    var HTTPResponse: HTTPURLResponse! {
        return response as? HTTPURLResponse
    }
    
    var responseDict: AnyObject? {
        return data as AnyObject?
    }
    
    var responseMessage: String? {
        return message 
    }
}
class EMBaseModel {
    var status: Bool?
    var success: String?
    var message : String?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.status = jsonDict[UNAPIResponseStatusKeys.status] as? Bool
        self.message = jsonDict[UNAPIResponseStatusKeys.message] as? String
    }
}

class EMResponseModel {
    
    var status: Bool?
    var success: String?
    var message : String?
    var data : Dictionary<String,AnyObject>?
    var tokenData : Dictionary<String,AnyObject>?
    
    init(jsonDict: Dictionary<String, AnyObject>) {
        
        self.status = jsonDict[UNAPIResponseStatusKeys.status] as? Bool
        self.message = jsonDict[UNAPIResponseStatusKeys.message] as? String
        
        if(self.status == true){
            data = jsonDict[UNAPIResponseStatusKeys.data] as? Dictionary<String,AnyObject>
        }
        
        if jsonDict[UNAPIResponseStatusKeys.tokenData] != nil {
            tokenData = jsonDict[UNAPIResponseStatusKeys.tokenData] as? Dictionary<String,AnyObject>
        }
        
    }
}
*/
