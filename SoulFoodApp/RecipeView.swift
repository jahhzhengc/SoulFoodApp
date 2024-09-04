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
    @State private var isSet: Bool = false
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            HStack(alignment:.top){
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
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 12.5))
                            .overlay{
                                RoundedRectangle(cornerRadius: 12.5).stroke(.black, lineWidth: 2)
                            }
                            .shadow(radius: 5)
                            .padding(2)
                    } placeholder: {
                        ProgressView()
                    }
                    
                VStack(alignment: .leading){
                    Text(recipeDetails.name)
                        .frame(alignment: .topLeading)
                        .fontWeight(.medium) 
                        .lineLimit(2)
//                    Text(recipeDetails.media_file)
//                    Text(summarise(text: recipeDetails.desc, limit: 10))
                    Text(recipeDetails.desc)
                        .lineLimit(2)
                        .fontWeight(.light)
                        .foregroundStyle(.gray)
                     
                    Text(recipeDetails.parsedPrice()) 
                        
                       
                    
                }.padding(2)
            }
            Spacer()
        }
    }
    
    func summarise(text: String, limit: Int)-> String{
        let descriptions = text.split(separator: " ")
        let limitedWords = descriptions.prefix(limit)
        return limitedWords.joined(separator: " ") + "..."
    }
}

#Preview {
    RecipeView(recipeDetails: Recipe( name: "Mini Pumpkin Chocolate Chip Muffins",
                                     desc: "Mini Pumpkin Chocolate Chip Muffins made lighter by swapping out butter for pumpkin puree loaded with chocolate chips in every bite!",
                                     media_file: "/static/img/menu_items/77.jpg", price: 2.2))
}
