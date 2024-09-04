//
//  RecipeDetailsView.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 3/9/24.
//

import SwiftUI

struct RecipeDetailsView: View {
    @State var recipeDetails : Recipe
    @State private var root: String = "http://127.0.0.1:8000"
    @State private var num : Int = 0
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var cart: Cart  // Reference the shared cart
    
    @State private var isOn : Bool = false
    var body: some View {
         
        ScrollView(.vertical, showsIndicators: false){
            AsyncImage(url: URL(string: root + recipeDetails.media_file)) { image in
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
            
            // - 1 + UI
            HStack(alignment: .center){
                Button{
                    if(self.num > 0){
                        self.num -= 1
                    }
                } label:{
                    Image(systemName: "minus.circle.fill")
                }
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
            .overlay{
                RoundedRectangle(cornerRadius: 40).stroke(.gray, lineWidth: 0)
                
            }
            
//            Spacer()
            
            if(num > 0){
                Button{
                    cart.add(recipe: recipeDetails)
                    print(cart.$items)
                    dismiss()
                }label:{
                    Label("Add To Cart", systemImage:  "cart.fill")
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
        .navigationTitle(recipeDetails.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RecipeDetailsView(recipeDetails: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
                                     desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 2.2,
                                            media_file: "/static/img/menu_items/77.jpg", availability: true,
                                            
                                            options: [Option(id: 0, name: "Extra Pasta", price_adjustment: 2.0),
                                                      Option(id: 1, name: "Extra Soup", price_adjustment: 2.0)]

                                           ), cart: Cart())
        
}
