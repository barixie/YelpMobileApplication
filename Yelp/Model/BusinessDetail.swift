//
//  BusinessDetail.swift
//  Yelp
//
//  Created by bari on 11/17/22.
//

import Foundation
import SwiftyJSON

class BusinessDetail: JSONable,Identifiable{
    
    let id : String!
    let name : String!
    let status : Bool!
    let category : [JSON]!
    let address : [String]!
    let display_phone : String!
    let transactions : [String]!
    let price : String!
    let url : String!
    let photos: [String]!
    let longitude : Float!
    let latitude : Float!
    
    required init(parameter : JSON){
        id = parameter["id"].stringValue
        name = parameter["name"].stringValue
        status = parameter["hours"][0]["is_open_now"].boolValue
        category = parameter["categories"].arrayValue
        address = parameter["location"]["display_address"].arrayValue.map { $0.stringValue}
        display_phone = parameter["display_phone"].stringValue
        transactions = parameter["transactions"].arrayValue.map { $0.stringValue}
        price = parameter["price"].stringValue
        url = parameter["url"].stringValue
        photos = parameter["photos"].arrayValue.map { $0.stringValue}
        longitude = parameter["coordinates"]["longitude"].floatValue
        latitude = parameter["coordinates"]["latitude"].floatValue
    }
    
    init(){
        id = ""
        name = ""
        status = false
        category = [JSON({})]
        address = [""]
        display_phone = ""
        transactions = [""]
        price = ""
        url = ""
        photos = [""]
        longitude = 0.0
        latitude = 0.0
    }
}
