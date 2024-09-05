//
//  Options.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import Foundation

struct Option: Codable, Identifiable{
    var id: Int
    var name: String
    var price_adjustment: Double
    var toggled: Bool = false
    init(){
        self.name = ""
        self.id = 0
        self.price_adjustment = 0.0
        self.toggled = false
    }
    init(id: Int, name:String, price_adjustment:Double){
        self.name = name
        self.id = id
        self.price_adjustment = price_adjustment
        self.toggled = false
    }
    init(id: Int, name:String, price_adjustment:Double, toggled: Bool){
        self.name = name
        self.id = id
        self.price_adjustment = price_adjustment
        self.toggled = toggled
    }
    
    enum CodingKeys: String, CodingKey {
        case  id, name, price_adjustment
    }
    
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)

        let priceString = try container.decode(String.self, forKey: .price_adjustment)
        price_adjustment = Double(priceString) ?? 0.0
    }
    var getPriceAdjustment: String{
        if(self.price_adjustment == 0){
            return ""
        }
        let positive = self.price_adjustment > 0
        let toReturn = (positive ? "+" : "-" ) + " $ " + String(self.price_adjustment);
        
        return toReturn
    }
}
