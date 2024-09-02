import SwiftUI

struct Test: View {
    @State private var recipes = [Recipe]()
    @State private var root: String = "http://127.0.0.1:8000"
    @State private var url = "/api/recipes"
    @State private var loaded : Bool = false
    var body: some View {
        NavigationStack{
            List(recipes, id: \.id) { recipe in
                HStack{
                    Text(recipe.name)
                    ImageView(withURL:(root + recipe.media_file))
                        .frame(alignment: .trailing)
                }
            }
        }
        .onAppear(perform: loadRecipes)
        .navigationTitle("Recipe")
        .navigationBarTitleDisplayMode(.large)
        
    }
    
    func loadRecipes() {
        if loaded {
            print("Already loaded")
            return
        }
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
    var price: Decimal
    var availability: Bool
    var media_file: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, desc, price, availability, media_file
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        desc = try container.decode(String.self, forKey: .desc)
        let priceString = try container.decode(String.self, forKey: .price)
        price = Decimal(string: priceString) ?? 0.0
        availability = try container.decode(Bool.self, forKey: .availability)
        media_file = try container.decode(String.self, forKey: .media_file)
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
    Test()
        .modelContainer(for: Item.self, inMemory: true)
}
      
//"category": 6,
//"options": [
//    1,
//    2
//],
//"add_ons": []
//},
