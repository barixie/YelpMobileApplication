//
//  ListRow.swift
//  Yelp
//
//  Created by bari on 11/15/22.
//

import SwiftUI

struct ListRow: View {
    var businesstable: BusinessTable
    var index : Int
    
    var body: some View {
        
        HStack(alignment: .center) {
            Text(String(index))
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            Spacer()
            AsyncImage(url: URL(string: businesstable.image_url)) { image in
                image.resizable()
                    .cornerRadius(5.0)
            } placeholder: {
                ProgressView()
            }
            .padding(.all, -10.0)
            .frame(width: 50, height: 50)
            Spacer()
            Text(businesstable.name)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
                .frame(width: 70.0)
            Spacer()
            Text(String(businesstable.rating))
                .font(.subheadline)
            Spacer()
            Text(String(Int(ceil(businesstable.distance/1609))))
                .font(.subheadline)
        }
        .padding()
    }
}

//struct ListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ListRow()
//    }
//}
