import SwiftUI

struct RecipesList: View {
    @State private var recipes = [Recipe]()
    @State private var url = "/api/recipes"
    @State private var loaded : Bool = false
    
    @State private var isShowingSheet = false
    @State private var searchQuery: String = ""
     
    @StateObject private var cart = Cart()
    
    @State private var categories = [Category] ()
    
    @ObservedObject var tokenManager = TokenManager.shared
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
    @State private var selectedCategory: Category? = nil // To track the selected category

    @State private var favourited  = false
    var body: some View {
        let groupedRecipes = Dictionary(grouping: searchedRecipes, by: { $0.category}).filter{ !$0.value.isEmpty}
         
//        print(groupedRecipes.isEmpty)
       //TODO either make a horizontal scrollview that helps user gets to their preferred category
        
        // probably include a show favourite button here & there
        NavigationStack{
            
            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    ForEach(categories, id: \.self) { category in
//                        Button(action: {
//                            // Scroll to the selected category
//                            selectedCategory = category
//                        }) {
//                            Text(category.name)
//                                .padding()
//                                .background(selectedCategory == category ? Color.blue : Color.gray)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                                
//                        }
////                        .padding()
////                        .frame(height: 40)
//                    }
//                }
//            
//                .padding(.horizontal)
//                .padding(10)
//            }
//            ScrollViewReader { proxy in
            VStack{
                List{
                    ForEach(categories, id: \.self){ category in
                        if let recipes = groupedRecipes[category], !recipes.isEmpty { 
                            Section(header: Text(category.name).font(.headline).id(category.id)) {
                                ForEach(groupedRecipes[category] ?? []) { recipe in
                                    NavigationLink{
                                        RecipeDetailsView(recipeDetails: recipe, cart: cart)
                                            .navigationTitle(recipe.name)
                                            .navigationBarTitleDisplayMode(.inline)
                                    }label:{
                                        RecipeView(recipeDetails: recipe)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(SidebarListStyle())
                //                .listStyle(PlainListStyle())
                .navigationTitle("Menu")
                .navigationBarTitleDisplayMode(.automatic)
                .searchable(text: $searchQuery, prompt: "Search for recipes")
                .textInputAutocapitalization(.never)
                .overlay{
                    // if I'm searching something, but its returning nothing
                    if !searchQuery.isEmpty && groupedRecipes.isEmpty{
                        ContentUnavailableView(
                            "Product not available",
                            systemImage: "magnifyingglass",
                            description: Text("No results for \(searchQuery)")
                        )
                        
                        
                    }
                }
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
                .toolbar{
                    Button{
                        showFavourite.toggle()
                    }label:{
                        Label("test", systemImage: showFavourite ? "star.fill" : "star")
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
//                .onChange(of: selectedCategory) { category in
//                    // Scroll to the selected category section
//                    print(category)
//                    if let category = category {
//                        print(category.id)
//                        withAnimation (.easeInOut) {
//                            // so its scroll to categories's recipe
//                            proxy.scrollTo(category.id, anchor: .top)
//                        }
//                    }
//                }
//            }
            
             
        }
     
        .onAppear(perform: loadRecipes)
    }
    @State private var showFavourite = false
     
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
        // searchQuery isEmpty // showFAvourite is true
        var toReturn = recipes
        
        if(showFavourite){
            toReturn = toReturn.filter{$0.favourited}
        }
        if searchQuery.isEmpty  {
            print(toReturn.count)
            return toReturn
        }
        
        toReturn = recipes.filter {$0.name.lowercased().contains(searchQuery.lowercased())}
      
        return toReturn
    }
    func loadRecipes() {
        guard let url = URL(string: tokenManager.root + url) else {
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
        let request = tokenManager.wrappedRequest(sendReq: tokenManager.root + "/api/favourites/")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data{
                do{
                    let decodedResponse = try JSONDecoder().decode([RecipeFavourite].self, from: data)
                    DispatchQueue.main.async{
                        
                        for decodedRecipe in decodedResponse {
                               if let index = recipes.firstIndex(where: { $0.id == decodedRecipe.recipe }) {
                                   recipes[index].updateFavourite(to: true)

                                   print(String(recipes[index].favourited) + " " + recipes[index].name)
                               }
                           }
//
//                        for i in 0..<decodedResponse.count{
//                            for j in 0..<recipes.count{
//                                if recipes[j].id == decodedResponse[i].recipe {
//                                    var newR = recipes[j]
//                                    newR.updateFavourite(to: true)
//                                    recipes[j] = newR
//                                    recipes[j].favourited = true
//                                    print(String(recipes[j].favourited) + " " + recipes[j].name)
//                                    break
//                                }
//                            }
//                        }
                        
                        print(recipes.filter{ $0.favourited == true}.count)
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
       
