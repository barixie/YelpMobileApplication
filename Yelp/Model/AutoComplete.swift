//
//  AutoComplete.swift
//  Yelp
//
//  Created by bari on 11/19/22.
//

import Foundation
import SwiftyJSON

class AutoComplete: JSONable{
    
    let categories : [JSON]!
    let term : [JSON]!
    
    required init(parameter : JSON){
        categories = parameter["categories"].arrayValue
        term = parameter["terms"].arrayValue
    }
    
    init(){
        categories = [JSON({})]
        term = [JSON({})]
    }
}
