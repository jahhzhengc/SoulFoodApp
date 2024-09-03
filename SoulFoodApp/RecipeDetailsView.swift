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
                    .aspectRatio(1, contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .clipped()
            .overlay{
                Rectangle().stroke(.gray, lineWidth: 1)
            }
            .padding(1)
            
            HStack{
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
            
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 40, height: 40))
                    .fill(.mint)
                    .frame(width:80, height: 40)
                
                HStack{
                    
                    Button{
                        if(self.num > 0){
                            self.num -= 1
                        }
                    } label:{
                        Image(systemName: "minus.circle.fill")
                    }
                    Text(String(self.num))
                        .foregroundStyle(.white)
                    Button{
                        if(self.num < 50){
                            self.num += 1
                        }
                    } label:{
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Action for the button
                    print("Trailing button tapped")
                }) {
                    Text("Done")
                }
            }
        }
        
   
        
    }
}

#Preview {
    RecipeDetailsView(recipeDetails: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
                                     desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 2.2,
                                     media_file: "/static/img/menu_items/77.jpg", availability: true))
        
}
