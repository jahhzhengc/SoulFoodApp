import SwiftUI

struct RecipesList: View {
    @State private var recipes = [Recipe]()
    @State private var root: String = "http://127.0.0.1:8000"
    @State private var url = "/api/recipes"
    @State private var loaded : Bool = false
    
    @State private var isShowingSheet = false
    @State private var searchQuery: String = ""
     
    @StateObject private var cart = Cart()
    
    @State private var categories = [Category] ()

//    var groupedRecipes: [String: String] = []
    
//            List(searchedRecipes, id: \.id) { recipe in
//                NavigationLink{
//                    RecipeDetailsView(recipeDetails: recipe, cart: cart)
//                        .navigationTitle(recipe.name)
//                        .navigationBarTitleDisplayMode(.inline)
//                }label:{
//                    RecipeView(recipeDetails: recipe)
//                }
//            } 
    @State private var favourited  = false
    var body: some View {
        let groupedRecipes = Dictionary(grouping: searchedRecipes, by: { $0.category })

       //TODO either make a horizontal scrollview that helps user gets to their preferred category
        
        // probably include a show favourite button here & there
        NavigationStack{
//        NavigationView {
            
            List{
                ForEach(categories, id: \.self){ category in
                    Section(header: Text(category.name).font(.headline)) {
                        ForEach(groupedRecipes[category] ?? []) { recipe in
                            NavigationLink{
                               RecipeDetailsView(recipeDetails: recipe, cart: cart)
                                   .navigationTitle(recipe.name)
                                   .navigationBarTitleDisplayMode(.inline)
                           }label:{
//                               if (recipe.favourited){
                                   RecipeView(recipeDetails: recipe)
//                               }
                           }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.automatic)
//            .listStyle(SidebarListStyle())
            .searchable(text: $searchQuery, prompt: "Search for recipes")
            .overlay(alignment: .bottomTrailing){
                NavigationLink{
                    CartDisplay(cart: cart)
                }label:{
                    cartBtn
                }
                .navigationTitle("Cart")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                .disabled(cart.items.count < 1)
            }
             
        }
     
        .onAppear(perform: loadRecipes)
    }
     
    @State private var changeColor = false
    var cartBtn: some View{
        ZStack {
            Circle()
              .fill(.blue.gradient)
              .frame(width: 80, height: 80)
              .overlay(
                  Circle().stroke(.gray.gradient, lineWidth: 1)
              )
              .shadow(color: .blue, radius: (changeColor ? 7 : 5)) // Change the order of shadow animation
              .onAppear {
                  withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                      changeColor.toggle()
                  }
              }
 
            Image(systemName: "cart.badge.plus")
                .resizable()
                .scaledToFit() // Ensures the image fits within its container
                .frame(width: 40, height: 40) // Adjust the size of the image itself
                .foregroundStyle(.white)
                
        }
        .frame(width: 80, height: 80)
        .fixedSize()    
        .opacity(cart.items.count < 1 ? 0.0 : 1.0)
        .animation(.easeInOut(duration: 0.6), value: cart.items.count < 1)
    }
    
    var favouritedRecipe: [Recipe]{
        return recipes.filter{ $0.favourited}
    }
    var searchedRecipes:[Recipe] {
        if searchQuery.isEmpty{
            return recipes
        }
        return recipes.filter {$0.name.contains(searchQuery)}
    }
    func loadRecipes() {
        guard let url = URL(string: root + url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
              do {
                  let decodedResponse = try JSONDecoder().decode([Recipe].self, from: data)
                  DispatchQueue.main.async {
                      self.recipes = decodedResponse
                          .sorted(by: {($0.category.display_order_mobile, $0.category.name) < ($1.category.display_order_mobile, $1.category.name) })
                      
                      self.categories = Array(Set(decodedResponse.map { $0.category }))
                          .sorted(by: {  ($0.display_order_mobile, $0.name) < ($1.display_order_mobile, $1.name) })
                      
                      loadFavourites()
                      self.loaded = true
                  }
              } catch {
                  print("Failed to decode JSON: \(error.localizedDescription)")
              }
              return
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
        
       
    }
    
    @State private var recipeFavourites = [Int]()
    func loadFavourites(){
        let request = TokenManager.shared.wrappedRequest(sendReq: root + "/api/favourites/")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                do{
                    let decodedResponse = try JSONDecoder().decode([RecipeFavourite].self, from: data)
                    DispatchQueue.main.async{
                        
                        for i in 0..<decodedResponse.count{
                            for j in 0..<recipes.count{
                                if recipes[j].id == decodedResponse[i].recipe {
                                    recipes[j].favourited = true
                                    break
                                }
                            }
//                            if let recipe = recipes.first(where: { $0.id == decodedResponse[i].recipe  }) {
//                                print(recipe.name)
//                            }
                        }
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
                return
            }
            
        }
        .resume()
    }
}

#Preview {
    RecipesList()
        .modelContainer(for: Item.self, inMemory: true) 
}
       
