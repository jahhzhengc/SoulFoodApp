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
    var onlyDateFormatter = DateFormatter()
    var onlyTimeFormatter = DateFormatter()
    let tomorrow = Date.now.addingTimeInterval(60 * 60 * 24)
    let nextMonth = Date.now.addingTimeInterval(60 * 60 * 24 * 30) // 60s * 60mins * 24hrs * 30days LOL
    
    // dont allow them to reserve beyond next month
    var date: ClosedRange<Date> {
        return tomorrow...nextMonth
    }
    
    @ObservedObject var tokenManager = TokenManager.shared
    @State private var selectedDate: Date = Date.now.addingTimeInterval(-60 * 60 * 24)

    // limit the hours for time picker, cause there's Opening Hours
    var getTime: some View {
           let calendar = Calendar.current
           let startTime = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
           let endTime = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!
           
           return DatePicker("Selected Time", selection: $selectedDate,
                             in: startTime...endTime,
                             displayedComponents: .hourAndMinute)
           .datePickerStyle(GraphicalDatePickerStyle())
               .environment(\.locale, Locale(identifier: "en_US_POSIX"))
//               .labelsHidden()
       }
    
    @State private var onSliderEdit = false
    @State private var num :Double = 1;
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading){
                List{
                    if(reservations.count > 0){
                        Section(header: Text("Your reservations")
                            .font(.title)
                            .bold()
                            .underline()
                            .foregroundStyle(.black)
                        ){
                            ForEach(reservations) { reservation in
                                Text(dateFormatter.string(from: reservation.reservationDateTime))
                                Label("\(reservation.numOfPeople) ", systemImage: "person.2.fill")
                            }
                        }
                    }
//                    if(showBookTable){
                        Section(header: Text("Book a Table")
                            .font(.title)
                            .bold()
                            .underline()
                            .foregroundStyle(.black)
                        ){
                            
                             
                            // limits the date, to tomorrow ~ 1 month after
                            DatePicker("Selected Date", selection : $selectedDate, in: date, displayedComponents: .date)
//                                .padding()
                            
                            getTime
                            
                            
                            VStack{
                                Text("Group size: \(String(format: "%.f", num))")
                                Slider(
                                    value: $num,
                                    in: 1...10,
                                    step: 1
                                ) {
                                    Text("Speed")
                                } minimumValueLabel: {
                                    Text("1")
                                } maximumValueLabel: {
                                    Text("10")
                                } onEditingChanged: { editing in
                                    onSliderEdit = editing
                                    print(onSliderEdit)
                                }
                            }
                            
                            Button{
                                print(dateFormatter.string(from: selectedDate))
                                showingConfirmation = true
                                //                setReservation()
                            }label:{
                                Text("Confirm")
                            }
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.borderedProminent)
                            .sheet(isPresented: $showingConfirmation){
                             
                                VStack{
                                    Text("You've booked a reservation on \(dateFormatter.string(from:selectedDate)) for a")
                                    Text("By creating a reservation, you've agreed to our TOS.")
                                    
                                    Button{
                                        
                                    }label:{
                                        Text("Confirm booking")
                                    }
                                }
                                    .presentationDetents([.medium, .large]) // Allows the sheet to be scrollable or full screen
                                    .presentationDragIndicator(.visible)
                            }
//                            .confirmationDialog("Change background", isPresented: $showingConfirmation) {
//                                Button("Confirm"){}
//                                
//                            } message:{
//                                Text("You are coming on \(dateFormatter.string(from: selectedDate)) with total of \(num) ")
//                            }
                            
                        }
//                    }
                }
            }
            .toolbar{
                if(!showBookTable){
                    Button{
                        showBookTable = true
                    }label:{
                        Label("", systemImage:"plus")
                    }
                }
            }
            Spacer()
        }
        .onAppear(perform:{
            UIDatePicker.appearance().minuteInterval = 15
            onlyDateFormatter.dateFormat = "yyyy/MM/dd"
            onlyDateFormatter.timeZone = TimeZone.current
             
            onlyTimeFormatter.dateFormat = "HH:mm:ss"
            onlyTimeFormatter.timeZone = TimeZone.current  
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone.current  // Set to the device's current timezone
            print("CALLED")
            getReservations()
        })
        
        // by right, the timepicker should be given certain timing after getting the 'available' reservation
    }
    @State private var showBookTable = false
    @State private var reservations: [Reservation] = []
    @State private var showingConfirmation = false
    
    func getReservations(){
        var request = tokenManager.wrappedRequest(sendReq: "/api/reservation/")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
             
            guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200 else {
                return
            }
            
            if let data = data {
                do{
                    let decodedResponse = try JSONDecoder().decode([Reservation].self, from: data)
                     
                    DispatchQueue.main.async{
                        reservations = decodedResponse
                            .sorted(by: {$0.reservationDateTime < $1.reservationDateTime})
                          
                        print(reservations.count)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showBookTable = reservations.count == 0
                            // this should mean, automatically display the 'Create a Reservation' portion when there's 0 reservations
                        }
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
                return
                
                
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    } 
    
    func setReservation(){
        
        var request = tokenManager.wrappedRequest(sendReq: "/api/reservation/")
          
        let json: [String: Any] = ["reservationDateTime": dateFormatter.string(from: selectedDate),
                                   "numOfPeople": num]

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
