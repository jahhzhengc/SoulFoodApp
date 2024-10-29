//
//  PromoCode.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 4/10/24.
//

import Foundation

struct PromoCode :Codable{
    var code : String
    var type : String
    var expiry_date :Date
    var discount: Int
    
    enum CodingKeys: String, CodingKey {
        case code, type, expiry_date, discount
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        type = try container.decode(String.self, forKey: .type)
        discount = try container.decode(Int.self, forKey: .discount)
        let dateString = try container.decode(String.self, forKey: .expiry_date)

        guard let date = DateFormatter.yearMonthDay.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(forKey: .expiry_date,
                                                  in: container,
                                                  debugDescription: "Date string does not match format YYYY-MM-DD")
        }
        expiry_date = date
    }
    
    init(){
        code = ""
        type = ""
        expiry_date = Date.now
        discount = 0
    }
}


extension DateFormatter {
    static let yearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Match the Django date format
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures correct date formatting
        return formatter
    }()
    
    static let yearMonthDayHourMinSec: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current  // Set to the device's curre
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures correct date formatting
        return formatter
    }()
}
// type = models.CharField(max_length= 100)
// expiry_date = models.DateField()
// code = models.CharField(max_length = 100, unique= True)
// discount = models.SmallIntegerField()
