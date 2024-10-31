//
//  SetBirthdayPage.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 31/10/24.
//

import SwiftUI

struct SetBirthdayPage: View {
    
    @State private var selectedDate : Date? = nil
    
     
    let centuryAgo = Date.now.addingTimeInterval(-60 * 60 * 24 * 30 * 12 * 100) // 60s * 60mins * 24hrs * 30days LOL
    
    // dont allow them to reserve beyond next month
    var date: ClosedRange<Date> {
        return centuryAgo...Date.now
    }
    
    @ObservedObject var tokenManager = TokenManager.shared
    @Environment(\.dismiss) private var dismiss
    
    let dateFormatter: DateFormatter = DateFormatter()
    let sendDateFormat : DateFormatter = DateFormatter()
    var body: some View {
        VStack{
            DatePicker("Set your birthday", selection : Binding(
                get: {
                    selectedDate ?? Date()
                },
                set: { newValue in
                    selectedDate = newValue
                }
            ), in: date, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
            
            if let date = selectedDate {
                Text("Your birthday is on \(dateFormatter.string(from: date))")
            } else {
                Text("No Date selected")
            }
            
            
            Button("Send"){
                var request = tokenManager.wrappedRequest(sendReq: "/api/birthday/")
                
                var json: [String: Any] = ["birthday": dateFormatter.string(from: selectedDate!)]
                
                if let date = selectedDate {
                    json  = ["birthday": sendDateFormat.string(from: date)]
                } else {
                    return
                }

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

                      } catch {
                          print("Failed to decode JSON: \(error.localizedDescription)")
                      }
                      return
                    }
                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                }.resume()
            }
        }
        .onAppear{
            sendDateFormat.dateFormat = "YYYY-MM-dd"
            dateFormatter.dateStyle = .medium
            print(selectedDate == nil)
        }
        
    }
}

#Preview {
    SetBirthdayPage()
}
