import SwiftUI

struct RecipesList: View {
    @State private var recipes = [Recipe]()
    @State private var root: String = "http://127.0.0.1:8000"
    @State private var url = "/api/recipes"
    @State private var loaded : Bool = false
    
    @State private var isShowingSheet = false
    @State private var searchQuery: String = ""
    
    @State private var cart = [Recipe]()

    var body: some View {
        NavigationView{
            VStack {
                List(searchedRecipes, id: \.id) { recipe in
                    NavigationLink{
                        RecipeDetailsView(recipeDetails: recipe)
                    }label:{
                        RecipeView(recipeDetails: recipe)
                    }
                }
                .navigationTitle("Menu")
                .navigationBarTitleDisplayMode(.automatic)
            }
            .searchable(text: $searchQuery, prompt: "Search for recipes")
            Spacer()
        }
        .onAppear(perform: loadRecipes)
    }
    
    var searchedRecipes:[Recipe] {
        if searchQuery.isEmpty{
            return recipes
        }
        return recipes.filter {$0.name.contains(searchQuery)}
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
    var category: Category
    var options : [Option]
    enum CodingKeys: String, CodingKey {
        case id, name, desc, price, availability, media_file, category, options
    }
    init(){
        self.availability = true
        self.name = ""
        self.desc = ""
        self.id = -1
        self.media_file = ""
        self.price = 0
        self.category = Category()
        self.options = []
    }
    init(name: String, desc: String, media_file:String, price:Double){
        self.availability = true
        self.price = price
        self.name = name
        self.desc = desc
        self.media_file = media_file
        self.id = -1
        self.category = Category()
        self.options = []
    }
    
    init(id: Int, name: String, desc: String, price: Double, media_file: String, availability: Bool){
        self.id = id
        self.name = name
        self.desc = desc
        self.price = price
        self.media_file = media_file
        self.availability = availability
        self.category = Category()
        self.options = []
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
        category = try container.decode(Category.self, forKey: .category)
        options = try container.decode([Option].self, forKey: .options)
        print(options)
    }
    func parsedPrice()->String{
        return "$ " + String(format: "%.2f", self.price)
    }
}

struct Category: Codable {
    var name: String
    var display_order_mobile : Int 
    
    init(){
        self.name = ""
        self.display_order_mobile = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case  name, display_order_mobile
    }
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        display_order_mobile = try container.decode(Int.self, forKey: .display_order_mobile)
    }
}

struct Option: Codable{
    var name: String
    var price_adjustment: Double
    
    init(){
        self.name = ""
        self.price_adjustment = 0.0
    }
    
    enum CodingKeys: String, CodingKey {
        case  name, price_adjustment
    }
    init(from decoder:Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let priceString = try container.decode(String.self, forKey: .price_adjustment)
        price_adjustment = Double(priceString) ?? 0.0
    }
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
