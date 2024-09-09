//
//  RecipeFavourite.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 9/9/24.
//

import Foundation

struct RecipeFavourite :Codable{
    var user: Int
    var recipe : Int
    enum CodingKeys: String, CodingKey {
        case user, recipe
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(Int.self, forKey: .user)
        recipe = try container.decode(Int.self, forKey: .recipe)
    }
    
}
