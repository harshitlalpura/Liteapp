//
//  MerchantCode.swift
//  Liteapp
//
//  Created by Navroz Huda on 10/06/22.
//

import Foundation

import Foundation
import ObjectMapper

class MerchantCodeData: Mappable {

    var status: NSNumber?
    var data: [MerchantCode]?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
    }
}

class MerchantCode: Mappable {

    var merchantId: NSNumber?
    var merchantName: String?
    var total: NSNumber?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        merchantId <- map["merchant_id"]
        merchantName <- map["merchant_name"]
        total <- map["total"]
    }
}
