//
//  ReservationItem.swift
//  Yelp
//
//  Created by bari on 11/20/22.
//

import Foundation

struct ReservationItem: Codable,Hashable{
    var name: String
    var date : String
    var time : String
    var email : String
}
