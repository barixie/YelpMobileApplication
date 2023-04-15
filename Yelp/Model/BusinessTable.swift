//
//  BusinessTable.swift
//  Yelp
//
//  Created by bari on 11/15/22.
//

import Foundation
import SwiftyJSON

protocol JSONable {
    init?(parameter: JSON)
}

class BusinessTable: JSONable,Identifiable{
    
    let id : String!
    let name : String!
    let rating : Float!
    let distance : Float!
    let image_url : String!
    
    required init(parameter : JSON){
        id = parameter["id"].stringValue
        name = parameter["name"].stringValue
        rating = parameter["rating"].floatValue
        distance = parameter["distance"].floatValue
        image_url = parameter["image_url"].stringValue
    }
}

