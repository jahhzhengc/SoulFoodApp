//
//  OrderItem.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import Foundation

struct OrderItem :Codable{
    var recipe: Recipe
    var quantity : Int
    
    init(recipe:Recipe, quantity:Int){
        self.quantity = quantity
        self.recipe = recipe
    }
    
    var getTotalPrice: String{
        
        return recipe.allPriceConsideredString(quantity: quantity)
    }
}
