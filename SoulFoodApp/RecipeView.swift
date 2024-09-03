//
//  RecipeView.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 2/9/24.
//

import SwiftUI

struct RecipeView: View {
    var recipeDetails: Recipe
    @State private var root: String = "http://127.0.0.1:8000"
    var body: some View {
        ZStack(alignment: .bottomTrailing){ 
            HStack(alignment:.top){
                AsyncImage(url: URL(string: root + recipeDetails.media_file)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 200)
                 
                VStack(alignment: .leading){
                    Text(recipeDetails.name)
                        .frame(alignment: .topLeading)
                        .fontWeight(.medium)
                        .font(.title)
//                    Text(recipeDetails.media_file)
                    Text(summarise(text: recipeDetails.desc, limit: 10))
                        .fontWeight(.ultraLight)
                    Text(parsedPrice())
                }
            }
            Spacer()
        }
    }
    
    func summarise(text: String, limit: Int)-> String{
        let descriptions = text.split(separator: " ")
        let limitedWords = descriptions.prefix(limit)
        return limitedWords.joined(separator: " ") + "..."
    }
    func parsedPrice()->String{
        return "$ " + String(format: "%.2f", recipeDetails.price)
    }
}

#Preview {
    RecipeView(recipeDetails: Recipe(id: 2, name: "Mini Pumpkin Chocolate Chip Muffins",
                                     desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!", price: 2.2,
                                     media_file: "/static/img/menu_items/77.jpg", availability: true))
        
}
