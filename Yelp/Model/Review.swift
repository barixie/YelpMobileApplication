//
//  Review.swift
//  Yelp
//
//  Created by bari on 11/18/22.
//

import Foundation
import SwiftyJSON

class Review: JSONable,Identifiable{
    
    let id : String!
    let name : String!
    let rating : Float!
    let text : String!
    let time_created : String!
    
    required init(parameter : JSON){
        id = parameter["id"].stringValue
        name = parameter["user"]["name"].stringValue
        rating = parameter["rating"].floatValue
        text = parameter["text"].stringValue
        time_created = parameter["time_created"].stringValue
    }
}

