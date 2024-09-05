//
//  OrderItemView.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import SwiftUI

struct OrderItemView: View {
    @State var orderItem: OrderItem
    var body: some View {
        HStack (alignment: .top){
            Text(String(orderItem.quantity) + "x")
            
            VStack (alignment: .leading){
                Text(orderItem.recipe.name)
                    .fontWeight(.bold)
                
                ForEach(orderItem.recipe.options) { option in
                    if(option.toggled){
                        Text(option.name)
                    }
                } 
            }
            Spacer()
            Text(orderItem.getTotalPrice)
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay{
            RoundedRectangle(cornerRadius: 10).stroke(.gray, lineWidth: 1)
        }
        .padding()
        
    }
}

#Preview {
    var orderItem = OrderItem(recipe: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 20.2, media_file: "/static/img/menu_items/77.jpg", availability: true,
options: [Option(id: 0, name: "Extra Pasta", price_adjustment: 2.0, toggled: true),
          Option(id: 1, name: "Extra Soup", price_adjustment: 2.0)]), quantity: 2)
    
    return OrderItemView(orderItem: orderItem)
}
