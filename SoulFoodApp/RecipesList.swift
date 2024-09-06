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

    var body: some View {
        NavigationStack {
            List(searchedRecipes, id: \.id) { recipe in
                NavigationLink{
                    RecipeDetailsView(recipeDetails: recipe, cart: cart)
                        .navigationTitle(recipe.name)
                        .navigationBarTitleDisplayMode(.inline)
                }label:{
                    RecipeView(recipeDetails: recipe)
                }
            }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.automatic)
            .searchable(text: $searchQuery, prompt: "Search for recipes")
            .overlay(alignment: .bottomTrailing){
                
                NavigationLink{
                    CartDisplay(cart: cart)
                }label:{
                    btmRightBtn
                } 
                .navigationTitle("Cart")
                .navigationBarTitleDisplayMode(.inline)
                .padding()
                .disabled( cart.items.count < 1)
            }
             
        }
     
        .onAppear(perform: loadRecipes)
    }
    
    var btmRightBtn: some View{
        ZStack {
            Circle()
                .fill(.blue.gradient)
                .frame(width: 80, height: 80)
                .overlay(
                    Circle().stroke(.gray.gradient, lineWidth: 1)
                )
                .shadow(color: .blue, radius: 4)

            Image(systemName: "cart.badge.plus")
                .resizable()
                .scaledToFit() // Ensures the image fits within its container
                .frame(width: 40, height: 40) // Adjust the size of the image itself
                .foregroundStyle(.white)
        }
        .frame(width: 80, height: 80)
        .opacity(cart.items.count < 1 ? 0.0 : 1.0)
        .animation(.easeInOut(duration: 0.6), value: cart.items.count < 1)


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
}

#Preview {
    RecipesList()
        .modelContainer(for: Item.self, inMemory: true) 
}
      
//"category": 6,
//"options": [
//    1,
//    2
//],
//"add_ons": []
//},
