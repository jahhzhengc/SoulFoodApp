import SwiftUI

struct RecipesList: View {
    @State private var recipes = [Recipe]()
    @State private var filteredRecipes : [Recipe] = []
    @State private var root: String = "http://127.0.0.1:8000"
    @State private var url = "/api/recipes"
    @State private var loaded : Bool = false
    
    @State private var isShowingSheet = false
    @State private var searchQuery: String = ""
    var body: some View {
        //        NavigationSplitView{
        
        NavigationStack{
            LabeledContent {
                TextField("Search for recipes", text: $searchQuery)
                    // i prefer a 'after finish typing for .5s' type of onChange instead of these instant kind
                    // but idk if SwiftUI has it
                    .onChange(of: searchQuery){ oldValue, newValue in
                        let _filteredRecipes = recipes.filter { recipe in
                            return recipe.name.contains(searchQuery)
                        }
                        filteredRecipes = _filteredRecipes
                    }
                    .padding(5)
                    .padding(.horizontal,5)
                    .background(.gray.opacity(0.14))
                    .cornerRadius(2)
                    .overlay(
                        HStack{
                            Spacer()
                            if !searchQuery.isEmpty {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .onTapGesture {
                                        searchQuery = ""
                                    }
                                    .padding(.trailing, 8)
                            }
                        }
                        )
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .padding()
             
            VStack {
                if(searchQuery.isEmpty){
                    List(recipes, id: \.id) { recipe in
                        NavigationLink{
                            RecipeDetailsView(recipeDetails: recipe)
                        }label:{
                            RecipeView(recipeDetails: recipe)
                        }
                    }
                    .navigationTitle("Menu")
                    .navigationBarTitleDisplayMode(.automatic)
                }
                else{
                    List(filteredRecipes, id: \.id) { recipe in
                        NavigationLink{
                            RecipeDetailsView(recipeDetails: recipe)
                        }label:{
                            RecipeView(recipeDetails: recipe)
                        }
                    }
                    .navigationTitle("Search result")
                    .navigationBarTitleDisplayMode(.automatic)
                }
            }
            //            .navgationDestination(for: recipe)
        }
        .onAppear(perform: loadRecipes)
        
        
    }
    func didDismiss(){
        
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

struct Recipe: Codable {
    var id: Int
    var name: String
    var desc: String
    var price: Double
    var availability: Bool
    var media_file: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, desc, price, availability, media_file
    }
    init(name: String, desc: String, media_file:String, price:Double){
        self.availability = true
        self.price = price
        self.name = name
        self.desc = desc
        self.media_file = media_file
        self.id = -1
    }
    
    init(id: Int, name: String, desc: String, price: Double, media_file: String, availability: Bool){
        self.id = id
        self.name = name
        self.desc = desc
        self.price = price
        self.media_file = media_file
        self.availability = availability
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        desc = try container.decode(String.self, forKey: .desc)
        let priceString = try container.decode(String.self, forKey: .price)
        price = Double(priceString) ?? 0.0
        availability = try container.decode(Bool.self, forKey: .availability)
        media_file = try container.decode(String.self, forKey: .media_file)
    }
    func parsedPrice()->String{
        return "$ " + String(format: "%.2f", self.price)
    }
}

struct Category: Codable {
//    name = models.CharField(max_length = 100)
//     display_order_web = models.IntegerField(default=0)  # Order for web display
//     display_order_mobile = models.IntegerField(default=0)  # Order for mobile display
    
}

struct Option: Codable{
    var name: String
    var price_adjustment: Decimal
//    class MenuItemOptions(models.Model):
//    name = models.CharField(max_length=100)
//    price_adjustment = models.DecimalField(decimal_places=2, max_digits=7, default = 0.00)# can be null
//    
//    def __str__(self):
//    return f"{self.name} ({'+' if self.price_adjustment >= 0 else ''}{self.price_adjustment})"
    
}

struct AddOn: Codable{
    var price_adjustment: Decimal
    
//    main_recipe = models.ForeignKey(Recipe, related_name='addon_main_recipe', on_delete=models.CASCADE)
//    add_on_recipe = models.ForeignKey(Recipe, related_name='addon_recipe', on_delete=models.CASCADE)
//    price_adjustment = models.DecimalField(max_digits=6, decimal_places=2, default=0.00)
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
