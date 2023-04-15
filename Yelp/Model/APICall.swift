//
//  APICall.swift
//  Yelp
//
//  Created by bari on 11/15/22.
//

import Foundation
import Alamofire
import SwiftyJSON
extension JSON {
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? JSONable.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    let object = baseObj.init(parameter: obj)
                    arrObject.append(object!)
                }
                return arrObject
            } else {
                let object = baseObj.init(parameter: self)
                return object!
            }
        }
        return nil
    }
}
class APICall{

    func SearchAPI(keyword:String ,distance:String, location:String, Auto_detect:Bool, category:String, LocationArr:[String],completion :@escaping ([BusinessTable],Bool)-> Void){
       var base_url = "https://yelp-search-angular-1007.wl.r.appspot.com/search?"
        let keyword_1 = keyword.replacingOccurrences(of: " ", with: "")
        let location_1 = location.replacingOccurrences(of: " ", with: "")
        let category_1 = category.replacingOccurrences(of: " ", with: "")
        var distanceSearch = 0
        if(Int(distance) == 0){
          distanceSearch = 10
         }
         else{
             distanceSearch = Int(distance)!*1609
         }
        base_url += "term=" + keyword_1
        base_url += "&radius=" + String(distanceSearch)
        base_url += "&categories=" + category_1
        base_url += "&auto_check=" + String(Auto_detect)
        base_url += "&Location=" + location_1
        base_url += "&longitude=" + LocationArr[1]
        base_url += "&latitude=" + LocationArr[0]
        var result:[BusinessTable] = []
        AF.request(base_url).validate().responseJSON { response in
            switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    if let businessArr = json["businesses"].to(type: BusinessTable.self){
                        result = businessArr as! [BusinessTable]
                        if (result.count > 10){
                            let result_1 = Array(result.prefix(10))
                            DispatchQueue.main.async {
                                completion(result_1,true)
                            }
                        }else{
                            DispatchQueue.main.async {
                                completion(result,true)
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        completion([],false)
                    }
            }
        }
    }
    
    func detailAPI(id:String,completion :@escaping (BusinessDetail,Bool)-> Void){
        var base_url = "https://yelp-search-angular-1007.wl.r.appspot.com/search/detail/?id="
        base_url += id
        var result: BusinessDetail!
        AF.request(base_url).validate().responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if let detailArr = json.to(type: BusinessDetail.self){
                    result = detailArr as? BusinessDetail
                }
                DispatchQueue.main.async {
                    completion(result,true)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion(BusinessDetail(parameter: JSON(error)),false)
                }
            }
        }
    }
    
    func ReviewAPI(id:String,completion :@escaping ([Review],Bool)-> Void){
        var base_url = "https://yelp-search-angular-1007.wl.r.appspot.com/search/review?id="
        base_url += id
        var result: [Review]!
        AF.request(base_url).validate().responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if let reviewArr = json["reviews"].to(type: Review.self){
                    result = reviewArr as! [Review]
                }
                DispatchQueue.main.async {
                    completion(result,true)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion([],false)
                }
            }
        }
    }
    
    func InfoIP(completion :@escaping ([String],Bool)-> Void){
        var base_url = "https://ipinfo.io/?token=fdb66135f152ea"
        var locArr : [String] = []
        AF.request(base_url).validate().responseJSON {response in
            switch response.result{
            case.success(let value):
                let json = JSON(value)
                let loc = json["loc"].stringValue
                locArr = loc.components(separatedBy: ",")
                DispatchQueue.main.async {
                    completion(locArr,false)
                }
            case.failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion([],false)
                }
            }
        }
    }
    
    func AutoCompleteAPI(keyword:String,completion :@escaping (AutoComplete,Bool)-> Void){
        var base_url = "https://yelp-search-angular-1007.wl.r.appspot.com/autoComplete?keyword="
        base_url += keyword
        
        var result: AutoComplete!
        AF.request(base_url).validate().responseJSON { response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if let AutoCompleteArr = json.to(type: AutoComplete.self){
                    result = AutoCompleteArr as? AutoComplete
                    //print(result.categories)
                }
                DispatchQueue.main.async {
                    completion(result,true)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion(AutoComplete(parameter: JSON(error)),false)
                }
            }
        }
    }
    
    
}
