//
//  OrderItem.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import Foundation

class OrderItem :Codable, Identifiable{
    var recipe: Recipe
    var quantity : Int
    var id = UUID()
    init(recipe:Recipe, quantity:Int){
        self.quantity = quantity
        self.recipe = recipe
    }
    init (){
        self.quantity = 1
        self.recipe = Recipe()
    }
    
    var totalPrice: Double{
        return recipe.allPriceConsidered * Double(quantity)
    }
    
    var getTotalPrice: String{
        return recipe.allPriceConsideredString(quantity: quantity)
    }
}
