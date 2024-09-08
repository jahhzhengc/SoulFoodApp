//
//  Cart.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 4/9/24.
//

import Foundation

class Cart: ObservableObject{
    @Published var items: [OrderItem] = []
    func add(orderItem: OrderItem){
        items.append(orderItem)
    }
    func remove(orderItem: OrderItem) {
        if let index = items.firstIndex(where: { $0.id == orderItem.id }) {
            items.remove(at: index)
        }
    }
    
    func getTotalPrice()-> String{
        if(items.count == 0) {
            return "$ 0.00"
        }
        let totalPrice = items.map{ $0.totalPrice}.reduce(0, +)
        
        return items[0].recipe.parsedPrice(toParse: totalPrice)
    }
    func updateOrderItem (uuid: UUID, orderItem: OrderItem){
        if let index = items.firstIndex(where: {$0.id == uuid}){
            print("update: \(uuid)")
            items[index].recipe = orderItem.recipe
            items[index].quantity = orderItem.quantity
            objectWillChange.send()
            print(items[index])
        }
    }
}

extension Double{
    func parsedPrice(price: Double)->String{
        return "$ " + String(format: "%.2f", price)
    }
}
