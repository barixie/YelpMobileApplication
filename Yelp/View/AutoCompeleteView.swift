//
//  AutoCompeleteView.swift
//  Yelp
//
//  Created by bari on 11/19/22.
//

import SwiftUI

struct AutoCompeleteView: View {
    
    @State var isLoading : bool = true
    var body: some View {
        if(isLoading){
            ProgressView()
        }else{
            ForEach(Auto_Comp_List, id:\.self){ item in
                Text(item)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        self.keyword = item
                        self.showPopOver = false
                    }
            }
        }    }
}

struct AutoCompeleteView_Previews: PreviewProvider {
    static var previews: some View {
        AutoCompeleteView()
    }
}
