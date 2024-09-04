//
//  RecipeDetailsView.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 3/9/24.
//

import SwiftUI

struct RecipeDetailsView: View {
    var recipeDetails : Recipe
    @State private var root: String = "http://127.0.0.1:8000"
    @State private var num : Int = 0
    var body: some View {
        
        VStack{
            AsyncImage(url: URL(string: root + recipeDetails.media_file)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity)
                    .aspectRatio(1, contentMode: .fill)
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
            
            Spacer()
            
            Button{
                print("Button tapped")
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
        .navigationTitle(recipeDetails.name)
        .navigationBarTitleDisplayMode(.inline)
        .frame(alignment: .top)
        //            .edgesIgnoringSafeArea(.top)
        //            .ignoresSafeArea(.all)
        //            Button{
        //                dismiss()
        //            }label:{
        //                Image(systemName: "xmark.circle.fill")
        //                    .frame(width: 200, height: 200)
        //                    .padding()
        //            }
        
        
    }
}

#Preview {
    RecipeDetailsView(recipeDetails: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
                                     desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 2.2,
                                     media_file: "/static/img/menu_items/77.jpg", availability: true))
        
}
