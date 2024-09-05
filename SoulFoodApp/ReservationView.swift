//
//  ReservationView.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import SwiftUI

struct ReservationView: View {
    let tomorrow = Date.now.addingTimeInterval(60 * 60 * 24)
    @State private var wakeUp = Date.now
    let dateFormatter = DateFormatter()
                                                // 60s * 60mins * 24hrs * 30days LOL
    let nextMonth = Date.now.addingTimeInterval(60 * 60 * 24 * 30)
    var body: some View {
        
        DatePicker("Pick a date", selection : $wakeUp, in: tomorrow...nextMonth)
            .onAppear(perform:{
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            })
        // by right, the timepicker should be given certain timing after getting the 'available' reservation 
    }
}

#Preview {
    ReservationView()
}
