//
//  Recipe.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import Foundation

struct Recipe: Codable, Identifiable {
    var id: Int
    var name: String
    var desc: String
    var price: Double
    var availability: Bool
    var media_file: String
    var category: Category
    var options : [Option]
    
    var favourited: Bool = false
    enum CodingKeys: String, CodingKey {
        case id, name, desc, price, availability, media_file, category, options
    }
    init(){
        self.availability = true
        self.name = ""
        self.desc = ""
        self.id = -1
        self.media_file = ""
        self.price = 0
        self.category = Category()
        self.options = []
    }
    init(name: String, desc: String, media_file:String, price:Double){
        self.availability = true
        self.price = price
        self.name = name
        self.desc = desc
        self.media_file = media_file
        self.id = -1
        self.category = Category()
        self.options = []
    }
    
    init(id: Int, name: String, desc: String, price: Double, media_file: String, availability: Bool, options: [Option]){
        self.id = id
        self.name = name
        self.desc = desc
        self.price = price
        self.media_file = media_file
        self.availability = availability
        self.category = Category()
        self.options = options
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        desc = try container.decode(String.self, forKey: .desc)
        let priceString = try container.decode(String.self, forKey: .price)
        price = Double(priceString) ?? 0.0
        availability = try container.decode(Bool.self, forKey: .availability)
        media_file = try container.decode(String.self, forKey: .media_file)
        category = try container.decode(Category.self, forKey: .category)
        options = try container.decode([Option].self, forKey: .options)
    }
    
    func parsedPrice()->String{
        return "$ " + String(format: "%.2f", self.price)
    }
    
    func parsedPrice(toParse: Double)->String{
        return "$ " + String(format: "%.2f", toParse)
    }
    
    var allPriceConsidered: Double{
        let _options  = options.filter { option in
            return option.toggled
        }
        var toReturn: Double = price
         
        for x in 0..<_options.count{
            toReturn += options[x].price_adjustment
        }
        return toReturn
    }
    
    func allPriceConsideredString(quantity: Int) -> String{
        return (allPriceConsidered * Double(quantity)).parsedPrice() 
    }
}

//extension Recipe
