//
//  CartDisplay.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 5/9/24.
//

import SwiftUI

struct CartDisplay: View {
    @ObservedObject var cart: Cart  // Reference the shared cart
    
    enum OrderType : String, CaseIterable, Identifiable {
        case Delivery = "Delivery"
        case PickUp = "Pick Up"
        case HavingHere = "Having Here"
         
        var id: String { self.rawValue }
    }
    
    @State var orderType : OrderType = .Delivery
    
    @Environment(\.dismiss) private var dismiss
      
    @State private var topExpanded: Bool = true
    
    @State private var promoCode: String = ""
    
    @FocusState private var isFocused: Bool
    let flatDeliveryFee : Double = 3.59
    var body: some View {
        
        VStack {
            Picker("Select an option", selection: $orderType) {
                ForEach(OrderType.allCases) { option in
                    Text(option.rawValue.capitalized).tag(option)
                }
            }
            .pickerStyle(.segmented)
            List{
                ForEach(cart.items, id: \.self.id){ item in
                    NavigationLink{
                        RecipeDetailsView(recipeDetails: item.recipe, num: item.quantity, cart: cart
                                          ,edit: true, index: item.id)
                        .navigationTitle("Edit cart")
                        .navigationBarTitleDisplayMode(.automatic)
                        
                    }label:{
                        OrderItemView(orderItem: item)
                    }
                }
                .onDelete(perform: removeRows)
                
                
            }
            .listStyle(PlainListStyle())
            .foregroundStyle(.black)
            .background(.gray.opacity(0.1).gradient)
            .scrollContentBackground(.hidden)
            
//            .background(.red)
//            .frame(width: .infinity)
            
            VStack{
                TextField("Enter promo or gift code here", text: $promoCode, onEditingChanged: { (editingChanged) in
                    if editingChanged {
                        print("TextField focused")
                    } else {
                        print("TextField focus removed")
                    }
                })
                    .padding()
                    .background(.gray.opacity(0.2))
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                    .overlay{
                        RoundedRectangle(cornerRadius: 20).stroke(.gray, lineWidth: 1)
                    }
                    .padding(.bottom, 12)
//                    .onChange(of: promoCode) { _, newValue in
////                        guard let newValueLastChar = newValue.last else { return }
//                        print(newValue)
//                    }
                    .keyboardType(.asciiCapableNumberPad)
                    .focused($isFocused)
                    .onSubmit {
                        print("onSubmit")
                    }
                HStack{
                    Text("Subtotal (Incl. Tax)")
                    Spacer()
                    Text("\(cart.getTotalPrice())")
                }
                if (orderType == .Delivery){
                    HStack{
                        Text("Delivery fee")
                        Spacer()
                        Text("\(flatDeliveryFee.parsedPrice())")
                    }
                }
                Divider()
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Order Summary")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            Button{
                cart.items.removeAll()
                dismiss()
            }label:{
                Text("Clear Cart")
            }
        }
        
        sendOrderBtn
    }
      func removeRows(at offsets: IndexSet) {
          cart.items.remove(atOffsets: offsets)
          if(cart.items.count < 1){
              dismiss()
          }
      }
    
    var sendOrderBtn : some View{
        
        Button{
            
            dismiss()
        }label:{
            let text =  "Total (incl. tax) \((flatDeliveryFee + cart.totalPrice).parsedPrice() )"
            Label(text, systemImage:  "cart.fill")
                .foregroundStyle(.white)
        }
        .padding()
        .background(.blue)
        .buttonStyle(.borderedProminent)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke(.gray, lineWidth: 0)
        }
    }
    
//    func delete(at offsets: IndexSet) {
//        cart.remove(orderItem: offsets)
//    }
}

#Preview {
    let cart = Cart()
    let orderItem = OrderItem(recipe: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 20.2, media_file: "/static/img/menu_items/77.jpg", availability: true,
options: [Option(id: 0, name: "Extra Pasta", price_adjustment: 2.0, toggled: true),
          Option(id: 1, name: "Extra Soup", price_adjustment: 2.0)]), quantity: 2)
    let orderItem2 = OrderItem(recipe: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 20.2, media_file: "/static/img/menu_items/77.jpg", availability: true,
options: [Option(id: 0, name: "Extra Meat", price_adjustment: 21.0, toggled: true),
          Option(id: 1, name: "Extra Soup", price_adjustment: 2.0)]), quantity: 4)
    cart.add(orderItem: orderItem)
    cart.add(orderItem: orderItem2)
    
    
   return  CartDisplay(cart: cart)
}
