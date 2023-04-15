//
//  DetailTab.swift
//  Yelp
//
//  Created by bari on 11/18/22.
//

import SwiftUI
import SwiftyJSON

struct DetailTab: View {

    var detail = BusinessDetail()
    var display_category : String = ""
    var display_price : String = ""
    @State var IsReserved : Bool = false
    @State var showSheet : Bool = false
    @State var TwitterLink : String = ""
    @State var FacebookLink : String = ""
    @State var resItemList : [ReservationItem] = []
    @State var isCancelled : Bool = false
    @Environment(\.openURL) var openURL

    var body: some View {
        VStack {
            Text(detail.name)
                .font(.title)
            .fontWeight(.bold)
            VStack {
                HStack {
                    Text("Address")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Category")
                        .fontWeight(.bold)
                }
                HStack {
                    Text(detail.address.joined(separator: " "))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(display_category)
                        .foregroundColor(.gray)
                }
            }
            .padding([.top, .leading, .trailing])
            VStack {
                HStack {
                    Text("Phone")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Price Range")
                        .fontWeight(.bold)
                }
                HStack {
                    Text(detail.display_phone)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(display_price)
                        .foregroundColor(.gray)
                }
            }
            .padding([.top, .leading, .trailing])
            VStack {
                HStack {
                    Text("Status")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Visit Yelp for more")
                        .fontWeight(.bold)
                }
                HStack {
                    if detail.status{
                        Text("Open Now")
                            .foregroundColor(.green)
                    }else{
                        Text("Closed")
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Text(.init("[Business Link](\(String(detail.url)))"))
                }
            }
            .padding(.all)
            
            if IsReserved{
                Button("Cancel Reservation"){
                    do {
                        let storedObjItem = UserDefaults.standard.object(forKey: "item")
                        if(storedObjItem != nil){
                            self.resItemList = try JSONDecoder().decode([ReservationItem].self, from: storedObjItem as! Data)
                        }
                    } catch let err {
                        print(err)
                    }
                    let temp = resItemList.filter{ $0.name != detail.name}
                    if let encoded = try? JSONEncoder().encode(temp) {
                        UserDefaults.standard.set(encoded, forKey: "item")
                    }
                    IsReserved = false
                    isCancelled = true
                }
                .frame(width: 170.0, height: 50.0)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(15.0)
            }else{
                Button("Reserve Now") {
                    showSheet.toggle()
                }
                .frame(width: 120.0, height: 50.0)
                .background(.red)
                .foregroundColor(.white)
                .cornerRadius(15.0)
                .sheet(isPresented: $showSheet){
                    ReservationView(name:detail.name,Parent_reserved: $IsReserved)
                }
            }
            
            HStack{
                Text("Share on")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Button{
                    FacebookLink = "https://www.facebook.com/sharer/sharer.php?quote=Check " + detail.name + " on Yelp.&u=" + detail.url
                    if let encoded = FacebookLink.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                       let myURL = URL(string: encoded){
                        openURL(myURL)
                    }
                    //openURL()
                } label: {
                    Image("facebook")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                Button{
                    TwitterLink = "https://twitter.com/intent/tweet?text=Check " + detail.name + " on Yelp.&url=" + detail.url
                    if let encoded = TwitterLink.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                       let myURL = URL(string: encoded){
                        openURL(myURL)
                    }
                    //openURL()
                } label: {
                    Image("twitter")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            //Spacer()
            TabView{
                ForEach(detail.photos, id: \.self){ photo in
                    ZStack{
                        AsyncImage(url: URL(string: photo)) { image in
                            image.resizable()
                        }placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 200)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
        .toast(isPresented: $isCancelled){
            Text("Your reservation is Cancelled")
        }
    }
}

//struct DetailTab_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailTab(id: "sind")
//    }
//}
