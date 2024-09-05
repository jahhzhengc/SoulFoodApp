//
//  Category.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import Foundation

struct Category: Codable, Identifiable {
    var id: Int
    var name: String
    var display_order_mobile : Int
    
    init(){
        self.id = 0
        self.name = ""
        self.display_order_mobile = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, display_order_mobile
    }
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        display_order_mobile = try container.decode(Int.self, forKey: .display_order_mobile)
    }
}
