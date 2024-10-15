//
//  HomePage.swift
//  SoulFoodApp
//
//  Created by Jia Zheng Cheong on 15/10/24.
//

import SwiftUI

struct HomePage: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView (selection: $selectedTab)
        {
            RecipesList()
                .tabItem {
                    Label("Menu", systemImage:"list.bullet.rectangle.fill")
                }
            
            ProfilePage()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        
    }
}

#Preview {
    HomePage()
}
