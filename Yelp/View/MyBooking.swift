//
//  MyBooking.swift
//  Yelp
//
//  Created by bari on 11/19/22.
//

import SwiftUI

struct MyBooking: View {
    
    @State var resItemList : [ReservationItem] = []
    
    var body: some View {
        //NavigationView{
            if(resItemList.count == 0){
                Text("No Booking Found")
                    .navigationTitle("Your Reservation")
                    .foregroundColor(.red)
                    .onAppear(){
                        do {
                            let storedObjItem = UserDefaults.standard.object(forKey: "item")
                            if(storedObjItem != nil){
                                self.resItemList = try JSONDecoder().decode([ReservationItem].self, from: storedObjItem as! Data)
                            }
                        } catch let err {
                            print(err)
                        }
                    }
            }
            else{
                List{
                    ForEach(resItemList, id: \.self){ resItem in
                        HStack{
                            Text(resItem.name)
                                .font(.caption)
                                .frame(width: 80)
                            Spacer()
                            Text(resItem.date)
                                .font(.caption)
                                .frame(width: 70)
                            Spacer()
                            Text(resItem.time)
                                .font(.caption)
                                .frame(width: 40)
                            Spacer()
                            Text(resItem.email)
                                .font(.caption)
                                .frame(width: 100)
                        }
                    }.onDelete { (indexSet) in
                        self.resItemList.remove(atOffsets: indexSet)
                        if let encoded = try? JSONEncoder().encode(resItemList) {
                            UserDefaults.standard.set(encoded, forKey: "item")
                        }
                    }
                }
                .navigationTitle("Your Reservaion")
                .onAppear(){
                    do {
                        let storedObjItem = UserDefaults.standard.object(forKey: "item")
                        if(storedObjItem != nil){
                            self.resItemList = try JSONDecoder().decode([ReservationItem].self, from: storedObjItem as! Data)
                        }
                    } catch let err {
                        print(err)
                    }
                }
            }
        //}
    }
}

struct MyBooking_Previews: PreviewProvider {
    static var previews: some View {
        MyBooking()
    }
}
