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
         Text("Order Summary")
             .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
         ForEach(cart.items){ item in
             Text(item.name)
         }
        
    }
}

#Preview {
    var cart = Cart()
    
    cart.add(recipe: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
                       desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 2.2,
                          media_file: "/static/img/menu_items/77.jpg", availability: true,
                              
                              options: [Option(id: 0, name: "Extra Pasta", price_adjustment: 2.0),
                                        Option(id: 1, name: "Extra Soup", price_adjustment: 2.0)]
))
   return  CartDisplay(cart: cart)
}
