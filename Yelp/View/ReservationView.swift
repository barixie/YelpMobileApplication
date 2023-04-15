//
//  ReservationView.swift
//  Yelp
//
//  Created by bari on 11/20/22.
//

import SwiftUI

struct ReservationView: View {
    
    var name : String = ""
    @State var email : String = ""
    @State var date = Date()
    @State var hour : String = "10"
    @State var min : String = "00"
    @State var isEmailValid : Bool = false
    @State var isReserved = false
    @Binding var Parent_reserved : Bool
    @Environment(\.dismiss) var dismiss
    
    var hour_list = ["10","11","12","13","14","15","16","17"]
    var min_list = ["00","15","30","45"]
    let dateFormatter = DateFormatter()
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2021, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    var body: some View {
        if isReserved{
            //Color.green.edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
                Text("Congratulations")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("You have successfully made an reservation at " + name)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Spacer()
                Button("Done"){
                    dismiss()
                    Parent_reserved = true
                }
                .frame(width: 150.0, height: 50.0)
                .background(.white)
                .foregroundColor(.green)
                .cornerRadius(25.0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.green)
        }
        else{
            Form{
                Section{
                    HStack {
                        Spacer()
                        Text("Reservation Form")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                Section{
                    HStack {
                        Spacer()
                        Text(name)
                            .font(.title2)
                        .fontWeight(.bold)
                        Spacer()
                    }
                }
                Section{
                    HStack {
                        Text("Email:")
                            .foregroundColor(.gray)
                        TextField("", text: $email)
                    }
                    HStack {
                        Text("Date/Time:")
                            .foregroundColor(.gray)
                        DatePicker(
                                "",
                                 selection: $date,
                                in: Date()...,
                                 displayedComponents: [.date]
                        )
                        Picker("",selection: $hour){
                            ForEach(hour_list, id: \.self){
                                Text($0)
                            }
                        }
                        .background(Color(red: 239/255, green: 239/255, blue: 240/255))
                        .cornerRadius(5.0)
                        .pickerStyle(.menu)
                        .accentColor(.black)
                        Picker("",selection: $min){
                            ForEach(min_list, id: \.self){
                                Text($0)
                            }
                        }
                        .background(Color(red: 239/255, green: 239/255, blue: 240/255))
                        .cornerRadius(5.0)
                        .pickerStyle(.menu)
                        .accentColor(.black)
                    }
                    HStack {
                        Spacer()
                        Button("Submit") {
                        }                    .frame(width: 100.0, height: 45.0)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10.0)
                        .padding()
                        .onTapGesture{
                            self.isReserved = false
                            //UserDefaults.standard.removeObject(forKey: "item")
                            if self.textFieldValidatorEmail(self.email) {
                                self.isEmailValid = false
                            }else {
                                self.isEmailValid = true
                                //self.textEmail = ""
                            }
                            dateFormatter.dateFormat = "YYYY-MM-dd"
                            var resItemList : [ReservationItem] = []
                            let time = String(hour) + ":" + String(min)
                            if !isEmailValid{
                                do {
                                    let storedObjItem = UserDefaults.standard.object(forKey: "item")
                                    if(storedObjItem != nil){
                                        resItemList = try JSONDecoder().decode([ReservationItem].self, from: storedObjItem as! Data)
                                    }
                                } catch let err {
                                    print(err)
                                }
                                let resItem = ReservationItem.init(name: name, date: dateFormatter.string(from: date), time: time, email: email)
                                resItemList.append(resItem)
                                if let encoded = try? JSONEncoder().encode(resItemList) {
                                    UserDefaults.standard.set(encoded, forKey: "item")
                                }
                                self.isReserved = true
                            }
                        }
                        Spacer()
                    }
                }
            }
            .toast(isPresented: $isEmailValid){
                Text("Please enter an valid email")
            }
        }
    }
}

//struct ReservationView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReservationView(name: "Prince Street Pizza",Parent_reserved: )
//    }
//}
