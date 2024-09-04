//
//  Cart.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 4/9/24.
//

import Foundation

class Cart: ObservableObject{
    @Published var items: [Recipe] = []
    func add(recipe: Recipe){
        items.append(recipe)
    }
    func remove(recipe: Recipe) {
          if let index = items.firstIndex(where: { $0.id == recipe.id }) {
              items.remove(at: index)
          }
      }
}
