//
//  ListDetail.swift
//  Yelp
//
//  Created by bari on 11/17/22.
//

import SwiftUI
import SwiftyJSON
import MapKit

struct ListDetail: View {
    
    var id : String
    @State var detail = BusinessDetail()
    @State var display_category = ""
    @State var display_price = ""
    @State var review : [Review] = []
    
    var body: some View {
        TabView{
            DetailTab(detail: detail, display_category:display_category, display_price: display_price)
                .tabItem{
                    Label("Business Detail", systemImage: "text.bubble.fill")
                }
            MapTab(coordinates: CLLocationCoordinate2D(latitude: Double(detail.latitude), longitude: Double(detail.longitude)))
                .tabItem{
                    Label("Map Location",systemImage: "location.fill")
                }
            ReviewTab(review: review)
                .tabItem{
                    Label("Reviews",systemImage: "message.fill")
                }
        }
        .onAppear(){
            APICall().detailAPI(id: id){(data,success) in
                self.detail = data
                //print(JSON({}).rawString() == nil)
                //print(detail.address.joined(separator: " "))
                if(detail.price == ""){
                    display_price = "N/A"
                }else{
                    display_price = detail.price
                }
                for item in detail.category{
                    let title = item["title"].stringValue
                    display_category += title
                    display_category += " |"
                }
                display_category = String(display_category.dropLast())
            }
            APICall().ReviewAPI(id: id){(data, success) in
                review = data
            }
        }
    }
}

struct ListDetail_Previews: PreviewProvider {
    static var previews: some View {
        ListDetail(id : "sdadbfdb")
    }
}
