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
                }label:{
                    RecipeView(recipeDetails: recipe)
                }
            }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.automatic)
            .searchable(text: $searchQuery, prompt: "Search for recipes")
        }
        .onAppear(perform: loadRecipes)
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
