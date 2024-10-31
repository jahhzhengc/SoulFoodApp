//
//  ReservationDetail.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 30/10/24.
//

import SwiftUI

struct ReservationDetail: View {
    @State var reservation : Reservation
    
    var body: some View {
        
        VStack(alignment:.leading){
            Text("You've reserved a table for \(reservation.numOfPeople) at \(reservation.reservationDateTime)")
                .font(.subheadline)
        }
        .padding()
        .background(.red.opacity(0.5))
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay{
            RoundedRectangle(cornerRadius: 15).stroke(.black, lineWidth: 2)
        }
        .padding()
        
    }
}

#Preview {
    ReservationDetail(reservation:
                        Reservation(reservationDateTime: Date.now, status: 1, numOfPeople: 3))
}
