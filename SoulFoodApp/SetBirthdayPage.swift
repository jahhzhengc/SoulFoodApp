//
//  SetBirthdayPage.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 31/10/24.
//

import SwiftUI

struct SetBirthdayPage: View {
    
    @State private var selectedDate : Date? = nil
    @State private var oldBirthday = Date()
     
    let centuryAgo = Date.now.addingTimeInterval(-60 * 60 * 24 * 30 * 12 * 100) // 60s * 60mins * 24hrs * 30days LOL
    
    // dont allow them to reserve beyond next month
    var date: ClosedRange<Date> {
        return centuryAgo...Date.now
    }
    
    @ObservedObject var tokenManager = TokenManager.shared
    @Environment(\.dismiss) private var dismiss
    
    let dateFormatter: DateFormatter = DateFormatter()
    let sendDateFormat : DateFormatter = DateFormatter()
    
    let url = "/api/birthday/"
    @State private var sent = false
    var body: some View {
        VStack(alignment: .leading){
            Text("Profile {Birthday}")
                .padding(.vertical)
                .font(.title3)
                .bold()
            
            Divider()
            DatePicker("Set your birthday", selection : Binding(
                get: {
                    selectedDate ?? Date()
                },
                set: { newValue in
                    selectedDate = newValue
                }
            ), in: date, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding(.vertical)
            
            Divider()
            
            if let date = selectedDate {
                Text("Your birthday is on \(dateFormatter.string(from: date))")
                    .frame(maxWidth: .infinity)
            } else {
                Text("No Date selected")
                    .frame(maxWidth: .infinity)
            }
            
            if(!sent){
                Button("Birthday set"){
                    sendBtnPressed()
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .frame(maxWidth: .infinity)
                
            }else{
                ProgressView("Updating birthday...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding(.top)
            }
            Spacer()
        }
        .padding()
        .onAppear{
            
            sendDateFormat.dateFormat = "YYYY-MM-dd"
            dateFormatter.dateStyle = .medium
            getBirthday()
        }
    }
    
    func getBirthday(){
        var request = tokenManager.wrappedRequest(sendReq: url)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
             
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            if let data = data {
                do{
                    let decodedResponse = try JSONDecoder().decode(CustomerProfile.self, from: data)

                    oldBirthday = decodedResponse.birthday
                    selectedDate = decodedResponse.birthday
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
                return
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    func sendBtnPressed(){
        
        var json: [String: Any] =  [:]
        
        if let date = selectedDate {
            json  = ["birthday": sendDateFormat.string(from: date)]
        } else {
            print("birthday not set")
            return
        }
        
        if(oldBirthday == selectedDate)
        {
            print("Its the same")
            self.dismiss()
            return
        }
        var request = tokenManager.wrappedRequest(sendReq: url)
          
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        request.httpMethod = "PATCH"
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                return
            }
            
            if let data = data {
                do{
                    let decodedResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    print(decodedResponse)
                    self.dismiss()
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
                return
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

#Preview {
    SetBirthdayPage()
}
