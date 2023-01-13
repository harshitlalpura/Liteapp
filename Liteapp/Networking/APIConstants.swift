//
//  APIConstants.swift
//  Mood
//
//  Created by H-L01071 on 7/26/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import UIKit

class APIConstants: NSObject {
 
    enum type {
        case development
        case qa
        case production
        case local
    }
    //Change application running mode type here

    static let applicationMode: APIConstants.type = .production

    /// Application base url
    static var baseURL: String{
        
        switch APIConstants.applicationMode {
        case .production:
            return APIConstants.productionUrls.baseURL
        case .qa:
            return APIConstants.qaUrls.baseURL
        case .development:
            return APIConstants.developmentUrls.baseURL
        case .local:
            return APIConstants.localUrls.baseURL
        }
    }
    
    
    struct localUrls {
        static let baseURL = "https://lite.testbryteportal.com/"
        
    }
    struct productionUrls {
        static let baseURL = "https://lite.getilluminate.io/"
        
    }
    struct developmentUrls {
        static let baseURL = "https://lite.testbryteportal.com/"
       
    }
    struct qaUrls {
        static let baseURL = "https://lite.testbryteportal.com/"
        
    }
}

