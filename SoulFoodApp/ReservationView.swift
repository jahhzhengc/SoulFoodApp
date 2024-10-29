//
//  ReservationView.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import SwiftUI

struct ReservationView: View {
    // probably need to include dates to exclude like every monday? or holiday? idk
    // maybe Manager/ Owner gets to decide the 'Holidays', then we exclude those days accordingly
    
    // then if there's already reservations made, we gotta send them an e-mail telling them
    // whelp for [whatever] reason, we're cancelling that day, we might or might not compensate you
    // or we can include things T&S like, we reserve the right to cancel your reservation without prior notice
    
    var dateFormatter = DateFormatter()
    let tomorrow = Date.now.addingTimeInterval(60 * 60 * 24)
    let nextMonth = Date.now.addingTimeInterval(60 * 60 * 24 * 30) // 60s * 60mins * 24hrs * 30days LOL
    
    // dont allow them to reserve beyond next month
    var date: ClosedRange<Date> {
        return tomorrow...nextMonth
    }
    
    @ObservedObject var tokenManager = TokenManager.shared
    @State private var selectedDate = Date.now
    @State private var selectedTime = Date()

    // limit the hours for time picker, cause there's Opening Hours
    var getTime: some View {
           let calendar = Calendar.current
           let startTime = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
           let endTime = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!
           
           return DatePicker("Selected Time", selection: $selectedDate,
                             in: startTime...endTime,
                             displayedComponents: .hourAndMinute)
               .datePickerStyle(CompactDatePickerStyle())
               .environment(\.locale, Locale(identifier: "en_US_POSIX"))
//               .labelsHidden()
       }
    
    @State private var num = 1;
    var body: some View {
        VStack(alignment:.leading){
            
            Text("Book a Table")
                .font(.title)
                .bold()
            
            // limits the date, to tomorrow ~ 1 month after
            
            DatePicker("Selected Date:", selection : $selectedDate, in: date, displayedComponents: .date)
            
            getTime
            
            Stepper("Group size: \(num)", onIncrement: {
                if(num < 10){
                    num += 1
                }
            }, onDecrement: {
                if(num > 1){
                    num -= 1
                }
            })
            
            Button{
                print(dateFormatter.string(from: selectedDate))
                print(dateFormatter.string(from: selectedDate))
                setReservation()
            }label:{
                Label("Confirm", systemImage: "paperplane.circle.fill")
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .onAppear(perform:{
            UIDatePicker.appearance().minuteInterval = 15
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current  // Set to the device's current timezone
//            dateFormatter.dateStyle = .medium
//            dateFormatter.timeStyle = .medium
            getReservations()
        })
        .padding()
        
        // by right, the timepicker should be given certain timing after getting the 'available' reservation
    }
    func getReservations(){
        let request = tokenManager.wrappedRequest(sendReq: "/api/reservation/")
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
                return
            }
          
            if let data = data {
                
                do{
                    let decodedResponse = try JSONDecoder().decode([Reservation].self, from: data)
                    DispatchQueue.main.async{
                        print(decodedResponse)
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
                return
                
                
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    //        fields = ['user', 'reservationDateTime', 'status', 'numOfPeople']
    
    func setReservation(){
        
        var request = tokenManager.wrappedRequest(sendReq: "/api/reservation/")
          
        let json: [String: Any] = ["reservationDateTime": dateFormatter.string(from: selectedDate)]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        request.httpMethod = "POST"
        request.httpBody = jsonData
          
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
                return
            }
            if let data = data {
                do{
                    let decodedResponse = try JSONDecoder().decode(Reservation.self, from: data)
                    DispatchQueue.main.async{
                        print(decodedResponse)
                    }
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
    ReservationView()
}
