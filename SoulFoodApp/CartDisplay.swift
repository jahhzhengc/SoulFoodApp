//
//  CartDisplay.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import SwiftUI

struct CartDisplay: View {
//    @Environment(\.dismiss) private var dismiss
    
    @State var cart: Cart  // Reference the shared cart
     var body: some View {
         NavigationStack{
             ForEach(cart.items){ item in
                 NavigationLink{
                     RecipeDetailsView(recipeDetails: item.recipe, num: item.quantity, cart: cart
                                       ,edit: true, index: item.id)
                         .navigationTitle("Edit cart")
                 }label:{
                     OrderItemView(orderItem: item)
                 }
             }
         }
         .navigationTitle("Order Summary")
    }
}

#Preview {
    var cart = Cart()
    var orderItem = OrderItem(recipe: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 20.2, media_file: "/static/img/menu_items/77.jpg", availability: true,
options: [Option(id: 0, name: "Extra Pasta", price_adjustment: 2.0, toggled: true),
          Option(id: 1, name: "Extra Soup", price_adjustment: 2.0)]), quantity: 2)
    var orderItem2 = OrderItem(recipe: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 20.2, media_file: "/static/img/menu_items/77.jpg", availability: true,
options: [Option(id: 0, name: "Extra Meat", price_adjustment: 21.0, toggled: true),
          Option(id: 1, name: "Extra Soup", price_adjustment: 2.0)]), quantity: 4)
    cart.add(orderItem: orderItem)
    cart.add(orderItem: orderItem2)
    
    
   return  CartDisplay(cart: cart)
}
