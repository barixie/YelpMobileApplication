//
//  ReviewTab.swift
//  Yelp
//
//  Created by bari on 11/18/22.
//

import SwiftUI

struct ReviewTab: View {
    
    var review : [Review] = []

    var body: some View {
        List(review){ item in
            VStack{
                HStack{
                    Text(item.name)
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(item.rating)+"/5")
                        .fontWeight(.bold)
                }
                Spacer()
                Text(item.text)
                    .foregroundColor(.gray)
                Spacer()
                Text(item.time_created.components(separatedBy: " ")[0])
            }
        }
    }
}

//struct ReviewTab_Previews: PreviewProvider {
//    static var previews: some View {
//        ReviewTab()
//    }
//}
