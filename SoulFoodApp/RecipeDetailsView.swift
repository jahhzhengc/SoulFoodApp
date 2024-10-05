//
//  RecipeDetailsView.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 3/9/24.
//

import SwiftUI

struct RecipeDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var recipeDetails : Recipe
    @State var num : Int = 1
    // somehow differentiates the difference between
    @ObservedObject var cart: Cart  // Reference the shared cart
//    @ObservedObject var referencedRecipe: Recipe
    @State var edit: Bool = false
    @State var index: UUID = UUID()
    
    @State var favourited: Bool = false
    
    @State private var toast: Toast? = nil
    var body: some View {
         
        ScrollView(.vertical, showsIndicators: false){
            AsyncImage(url: URL(string: TokenManager.shared.root + recipeDetails.media_file)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0,
                      maxWidth: .infinity,
                      minHeight: 0,
                      maxHeight: .infinity)
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .overlay(alignment: .topTrailing){
                favouriteBtn
                    .frame(alignment: .leading)
            }
            .clipped()
            .overlay{
                Rectangle().stroke(.gray, lineWidth: 1)
            }
            .padding(1)
            
            HStack (alignment: .top){
                Text(recipeDetails.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                
                Spacer()
                
                
                Text(recipeDetails.parsedPrice())
            }
            .padding()
            
            Spacer().frame(height: 15)
            
            Text(recipeDetails.desc)
                .fontWeight(.ultraLight)
                .padding()
            
            if(recipeDetails.options.count > 0){
                addOnSection
            }
            
            customStepper
            
            if(num > 0){
                addToCartBtn
            }
        }
        .toastView(toast: $toast)
    }
    
    let width :CGFloat = 100
    var favouriteBtn: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.blue.gradient)
                .frame(width: width, height: width/2)
                .offset(x: width / 2)
                .clipped()
                .offset(x: -width / 4)
                .frame(width: width / 2)
            
            Image(systemName:(favourited ? "star.fill": "star"))
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 30)
                .onTapGesture {
//                    favourited.toggle()
                    if(favourited){
                        removeRecipeFavourite()
                    }
                    else{
                        setRecipeFavourite()
                        toast = Toast(style: .success, message: "This menu item is now added to your favourite list.") 
                    }
                }
                .foregroundStyle(.yellow.gradient)
            
        }.onAppear{
            loadRecipeFavourite()
        }
    }
    func setRecipeFavourite(){
        let url = TokenManager.shared.root + "/api/favourites/"
        
        var request = TokenManager.shared.wrappedRequest(sendReq: url)
          
        let json: [String: Any] = ["recipe_id": recipeDetails.id]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        request.httpMethod = "POST"
        request.httpBody = jsonData
          
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                  if let httpResponse = response as? HTTPURLResponse {
                     print(httpResponse.statusCode)
                      if(httpResponse.statusCode == 404){
                          print("ignored")
                          return
                      }
                 }
                  favourited = true
              return
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func removeRecipeFavourite(){
        let url = TokenManager.shared.root + "/api/favourites/\(recipeDetails.id)"
        
        var request = TokenManager.shared.wrappedRequest(sendReq: url)
           
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                  if let httpResponse = response as? HTTPURLResponse {
                     print(httpResponse.statusCode)
                      if(httpResponse.statusCode == 404){
                          print("ignored")
                          return
                      }
                 }
                  favourited = false
              return
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func loadRecipeFavourite() {
        let url = TokenManager.shared.root + "/api/favourites/\(recipeDetails.id)"
        
        var request = TokenManager.shared.wrappedRequest(sendReq: url)
        request.httpMethod = "GET"
          
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                  if let httpResponse = response as? HTTPURLResponse {
                     print(httpResponse.statusCode)
                      if(httpResponse.statusCode == 404){
                          print("ignored")
                          return
                      }
                 }
                  favourited = true
              return
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    var addOnSection: some View {
        VStack (alignment: .leading){
            Text("Add Ons    .")
                .font(.title2)
                .fontWeight(.heavy)
                .underline()
            ForEach(recipeDetails.options.indices, id:\.self) { index in
                HStack{
                    Image(systemName: recipeDetails.options[index].toggled ? "checkmark.circle.fill" : "circle")
                        .onTapGesture {
                            recipeDetails.options[index].toggled.toggle()
                        }
                    Text(recipeDetails.options[index].name)
                    Spacer()
                    Text(recipeDetails.options[index].getPriceAdjustment)
                }
            }
        }
        .padding()
        .overlay{
            RoundedRectangle(cornerRadius: 25).stroke(.gray, lineWidth: 1)
        }
        .padding()
    }
    
    var customStepper: some View{
        // - 1 + UI
        HStack(alignment: .center){
            Button{
                if(self.num > 1){
                    self.num -= 1
                }
            } label:{
                Image(systemName: "minus.circle.fill")
            }
            
            .disabled(self.num <= 1)
            Text(String(self.num))
                .fontWeight(.black)
            Button{
                if(self.num < 20){
                    self.num += 1
                }
            } label:{
                Image(systemName: "plus.circle.fill")
            }
        }
        .foregroundStyle(.white)
        .padding()
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        
    }
    
    var addToCartBtn : some View{
        Button{
            if !edit{
                
                var check = false
                for i in 0..<cart.items.count{
                    if(cart.items[i].recipe == recipeDetails){
                        cart.items[i].quantity += num
                        check = true
                        print("FOUND THE SAME RECIPE IN CART, it should add quantity instead")
                    }
                }
                
                if !check{
                    let orderItem = OrderItem(recipe: recipeDetails, quantity: num)
//                    print(orderItem.id)
                    cart.add(orderItem: orderItem)
                }
            }
            else{
                let orderItem = OrderItem(recipe: recipeDetails, quantity: num)
                cart.updateOrderItem(uuid: index, orderItem: orderItem)
            }
            dismiss()
        }label:{
            let text = !edit ?  "Add To Cart - " : "Edit Cart - "
            Label(text + (recipeDetails.allPriceConsideredString(quantity: num)), systemImage:  "cart.fill")
                .foregroundStyle(.white)
        }
        .padding()
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay{
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke(.gray, lineWidth: 0)
        }
    }
    
}

#Preview {
    RecipeDetailsView(recipeDetails: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
                                     desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 2.2,
                                            media_file: "/static/img/menu_items/77.jpg", availability: true,
                                            
                                            options: [Option(id: 0, name: "Extra Pasta", price_adjustment: 2.0),
                                                      Option(id: 1, name: "Extra Soup", price_adjustment: 2.0)]

                                           ), cart: Cart()
                    )
        
}
