//
//  CustomerProfile.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 1/11/24.
//

import Foundation

 
struct CustomerProfile : Codable{
    var birthday : Date
    var address: String
    var points: Int
    enum CodingKeys: String, CodingKey {
        case birthday, address, points
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        points = try container.decode(Int.self, forKey: .points)

        let dateString = try container.decode(String.self, forKey: .birthday)
        guard let date = DateFormatter.yearMonthDay.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .birthday,
                                                  in: container,
                                                  debugDescription: "Date string does not match format YYYY-MM-DD")
        }
        birthday = date
    }

}
