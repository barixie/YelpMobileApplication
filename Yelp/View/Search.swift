//
//  Search.swift
//  Yelp
//
//  Created by bari on 11/15/22.
//

import SwiftUI
import Alamofire
import MapKit


struct Search: View {
        var dropdownList = ["Default","Arts & Entertainments","Health & Medical","Hotels & Travel","Food","Professional Service"]
        
        //@Environment(\.presentationMode) var presentation
    
        @State var keyword: String = ""
        @State var distance: String = "10"
        @State var category: String = "Default"
        @State var location: String = ""
        @State var auto_detect: Bool = false
        @State var TableData : [BusinessTable] = []
        @State var LocationArr : [String] = []
        @State var Auto_Comp_List : [String] = []
        @State var showPopOver : Bool = false
        @State var showPopOver_t : Bool = false
        @State var showTableLoading = false
        @State var NoDataFlag = false
    
        var body: some View {
            NavigationView{
                Form {
                    Section{
                        HStack {
                            Text("keyword:")
                                .foregroundColor(.gray)
                            
                            TextField("Required", text: $keyword)
                                .onSubmit {
                                    //print("text Field submitted")
                                    //print(keyword)
                                    APICall().AutoCompleteAPI(keyword: keyword){ (data,success) in
                                        Auto_Comp_List = []
                                        for cate in data.categories{
                                            let title = cate["title"].stringValue
                                            Auto_Comp_List.append(title)
                                        }
                                        for terms in data.term{
                                            let t  = terms["text"].stringValue
                                            Auto_Comp_List.append(t)
                                        }
                                        //self.showPopOver = true
                                        self.showPopOver_t = true
                                    }
                                }
                                .alwaysPopover(isPresented: $showPopOver_t){
                                        ProgressView("Please wait")
                                        .onAppear(){
                                            showPopOver = true
                                        }
                                }
                                .alwaysPopover(isPresented: $showPopOver){
                                    ForEach(Auto_Comp_List, id:\.self){ item in
                                        Text(item)
                                            .foregroundColor(.gray)
                                            .onTapGesture {
                                                self.keyword = item
                                                self.showPopOver = false
                                                self.showPopOver_t = false
                                        }
                                    }
                                }
                        }
                        HStack {
                            Text("Distance:")
                                .foregroundColor(.gray)
                            
                            TextField(distance, text: $distance)
                                .onAppear(){
                                    self.distance = "10"
                                }
                        }
                        HStack {
                            Text("Category:")
                                .foregroundColor(.gray)
                            Picker("", selection: $category){
                                ForEach(dropdownList, id: \.self){
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .onAppear(){
                                self.category="Default"
                            }
                        }
                        if(!auto_detect){
                            HStack {
                                Text("Location:")
                                    .foregroundColor(.gray)
                                
                                TextField("Required", text: $location)
                            }
                        }
                        Toggle(isOn: $auto_detect) {
                            Text("Auto-detect my location")
                                .foregroundColor(.gray)
                        }
                        HStack {
                            if(keyword != "" && (location != "" || auto_detect)){
                                Button("Submit") {
                                }
                                .frame(width: 100.0, height: 45.0)
                                .background(.red)
                                .foregroundColor(.white)
                                .cornerRadius(10.0)
                                .offset(x: 30.0, y: 0)
                                .onTapGesture {
                                    self.showTableLoading = true
                                    APICall().SearchAPI(keyword: keyword,distance: distance,location: location,Auto_detect: auto_detect,category: category,LocationArr: LocationArr) { (data,success) in
                                        if(data.count == 0){
                                            self.NoDataFlag = true
                                        }
                                        self.TableData = data
                                        self.showTableLoading = false
                                    }
                                }
                            }else{
                                Button("Submit") {
                                }
                                .frame(width: 100.0, height: 45.0)
                                .background(.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10.0)
                                .offset(x: 30.0, y: 0)
                            }
                            
                            Spacer()
                            
                            Button("Clear") {
                            }
                            .frame(width: 100.0, height: 45.0)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10.0)
                            .offset(x:-30.0)
                            .onTapGesture {
                                self.TableData = []
                                self.keyword = ""
                                self.distance = "10"
                                self.location = ""
                                self.auto_detect = false
                                self.category = "Default"
                                self.NoDataFlag = false
                            }
                        }
                        .padding(.vertical)
                    }
                    .padding(0.0)
                    Section{
                        Text("Results")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if(showTableLoading){
                            HStack{
                                Spacer()
                                ProgressView("Please wait")
                                Spacer()
                            }
                        }
                        if(NoDataFlag){
                            Text("No results available")
                                .foregroundColor(.red)
                        }
                        else{
                            ForEach(Array(TableData.enumerated()),id: \.offset) {idx,tabledata in
                                NavigationLink{
                                    ListDetail(id:tabledata.id)
                                } label: {
                                    ListRow(businesstable: tabledata, index:idx+1)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Business Search")
                .toolbar{
                    NavigationLink{
                        MyBooking()
                    }label: {
                        Label("MyBooking",systemImage: "calendar.badge.clock")
                    }
                }
            }
            .onAppear(){
                APICall().InfoIP(){(data, success) in
                    self.LocationArr = data
                    //print(self.LocationArr)
                }
            }
    }
}
struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}

