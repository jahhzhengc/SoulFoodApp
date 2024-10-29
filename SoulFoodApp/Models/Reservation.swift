//
//  Reservation.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 29/10/24.
//

import Foundation
//fields = ['user', 'reservationDateTime', 'status', 'numOfPeople']

struct Reservation :Codable{
    var user: Int
    var reservationDateTime : Date
    var status: Int
    var numOfPeople: Int
    enum CodingKeys: String, CodingKey {
        case user, reservationDateTime, status, numOfPeople
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(Int.self, forKey: .user)
        status = try container.decode(Int.self, forKey: .status)
        numOfPeople = try container.decode(Int.self, forKey: .numOfPeople)
        
        let dateString = try container.decode(String.self, forKey: .reservationDateTime)

        guard let date = DateFormatter.yearMonthDay.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .reservationDateTime,
                                                  in: container,
                                                  debugDescription: "Date string does not match format YYYY-MM-DD")
        }
        reservationDateTime = date
    }
    
}
