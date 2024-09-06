//
//  ReservationView.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import SwiftUI

struct ReservationView: View {
    let tomorrow = Date.now.addingTimeInterval(60 * 60 * 24)
    let nextMonth = Date.now.addingTimeInterval(60 * 60 * 24 * 30)

    @State private var wakeUp = Date.now
    let dateFormatter = DateFormatter()
                                                // 60s * 60mins * 24hrs * 30days LOL
    
    @State var favourited : Bool = false
    
    var time: ClosedRange<Date> {
//        _start =
        return tomorrow...nextMonth
    }
    @State private var selectedTime = Date()

    // limit the hours for time picker
    var getTime: some View {
           let calendar = Calendar.current
           let startDate = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
           let endDate = calendar.date(bySettingHour: 20, minute: 0, second: 0, of: Date())!
           
           return DatePicker("Select Time", selection: $selectedTime,
                             in: startDate...endDate,
                             displayedComponents: .hourAndMinute)
               .datePickerStyle(CompactDatePickerStyle())
               .environment(\.locale, Locale(identifier: "en_US_POSIX"))
               .labelsHidden()
       }
    
    
    var body: some View {
        // limits the date, to tomorrow ~ 1 month after
        DatePicker("Pick a date", selection : $wakeUp, in: time, displayedComponents: .date)
            .onAppear(perform:{ 
                UIDatePicker.appearance().minuteInterval = 15
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            })
            .labelsHidden()
        getTime
        Text(wakeUp.description)
        
        // by right, the timepicker should be given certain timing after getting the 'available' reservation
    }
}

#Preview {
    ReservationView()
}
